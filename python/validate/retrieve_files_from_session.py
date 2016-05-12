from __future__ import print_function
from builtins import input

import sys, os
sys.path.insert(1, os.path.join(sys.path[0], '..'))

import st_api
import pandas as pd

download_dir = '/home/vsitzmann/Desktop/session_files'
subject_code = 'PA27541'

try:
    os.mkdir(download_dir)
except Exception:
    pass

scitran_client = st_api.InstanceHandler('scitran', '/home/vsitzmann/.stclient/', debug=True)

# Find the session with subject code PA27541.
print("Finding session with subject code %s"%subject_code)
relevant_session = scitran_client.search_anything_should_joined(path='sessions', session_props={'subject.exact_code':subject_code})
# Extract the session id.
session_id = relevant_session[0]['_id']
print("Found a session with id %s"%session_id)

# As a sanity check, take a look at the acquisitions related to that session:
print("Searching for acquisitions related to that session...")
relevant_acquisitions = scitran_client.search_anything_should_joined(path='acquisitions',
                                                                     acq_props={'session':session_id})
acquisitions_df = pd.io.json.json_normalize(relevant_acquisitions)
print('%d acquisitions found for the subject code %s. \
The acquisitions can be inspected using the pandas dataframe acquisitions_df.'%(len(relevant_acquisitions), subject_code))

# Search for the files associated with acquisitions with that session id
print("Searching files related to acquisitions with session id %s"%session_id)
relevant_files = scitran_client.search_anything_should_joined(path='files',
                                                              file_props={'type':['nifti', 'bvec', 'bval']},
                                                              acq_props={'session':session_id, 'measurement':'diffusion'})
files_dataframe = pd.io.json.json_normalize(relevant_files)
print("Find %d files."%len(relevant_files))

# Download the files.
prompt_result = input("Download those files to %s (y/n)?"%download_dir)

if prompt_result.lower() == 'y':
        for row_idx, row in files_dataframe.iterrows():
            if row_idx % 10 == 0:
                print("Progress: %d/%d"%(row_idx, len(relevant_files)))
            acq_id = row['_source.container_id']
            filename = row['_source.name']
            scitran_client.download_file(container_type='acquisitions',
                                         container_id=acq_id,
                                         file_name=filename,
                                         dest_dir=download_dir)

