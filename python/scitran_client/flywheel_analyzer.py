from __future__ import print_function
from scitran_client import ScitranClient
import time
import json
from concurrent.futures import ThreadPoolExecutor, CancelledError
import traceback
from fnmatch import fnmatch
from collections import namedtuple, Counter
import math


def _sleep(seconds):
    '''Sleeps .1 seconds at a time to make KeyboardInterrupt easier to catch.
    '''
    delta = .1
    assert seconds > delta, 'must sleep for longer than {}'.format(delta)
    for _ in range(int(math.ceil(seconds / delta))):
        time.sleep(delta)


state = {}


FlywheelAnalysisOperation = namedtuple('FlywheelAnalysisOperation', [
    'gear_name', 'create_inputs', 'label'])


def define_analysis(gear_name, create_inputs, label=None):
    '''Defines an analysis operation that can be passed to run(...).

    An analysis operation has a gear name, label (which defaults to
    the gear name), and a function that is used to create the inputs
    to job creation. This function will be supplied a list of analyses
    and a list of acquisitions as keyword arguments. This function will
    be expected to return either a dictionary of the job inputs or a tuple
    with a dictionary of the job inputs and a dictionary of the config
    inputs (to override the default config).
    '''
    label = label or gear_name
    return FlywheelAnalysisOperation(gear_name, create_inputs, label)


class FlywheelFileContainer(dict):
    def find_file(self, pattern):
        '''Find a file in this container with a name that matches pattern.

        This will look for a file in this container that matches the supplied
        pattern. Matching uses the fnmatch python library, which does Unix
        filename pattern matching.

        To find a specific file, you can simply match by name:
        > acquisition.find_file('anatomical.nii.gz')

        To find a file with an extension, you can use a Unix-style pattern:
        > stimulus_onsets.find_file('*.txt')
        '''
        # TODO make sure this throws for missing or multiple files.
        is_analysis = 'job' in self and 'state' in self

        # XXX if is_analysis then we should require the file to be an output??
        f = next(
            f for f in self['files']
            if fnmatch(f['name'], pattern))

        return dict(
            type='analysis' if is_analysis else 'acquisition',
            id=self['_id'],
            name=f['name']
        )


def find(items, _constructor_=FlywheelFileContainer, **kwargs):
    '''Finds the first item in `items` that matches the key, value pairs in `kwargs`.

    This is typically used to find an acquisition or analysis by specifying some
    properties to filter on in `kwargs`.

    To find an analysis by label:
    > fa.find(analyses, label='anatomical warp')

    To find an acquisition by measurement:
    > fa.find(acquisitions, measurement='diffusion')
    '''
    # TODO make this have better errors messages for missing files
    result = next((
        item for item in items
        if all(item[k] == v for k, v in kwargs.iteritems())
    ), None)
    return result and _constructor_(result)


def find_project(**kwargs):
    '''Finds a project that matches the key, value pairs in `kwargs`.

    To find a project by label:
    > fa.find_project(label='Reading Skill Study')
    '''
    return find(request('projects'), _constructor_=lambda x: x, **kwargs)


class ShuttingDownException(Exception):
    shutting_down = False


def request(*args, **kwargs):
    # HACK client is a module variable for now. In the future, we should pass client around.
    if 'client' not in state:
        state['client'] = ScitranClient()
    response = state['client']._request(*args, **kwargs)
    return json.loads(response.text)


def _defaults_for_gear(gear):
    return {
        key: value['default']
        for key, value in gear['config'].iteritems()
        if 'default' in value
    }


def _submit_analysis(session_id, gear_name, job_inputs, job_config, label):
    body = dict(
        job=dict(
            gear=gear_name,
            tags=['ad-hoc'],
            inputs=job_inputs,
            config=job_config,
        ),
        analysis=dict(label=label),
    )

    response = request(
        'sessions/{}/analyses'.format(session_id),
        method='POST',
        params=dict(job=True),
        data=json.dumps(body))
    return response['_id']


def _get_analyses(session_id):
    '''
    We make sure to fetch session.analyses because it respects
    deletion from the UI. session.jobs will show anything that has
    ever been run.
    '''
    session = request('sessions/{}'.format(session_id))
    return session.get('analyses') or []


def _wait_for_analysis(session_id, label):
    '''Waits for analysis to finish.

    Returns latest analyses to optimize upstream code
    '''
    while True:
        analyses = _get_analyses(session_id)
        analysis_response = find(analyses, label=label)
        if analysis_response['job']['state'] == 'complete':
            return analyses
        print(session_id, 'state', analysis_response['job']['state'])
        if ShuttingDownException.shutting_down:
            raise ShuttingDownException()
        _sleep(30)


