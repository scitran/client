from __future__ import print_function, absolute_import

import sys, os
sys.path.insert(1, os.path.join(sys.path[0], '..'))

import st_api
import pandas
import st_docker
# import logging
# logging.basicConfig(level=logging.DEBUG)

__author__ = 'vsitzmann'

in_dir ='/home/vincent/Desktop/input'
out_dir = '/home/vincent/Desktop/output'
try:
    os.mkdir(in_dir)
    os.mkdir(out_dir)
except Exception:
    pass

scitran_instance = st_api.InstanceHandler('scitran', '/home/vincent/.stclient')
scitran_instance.authenticate()

# Start a search
search_results = scitran_instance.search_remote('.nii.gz', target='files', collection='testing')
search_results_df = pandas.io.json.json_normalize(search_results)

# Find a random anatomy measurement
anatomy_idcs = search_results_df['acquisition.measurement'].str.contains('anatomy', na=False)
anatomy_measurements = search_results_df[ anatomy_idcs ]

# Download that measurement:
test_file = anatomy_measurements.iloc[0]
status_code, return_string = scitran_instance.download_acquisition(test_file['acquisition._id'], test_file['name'], dest_dir='/home/vincent/Desktop/input')

print(status_code, return_string)

# Start the docker container
in_file = test_file['name']
out_file = in_file[:-7] + '_bet'
st_docker.run_container('vistalab/bet', command='/input/'+in_file+' /output/'+out_file, in_dir=in_dir, out_dir=out_dir)

