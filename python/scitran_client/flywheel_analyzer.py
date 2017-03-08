from __future__ import print_function
from scitran_client import ScitranClient
import time
import json
from concurrent.futures import ThreadPoolExecutor, CancelledError
import traceback
from fnmatch import fnmatch
from collections import namedtuple
import math


def _sleep(seconds):
    delta = .1
    assert seconds > delta, 'must sleep for longer than {}'.format(delta)
    for _ in range(int(math.ceil(seconds / delta))):
        time.sleep(delta)


state = {}


FlywheelAnalysisOperation = namedtuple('FlywheelAnalysisOperation', [
    'gear_name', 'create_inputs', 'label'])


def define_analysis(gear_name, create_inputs, label=None):
    label = label or gear_name
    return FlywheelAnalysisOperation(gear_name, create_inputs, label)


class FlywheelFileContainer(dict):
    def find_file(self, pattern):
        is_analysis = 'job' in self and 'state' in self

        f = next(
            f for f in self['files']
            if fnmatch(f['name'], pattern))

        return dict(
            type='analysis' if is_analysis else 'acquisition',
            id=self['_id'],
            name=f['name']
        )


def find(items, _constructor_=FlywheelFileContainer, **kwargs):
    result = next((
        item for item in items
        if all(item[k] == v for k, v in kwargs.iteritems())
    ), None)
    return result and _constructor_(result)


def find_project(**kwargs):
    return find(request('projects'), _constructor_=lambda x: x, **kwargs)


class ShuttingDownException(Exception):
    shutting_down = False


def request(*args, **kwargs):
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


def _submit_analysis(session_id, gear, job_inputs, label):
    body = dict(
        job=dict(
            gear=gear['name'],
            tags=['ad-hoc'],
            inputs=job_inputs,
            config=_defaults_for_gear(gear)
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
    '''
    Waits for analysis to finish.

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
            if not acquisitions:
                acquisitions = request('sessions/{}/acquisitions'.format(session_id))
            job_inputs = create_inputs(analyses=analyses, acquisitions=acquisitions)
            _submit_analysis(session_id, gears_by_name[gear_name], job_inputs, label)

        analyses = _wait_for_analysis(session_id, label)
    print(session_id, 'all analysis complete')


def wait_for_futures(futures):
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


def run(operations, project=None, max_workers=10):
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

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [
            executor.submit(_analyze_session, operations, gears_by_name, session)
            for session in sessions
        ]
        wait_for_futures(futures)
