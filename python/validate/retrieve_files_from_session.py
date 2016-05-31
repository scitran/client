from __future__ import print_function
from builtins import input

import sys, os
sys.path.insert(1, os.path.join(sys.path[0], '..'))

from elasticsearch_helper import *
import st_client
import pandas as pd

download_dir = '/home/vsitzmann/Desktop/session_files'
subject_code = 'PA27541'
scitran_dir = '/home/vsitzmann/.stclient/'

try:
    os.mkdir(download_dir)
except Exception:
    pass

scitran_client = st_client.FlywheelClient('scitran', scitran_dir, debug=True)

# Find the session with subject code PA27541.
print("Finding session with subject code %s"%subject_code)
session_constraints = constrain_element('sessions', match('subject.exact_code', subject_code))
relevant_session = scitran_client.search_sessions(session_constraints)
# Extract the session id.
session_id = relevant_session[0]['_id']
print("Found a session with id %s"%session_id)

# As a sanity check, take a look at the acquisitions related to that session:
print("Searching for acquisitions related to that session...")
acquisition_constraints = constrain_element('acquisitions', bool(must(match('session', session_id), match('measurement', 'diffusion'))))
relevant_acquisitions = scitran_client.search_acquisitions(acquisition_constraints)
acquisitions_df = pd.io.json.json_normalize(relevant_acquisitions)
print('%d acquisitions found for the subject code %s. \
The acquisitions can be inspected using the pandas dataframe acquisitions_df.'%(len(relevant_acquisitions), subject_code))

# Search for the files associated with acquisitions with that session id
print("Searching files related to acquisitions with session id %s"%session_id)
file_constraints = {}
file_constraints.update(constrain_element('files',
                                          constant_score(
                                                bool(
                                                    should(
                                                        match('type', 'nifti'),
                                                        match('type', 'bvec'),
                                                        match('type', 'bval')
                                                    )
                                                )
                                            )))

file_constraints.update(constrain_element('acquisitions',
                                          bool(
                                                must(
                                                    match('session', session_id),
                                                    match('measurement', 'diffusion')
                                                )
                                            )))

relevant_files = scitran_client.search_files(file_constraints)

files_dataframe = pd.io.json.json_normalize(relevant_files)
print("Found %d files."%len(relevant_files))

# Download the files.
prompt_result = input("Download those files to %s (y/n)?"%download_dir)

if prompt_result.lower() == 'y':
    scitran_client.download_all_file_search_results(relevant_files)
    # for row_idx, row in files_dataframe.iterrows():
    #     if row_idx % 10 == 0:
    #         print("Progress: %d/%d"%(row_idx, len(relevant_files)))
    #     acq_id = row['_source.container_id']
    #     filename = row['_source.name']
    #     scitran_client.download_file(container_type='acquisitions',
    #                                  container_id=acq_id,
    #                                  file_name=filename,
    #                                  dest_dir=download_dir)

# TODO (vsitzmann): command line flags
