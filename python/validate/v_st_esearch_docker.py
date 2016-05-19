from __future__ import print_function, absolute_import

import sys, os
sys.path.insert(1, os.path.join(sys.path[0], '..'))

from pprint import pprint
import st_api
import pandas
import st_docker
import json
import time

# Logging may be switched on for debugging.
# import logging
# logging.basicConfig(level=logging.DEBUG)

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

scitran_instance = st_api.InstanceHandler('scitran', st_dir)

# Start a search
print("Running the search...")
search_results = scitran_instance.search_acquisition_files(file_props={'name':'.nii.gz'},
                                                           acq_props={'measurement':'anatomy_t1w'},
                                                           collection_labels=['testing'])
search_results_df = pandas.io.json.json_normalize(search_results)
print("The search returned %d results."%len(search_results_df))

# Choose one of the files and extract its properties
test_file = search_results_df.iloc[0]
container_id = test_file['_source.container_id']
container_name = test_file['_source.container_name']
filename = test_file['_source.name']

# This code may be used to find the acquisition that that the file originates from for testing purposes.
path = 'acquisitions'
constraints = {
                'acquisitions':{
                    'match':{
                        '_id':container_id
                    }
                }
            }
source_acquisition = scitran_instance.search(path, constraints)['acquisitions'][0]
print("Chose the file %s of acquisition %s as a test file."%(filename, source_acquisition['_source']['label']))

# Download the test file to the input directory defined above
print("Downloading the test file...")
dest_dir = in_dir
downloaded_file_path = scitran_instance.download_file(container_id=container_id,
                                                      container_type=container_name,
                                                      file_name=filename,
                                                      dest_dir=dest_dir)

# Start the docker container
print("Starting the docker vistalab/bet container to run on the test file.")
in_file = filename
out_file = in_file[:-7] + '_bet'
command ='/input/%s /output/%s'%(in_file, out_file)
st_docker.run_container('vistalab/bet', command=command, in_dir=in_dir, out_dir=out_dir)

# Find one collection that the file belongs to:
file_collections = scitran_instance.search(path='collections', constraints={'collections':{'match':{'label': 'testing'}}})['collections']
collection_id = file_collections[0]['_id']

# Reupload the file as an analysis for  the determined collection:
print("Reuploading result to collection %s."%(file_collections[0]['_source']['label']))
in_file_path = os.path.join(in_dir, in_file)
out_file_path = os.path.join(out_dir, out_file + '.nii.gz')
metadata = {'label':'bet analysis'}
response = scitran_instance.upload_analysis(in_file_path, out_file_path, metadata, target_collection_id=collection_id)
analyses_id = json.loads(response.text)['_id']
print("Uploaded the analyses. Saved in database under ID %s"%analyses_id)

# Find the uploaded analyses. It will take some time for elastic search to index the freshly uploaded file, hence the delay.
import time
time.sleep(5) # delays for 5 seconds

print("Searching the remote for the freshly uploaded analysis...")
constraints = {
    'analyses': {
        'match': {
            '_id':analyses_id
        }
    }
}

path='analyses'
uploaded_analyses = scitran_instance.search(path, constraints)['analyses']
pprint(uploaded_analyses)
