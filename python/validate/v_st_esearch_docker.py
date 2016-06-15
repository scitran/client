from __future__ import print_function, absolute_import

import sys, os
sys.path.insert(1, os.path.join(sys.path[0], '..'))

from pprint import pprint
import st_client
import pandas
from elasticsearch_helper import *

__author__ = 'vsitzmann'

# The input and output directories that will be mounted in the docker container.
in_dir ='/home/vsitzmann/Desktop/input'
out_dir = '/home/vsitzmann/Desktop/output'

# The directory where the client secret, tokens etc. are stored
st_dir = '/home/vsitzmann/.stclient'

try:
    os.mkdir(in_dir)
    os.mkdir(out_dir)
except Exception:
    pass

scitran_instance = st_client.ScitranClient('scitran', st_dir)

# Start a search
print("Running the search...")
constraints = {}
constraints.update(constrain_element('acquisitions', match('measurement', 'anatomy_t1w')))
constraints.update(constrain_element('files', match('type', 'nifti')))
constraints.update(constrain_element('collections', match('label', 'testing')))
search_results = scitran_instance.search_files(constraints)

search_results_df = pandas.io.json.json_normalize(search_results)
print("The search returned %d results."%len(search_results_df))

filenames = scitran_instance.download_all_file_search_results(search_results, dest_dir=in_dir)

# Find one collection that the file belongs to:
file_collections = scitran_instance.search_collections(constraints=constrain_element('collections', match('label', 'testing')))
collection_id = file_collections[0]['_id']

scitran_instance.run_gear_and_upload_analysis(metadata_label='bet analyses',
                                              container='vistalab/bet',
                                              target_collection_id=collection_id,
                                              in_dir=in_dir,
                                              out_dir=out_dir)
file_collections = scitran_instance.search_collections(constraints=constrain_element('collections', match('label', 'testing')))
pprint(file_collections)

# # Start the docker container
# print("Starting the docker vistalab/bet container to run on the test file.")
# in_file = filename
# out_file = in_file[:-7] + '_bet'
# command ='/input/%s /output/%s'%(in_file, out_file)
# st_docker.run_container('vistalab/bet', command=command, in_dir=in_dir, out_dir=out_dir)
#
# # Reupload the file as an analysis for  the determined collection:
# print("Reuploading result to collection %s."%(file_collections[0]['_source']['label']))
# in_file_path = os.path.join(in_dir, in_file)
# out_file_path = os.path.join(out_dir, out_file + '.nii.gz')
# metadata = {'label':'testing_multipart'}
# response = scitran_instance.upload_analysis(in_file_path, out_file_path, metadata, target_collection_id=collection_id)
# analyses_id = json.loads(response.text)['_id']
# print("Uploaded the analyses. Saved in database under ID %s"%analyses_id)

# Find the uploaded analyses. It will take some time for elastic search to index the freshly uploaded file, hence the delay.
# import time
# time.sleep(5) # delays for 5 seconds

# print("Searching the remote for the freshly uploaded analysis...")
# constraints = {
#     'analyses': {
#         'match': {
#             '_id':analyses_id
#         }
#     }
# }
#
# path='analyses'
# uploaded_analyses = scitran_instance.search(path, constraints)['analyses']
# pprint(uploaded_analyses)