def _analyze_session(operations, gears_by_name, session):
    acquisitions = None
    session_id = session['_id']
    analyses = _get_analyses(session_id)
    for gear_name, create_inputs, label in operations:
        analysis = find(analyses, label=label)

        # skip this analysis if we've already done it
        if analysis and analysis['job']['state'] == 'complete':
            continue

        print('waiting for' if analysis else 'starting', label, 'for session', session_id)

        if not analysis:
            # lazily download acquisitions to avoid unnecessary requests for sessions that
            # have completed analysis
            if not acquisitions:
                acquisitions = request('sessions/{}/acquisitions'.format(session_id))
            job_inputs = create_inputs(analyses=analyses, acquisitions=acquisitions)
            job_config = _defaults_for_gear(gears_by_name[gear_name])

            # When create_inputs returns a tuple, we unpack it into job_inputs and job_config.
            # The job_config returned by create_inputs can override or add to the config
            # defaults we have assembled from the gear manifest.
            if isinstance(job_inputs, tuple):
                job_inputs, job_config = job_inputs[0], dict(job_config, **job_inputs[1])
            _submit_analysis(session_id, gear_name, job_inputs, job_config, label)

        analyses = _wait_for_analysis(session_id, label)
    print(session_id, 'all analysis complete')


def _wait_for_futures(futures):
    not_done = set(futures)

    def done(f):
        not_done.remove(f)
        try:
            f.result()
        except (ShuttingDownException, CancelledError):
            pass
        except Exception:
            traceback.print_exc()

    for future in futures:
        future.add_done_callback(done)

    try:
        while not_done:
            time.sleep(.1)
    except KeyboardInterrupt as e:
        print('stopping work...', str(e))
        ShuttingDownException.shutting_down = True
        # copying not_done here to avoid issues with other threads modifying it
        # while program is ending
        for future in list(not_done):
            future.cancel()
        raise


def run(operations, project=None, max_workers=10, session_limit=None):
    """Run a sequence of FlywheelAnalysisOperations.

    project - Must be a Flywheel Project. Use find_project(...).
    max_workers - Number of sessions that can be run at the same time. This
        number is dependent on a number of factors: How many CPUs your pipeline
        will use and how many CPUs you can use from your Flywheel Engine instance.
    session_limit - Used to test pipelines out by limiting the number of sessions
        the pipeline code will run on.
    """
    gears = [g['gear'] for g in request('gears', params=dict(fields='all'))]
    gears_by_name = {
        gear['name']: gear
        for gear in gears
    }

    for operation in operations:
        assert operation.gear_name in gears_by_name,\
            'operation(name={}, label={}) has an invalid name.'.format(
                operation.gear_name, operation.label)

    sessions = request('projects/{}/sessions'.format(project['_id']))
    # We sort sessions because it adds some predictability to this script.
    # - the script will resume work monitoring/dispatching for previous items
    #   because it iterates over sessions in the same way.
    # - the `session_limit` keyword arg works better for this reason too.
    sessions.sort(key=lambda s: s['timestamp'])
    if session_limit is not None:
        # To ensure the limit on sessions consistently produces the same
        # set of sessions, we will sort the sessions before truncating
        # them.
        sessions = sessions[:session_limit]

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [
            executor.submit(_analyze_session, operations, gears_by_name, session)
            for session in sessions
        ]
        _wait_for_futures(futures)


def _session_status(expected_ops, session):
    analyses = _get_analyses(session['_id'])

    started_ops = {
        a['label'] for a in analyses}
    if not started_ops:
        return 'not started'

    completed_ops = {
        a['label'] for a in analyses
        if a['job']['state'] == 'complete'}
    if completed_ops == expected_ops:
        return 'complete'
    else:
        return 'in progress'


def status(operations, project=None, detail=False):
    '''Prints status of operations on this project.

    detail - When true, some session IDs for each status are logged.
    '''
    sessions = request('projects/{}/sessions'.format(project['_id']))
    expected_ops = {op.label for op in operations}
    statuses = [(s, _session_status(expected_ops, s)) for s in sessions]
    if detail:
        result = {}
        for sess, stat in statuses:
            result.setdefault(stat, []).append(sess['_id'])
        for stat, session_ids in result.iteritems():
            print(stat, len(session_ids), 'some IDs:', session_ids[:4])
    else:
        print(Counter(stat for _, stat in statuses))
