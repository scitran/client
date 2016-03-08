#!/usr/bin/env python

import os
import json
import glob
import time
import datetime
import urllib
import shutil
import hashlib
import argparse
import requests
from time import sleep
from pprint import pprint



def convert_age(seconds):
    '''
    Converts a given age in seconds [type=float,int] to a more reasonable string (e.g. days, years, months) [type=string].

        INPUT: 
            age [float, int] - An age in seconds. If 'seconds' is not an 'int' or 'float', 'age' is returned as an empty string.

        RETURN:
            age [string]     - A string representing age in days, months, or years. 
                                If age < 1Mo, then age is returned in days. 
                                If age < 1Y and age > 1Mo, then age is retunred in months.
                                Else age is returned in years.

        EXAMPLE:
            > age_string = sdm.convert_age(1388488493.)
                
                '44Y'

    '''
    if (type(seconds) == float) or (type(seconds) == int):
        hours = seconds/3600
        days = hours/24
        months = days/30
        # If less than a month old return age in days
        if months < 1:
            return str(int(days)) + 'D'
        years = days/365
        # If less than a year old return age in months
        if years < 1:
            return str(int(months)) + 'M'
        # Else return age in years
        return str(int(years)) + 'Y'
    else:
        return ''

def print_acq_metadata(code, series, description, sex, age, urls):
    '''
    Print the metadata content to the screen.
        
        Example Usage: 
            description, series, code, sex, age, urls = sdm.get_acq_metadata(acquisitions[acq])
            print_acq_metadata(code, series, description, sex, age, urls)

    '''
    print code
    print series
    print description
    print sex
    print age
    print nifti_urls
    sleep(1)
    return

def get_urls(acqs, filter=''):
    '''
    Filter URLs in acquisitions to return only those with that filter in the url.
    
        INPUT: 
            acqs   [type=list]   - A list of acquisitions
            filter [type=string] - A text string which must exist in a url to be returned.

        OUTPUT:
            urls [type=list] - A filtered list of URLs.

        EXAMPLE:
            description, series, code, sex, age, urls = sdm.get_acq_metadata(acquisitions[acq])
            nifti_urls = sdm.filter_urls(urls, '_nifti.nii.gz')
    '''
    urls = []
    for a in acqs:
        for u in range(len(acqs[a]['urls'])):
            this_url = acqs[a]['urls'][u]
            if not filter or filter in this_url:
                urls.append(this_url)
    return urls

def filter_urls(urls_to_filter, filter=''):
    '''
    Filter a list of URLs and return only those with that filter in the url.
        
        INPUT:
            urls_to_filter - A list of urls.
            filter         - A text string containing the filter. 

        OUTPUT:
            urls - a filtered list of urls.
    '''
    urls = []
    for u in range(len(urls_to_filter)):
        this_url = urls_to_filter[u]
        if filter in this_url:
            urls.append(this_url)
    return urls

def get_data_from_json(json_file):
    '''
    Load the json data from file. 
        INPUT:
            json_file - An SDM json text file.

        OUTPUT: 
            acquisitions - an array of acquisitions 
            sessions     - an array of sessions
    '''
    with open(json_file, 'r') as data_file:
            data = json.load(data_file)
    acquisitions = data['acquisitions']
    sessions = data['sessions']
    return acquisitions, sessions

def get_acq_metadata(acq):
    '''
    Parse a single acq and send back description,series,code,sex, age,urls
        INPUT:
            A single acquisition dictionary.

        OUTPUT:
            description,series,code,sex,age,urls
    '''

    series = acq['series']
    code = acq['subject_code']
    urls = acq['urls']

    if acq.has_key('description'):
        description = acq['description']
    else:
        description = ''
    
    if acq.has_key('subject_sex'):
        sex = acq['subject_sex']
    else:
        sex = ''
    
    if acq.has_key('subject_age'):
        age = convert_age(float(acq['subject_age']))
        age = ''
    
    return description,series,code,sex,age,urls

def sdm_get_file(url, username, path):
    '''
    For a given url, append the 'username' and download the file to 'path' on disk.
    
        INPUT:
            url      - SDM url from which to download the file
            username - A valid SDM username with download permissions
            path     - the path on disk to which the file should be saved

        OUTPUT:
            status    - True or False, based on success
            save_name - The full path, including filename of the saved file
    '''
    save_name = os.path.join(path, url.split("/")[-1])
    urllib.urlretrieve(url + '?user=%s' % (username), save_name)
    if os.path.isfile(save_name):
        status = True
    else:
        status = False
    return status, save_name

def sdm_put_file(url, username, file_path):
    '''
    Upload a file to an sdm instance.

    INPUT:
        url       = the url in sdm where the attachment should go
        username  = the userid or username of the user that has rights
        file_path = the path to the file on disk to be uploaded
    
    OUTPUT:
        req - obj, where req.ok is the indication that it succeeded.
    '''
    # Parse the upload url and file_path into an upload url
    print 'Uploading %s' % (file_path)
    fName = os.path.basename(file_path)
    base_url = "/".join(url.split("/")[:-1])
    put_url = base_url + "/" + urllib.quote(fName)

    # Get the MD5 of the file being uploaded
    with open(file_path,'rb') as f:
        checkSum = hashlib.md5(f.read()).hexdigest()

    ## Use REQUESTS to send the file
    requests.packages.urllib3.disable_warnings()

    with open(file_path, 'rb') as f:
        file_data = f.read()
    headers = {'Content_Type': 'application/octet-stream', 'Content-MD5': checkSum}
    post_url = '%s?user=%s&flavor=attachment' % (put_url, username)
    req = requests.put(post_url, headers=headers, data=file_data, verify=False)
    if req.ok:
        print 'Success'
    else:
        print 'Failed'

    return req # Returns true of the request was successful.

