from __future__ import print_function
from scitran_client import ScitranClient
import time
from datetime import datetime
import json
from concurrent.futures import ThreadPoolExecutor
import traceback
from fnmatch import fnmatch


class ShuttingDownException(Exception):
    shutting_down = False


def request(*args, **kwargs):
    response = client._request(*args, **kwargs)
    return json.loads(response.text)


def _defaults_for_gear(gear):
    return {
        key: value['default']
        for key, value in gear['manifest']['config'].iteritems()
        if 'default' in value
    }


def _submit_analysis(session_id, name, job_inputs):
    time_string = datetime.now().strftime('%m/%d/%Y %H:%M:%S')
    body = dict(
        job=dict(
            gear=name,
            tags=['ad-hoc'],
            inputs=job_inputs,
            config=_defaults_for_gear(gears_by_name[name])
        ),
        analysis=dict(label='{} {}'.format(name, time_string))
    )

    response = request(
        'sessions/{}/analyses'.format(session_id),
        method='POST',
        params=dict(job=True),
        data=json.dumps(body))
    return response['_id']


def _dtiinit(name, session_id, acquisitions, **kwargs):
    diffusion = next((
        a for a in acquisitions
        if a.get('measurement') == 'diffusion'), None)

    if not diffusion:
        raise Exception('{} has no diffusion data'.format(session_id))

    def _get_input(ext):
        f = next(
            f for f in diffusion['files']
            if fnmatch(f['name'], '*.' + ext))
        return dict(
            type='acquisition',
            id=diffusion['_id'],
            name=f['name']
        )

    inputs = dict(
        bvec=_get_input('bvec'),
        bval=_get_input('bval'),
        nifti=_get_input('nii.gz'),
    )

    return _submit_analysis(session_id, name, job_inputs=inputs)


def _afq(name, session_id, analyses, **kwargs):
    dtiinit = next(
        a for a in analyses
        if a['job']['name'] == 'dtiinit'
    )

    archive = next(
        f for f in dtiinit['files']
        if f.get('output', False)
        if fnmatch(f['name'], 'dtiInit_*.zip'))

    return _submit_analysis(session_id, name, job_inputs=dict(
        dtiInit_Archive=dict(
            type='analysis',
            id=dtiinit['_id'],
            name=archive['name']
        )
    ))


analysis_operations = [
    ('dtiinit', _dtiinit),
    ('afq', _afq)
]


def _get_analyses(session_id):
    '''
    We make sure to fetch session.analyses because it respects
    deletion from the UI. session.jobs will show anything that has
    ever been run.
    '''
    session = request('sessions/{}'.format(session_id))
    return session.get('analyses') or []


def _wait_for_analysis(session_id, analysis_id):
    '''
    Waits for analysis to finish.

    Returns latest analyses to optimize upstream code
    '''
    while True:
        analyses = _get_analyses(session_id)
        analysis_response = next(
            a for a in analyses
            if a['_id'] == analysis_id)
        if analysis_response['job']['state'] == 'complete':
            return analyses
        print(session_id, 'state', analysis_response['job']['state'])
        if ShuttingDownException.shutting_down:
            raise ShuttingDownException()
        time.sleep(1)


def _analyze_session(session_id):
    acquisitions = None
    analyses = _get_analyses(session_id)
    for name, fn in analysis_operations:
        analysis = next((
            a for a in analyses
            if a['job']['name'] == name), None)
        analysis_id = analysis and analysis['_id']

        # skip this analysis if we've already done it
        if analysis and analysis['job']['state'] == 'complete':
            continue

        print('waiting for' if analysis else 'starting', name, 'for session', session_id)

        if not analysis_id:
            if not acquisitions:
                acquisitions = request('sessions/{}/acquisitions'.format(session_id))
            analysis_id = fn(name=name, session_id=session_id, analyses=analyses, acquisitions=acquisitions)

        analyses = _wait_for_analysis(session_id, analysis_id)
    print(session_id, 'all analysis complete')


client = ScitranClient()

gears_by_name = {
    gear['name']: gear
    for gear in request('gears', params=dict(fields='all'))
}

project = next(
    project
    for project in request('projects')
    if project['label'] == 'ENGAGE'
)

sessions = request('projects/{}/sessions'.format(project['_id']))
session_ids = [s['_id'] for s in sessions]


def wait_for_futures(futures):
    not_done = set(futures)

    def done(f):
        not_done.remove(f)
        try:
            f.result()
        except ShuttingDownException:
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


def main():
    # 10 workers at most for now to avoid queue flooding
    workers = 10
    with ThreadPoolExecutor(max_workers=workers) as executor:
        futures = [
            executor.submit(_analyze_session, session_id)
            for session_id in session_ids
        ]
        wait_for_futures(futures)


if __name__ == "__main__":
    main()