def create_docker_job(code, series, url, project_dir, user_name, log_file, container="recon-all"):
    '''

    Create a docker_job dict with all necesarry components for the running of that job.

    INPUTS:
        code        - subject code or ID
        series      - series number of the acquisition
        url         - url of the data that should be downloaded
        project_dir - local path on disk to store data during computation
        user_name   - username that has permission to download and put data into sdm
        log_file    - Path to a file where status and logs will be written out
        container   - name of the container to set to run

    RETURNS:
        docker_job  - a dict containing all necessary keys to execute a job with sdm.run_docker_job

    '''
    docker_job = {}
    docker_job['url'] = url
    docker_job['user_name'] = user_name
    docker_job['nifti_file'] = url.split("/")[-1]
    docker_job['project_dir'] = project_dir
    docker_job['base_dir'] = os.path.join(project_dir, '%s_%s/' % (code,series))
    docker_job['log_file'] = log_file
    docker_job['input_vol'] =  os.path.join(docker_job['base_dir'], 'input')
    docker_job['output_vol'] =  os.path.join(docker_job['base_dir'], 'output')

    if container == "recon-all":
        docker_job['command'] = 'docker run --rm -ti \
                                    -v %s:/input -v %s:/output vistalab/recon-all -i /input/%s -subjid %s -all -qcache' % (docker_job['input_vol'], docker_job['output_vol'], docker_job['nifti_file'], code)
    elif container == "bet":
        docker_job['command'] = 'docker run --rm -ti \
                                    -v %s:/input \
                                    -v %s:/output \
                                    vistalab/bet /input/%s /output/bet2_%s_ \
                                    ' % (docker_job['input_vol'], docker_job['output_vol'], docker_job['nifti_file'], code)
    elif container == "hippovol":
        docker_job['command'] = 'docker run --rm -ti \
                                    -v %s:/input \
                                    -v %s:/output \
                                    vistalab/hippovol \
                                    ' % (docker_job['input_vol'], docker_job['output_vol'])
    else:
        docker_job['command'] = ''
        print 'No Docker job could be specified.'

    return docker_job

def run_docker_job(docker_job):
    '''
    run_docker_job(docker_job)

    Execute a docker_job on the system.
        1. Make the temporary directory on disk
        2. Download the data
        3. Run the docker command
        4. Upload the results
        5. Remove the directory from disk

    INPUTS:
        docker_job      - A docker_job dictionary from sdm.create_docker_job

    RETURNS:
        job_status      - Exit status of the docker job
        results_status  - Boolean if the results were uploaded
    '''
    print 'Running job for: %s' % (docker_job['base_dir'])
    if not docker_job['user_name']:
        raise ValueError("No user_name specified. GETs and PUTs will fail.")

    if not os.path.isdir(docker_job['project_dir']):
        raise ValueError("Project directory %s does not exist!" % (docker_job['project_dir']))

    # Make the directories
    print 'Making directories...'
    if os.path.isdir(docker_job['base_dir']):
        print 'WARNING: %s exists... Removing it!' % (docker_job['base_dir'])
        shutil.rmtree(docker_job['base_dir'])
    os.makedirs(docker_job['base_dir'])
    os.makedirs(docker_job['input_vol'])
    os.makedirs(docker_job['output_vol'])

    # Download the file
    print 'Downloading raw data...'
    sdm_get_file(docker_job['url'], docker_job['user_name'], docker_job['input_vol'])

    # Log if log_file exists
    if docker_job['log_file'] and os.path.isfile(docker_job['log_file']):
        command = 'echo Starting: %s: %s >> %s' % (time.strftime("%H:%M:%S"), str(docker_job['base_dir']), docker_job['log_file'])

    # RUN the docker command on the system (what happens to the stdout?)
    os.system(command)
    print 'Executing the command! %s' % (docker_job['command'])
    job_status = os.system(docker_job['command'])

    # Upload the results (multiple (zipped) results will be uploaded)
    results = glob.glob(docker_job['output_vol'] + '/*')
    if results:
        results_status = 0
        for r in range(len(results)):
            put_status = sdm_put_file(docker_job['url'], docker_job['user_name'], results[r])
            print put_status
    else:
        results_status = 1

    # Remove the directories
    shutil.rmtree(docker_job['base_dir'])

    if not results_status:
        command = 'echo Finished: %s: %s >> %s' % (time.strftime("%H:%M:%S"), str(docker_job['base_dir']), docker_job['log_file'])
        os.system(command)

    if job_status != 0:
        command = 'echo ERROR: %s: %s >> %s' % (time.strftime("%H:%M:%S"), str(docker_job['base_dir']), docker_job['log_file'])
        os.system(command)


    return job_status, results_status






