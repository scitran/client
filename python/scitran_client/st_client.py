from __future__ import print_function

import os
import requests
import st_exceptions
import st_auth
import urlparse
import json
import shutil
import st_docker
from settings import *
from tqdm import tqdm
import ssl
import hashlib

if not hasattr(ssl, 'PROTOCOL_TLSv1_2'):
    print('You are missing suppport for TLS 1.2, which is required to connect to flywheel servers. Try upgrading your version of openssl.')
    raise Exception('Missing support for TLS 1.2')

__author__ = 'vsitzmann'

HASH_PREFIX = 'v0-sha384-'

class ScitranClient(object):
    '''Handles api calls to a certain instance.

    Attributes:
        instance (str): instance name.
        base_url (str): The base url of that instance, as returned by stAuth.create_token(instance, st_dir)
        token (str): Authentication token.
        st_dir (str): The path to the directory where token and authentication file are kept for this instance.
    '''

    def __init__(self,
                 instance_name,
                 debug=False,
                 st_dir = AUTH_DIR,
                 downloads_dir=DEFAULT_DOWNLOADS_DIR,
                 gear_in_dir=DEFAULT_INPUT_DIR,
                 gear_out_dir=DEFAULT_OUTPUT_DIR):

        self.session = requests.Session()
        self.instance = instance_name
        self.st_dir = st_dir
        self._authenticate()
        self.debug = debug
        self.downloads_dir = downloads_dir
        self.gear_in_dir = gear_in_dir
        self.gear_out_dir = gear_out_dir

        self._set_up_dir_structure()

        if self.debug:
            self.session.hooks = dict(response=self._print_request_info)

    def _set_up_dir_structure(self):
        if not os.path.isdir(self.downloads_dir):
            os.mkdir(self.downloads_dir)
        if not os.path.isdir(self.gear_in_dir):
            os.mkdir(self.gear_in_dir)
        if not os.path.isdir(self.gear_out_dir):
            os.mkdir(self.gear_out_dir)

    def _check_status_code(self, response):
        '''Checks the status codes of received responses and raises errors in case of bad http requests.'''
        status_code = response.status_code

        if status_code == 200:
            return

        exceptions_dict = {
            403: st_exceptions.NoPermission,
            404: st_exceptions.NotFound,
            400: st_exceptions.WrongFormat,
            500: st_exceptions.BadRequest
        }

        # we default to APIException for other status codes.
        exception = exceptions_dict.get(status_code, st_exceptions.APIException)

        raise exception(response.text, response=response)

    def _url(self, path):
        '''Assembles a url from this classes's base_url and the given path.

        Args:
            path (str): path part of the URL.

        Returns:
            string: The full URL.
        '''
        return urlparse.urljoin(self.base_url, path)

    def _print_request_info(self, response, *args, **kwargs):
        '''Prints information about requests for debugging purposes.
        '''
        prepared_request = response.request

        print('DEBUG {} {}\n{}\n{}\n'.format(
            prepared_request.method,
            prepared_request.url,
            prepared_request.headers,
            prepared_request.body,
        ))

    def _authenticate_request(self, request):
        '''Automatically appends the authorization token to every request sent out.'''
        if self.token:
            request.headers.update({
                'Authorization':self.token
            })

            return request
        else:
            raise st_exceptions.InvalidToken('Not Authenticated!')

    def _authenticate(self):
        self.token, self.base_url = st_auth.create_token(self.instance, self.st_dir)
        self.base_url = urlparse.urljoin(self.base_url, 'api/')

    def _request(self, endpoint, method='GET', params=None, data=None, headers=None, files=None):
        '''Dispatches requests, taking care of the instance-specific base_url and authentication. Also raises appropriate HTTP errors.
        Args:
            method (str): The HTTP method to perform ('GET', 'POST'...)
            params (dict): Dict of http parameters.
            data (str): Data payload that should be sent with the request.
            headers (dict): Dict of http headers.

        Returns:
            The full server response.

        Raises:
            http code 403: st_exceptions.NoPermission,
            http code 404: st_exceptions.NotFound
            no token available: st_exceptions.InvalidToken
        '''
        response = self.session.request(url=self._url(endpoint),
                                        method=method,
                                        params=params,
                                        data=data,
                                        headers=headers,
                                        auth=self._authenticate_request,
                                        files=files)

        self._check_status_code(response)
        return response

    def search(self, path, constraints, num_results=-1):
        '''Searches remote "path" objects with constraints.

        This is the most general function for an elastic search that allows to pass in a "path" as well as
        a user-assembled list of constraints.

        Args:
            path (string): The path that should be searched, i.e. 'acquisitions/files'
            constraints (dict): The constraints of the search, i.e. {'collections':{'should':[{'match':...}, ...]}, 'sessions':{'should':[{'match':...}, ...]}}

        Returns:
            python dict of search results.
        '''
        search_body = {
            'path':path
        }

        search_body.update(constraints)

        if num_results != -1:
            search_body.update({'size':num_results})

        response = self._request(endpoint="search", method='POST', data=json.dumps(search_body), params={'size':num_results})

        return json.loads(response.text)

    def search_files(self, constraints, num_results=-1):
        return self.search(path='files', constraints=constraints, num_results=num_results)['files']

    def search_collections(self, constraints, num_results=-1):
        return self.search(path='collections', constraints=constraints, num_results=num_results)['collections']

    def search_sessions(self, constraints, num_results=-1):
        return self.search(path='sessions', constraints=constraints, num_results=num_results)['sessions']

    def search_projects(self, constraints, num_results=-1):
        return self.search(path='projects', constraints=constraints, num_results=num_results)['projects']

    def search_acquisitions(self, constraints, num_results=-1):
        return self.search(path='acquisitions', constraints=constraints, num_results=num_results)['acquisitions']

    def _file_matches_hash(self, abs_file_path, file_hash):
        assert file_hash.startswith(HASH_PREFIX)
        h = hashlib.new('sha384')
        with open(abs_file_path, 'rb') as f:
            for chunk in iter(lambda: f.read(4096), b""):
                h.update(chunk)
        return h.hexdigest() == file_hash[len(HASH_PREFIX):]

    def download_file(self, container_type, container_id, file_name, file_hash, dest_dir=None):
        '''Download a file that resides in a specified container.

        Args:
            container_type (str): The type of container the file resides in (i.e. acquisition, session...)
            container_id (str): The elasticsearch id of the specific container the file resides in.
            dest_dir (str): Path to where the acquisition should be downloaded to.
            file_name (str): Name of the file.

        Returns:
            string. The absolute file path to the downloaded acquisition.
        '''
        # If no destination directory is given, default to the gear_in_dir of the object.
        if not dest_dir:
            dest_dir = self.gear_in_dir

        endpoint = "%s/%s/files/%s"%(container_type, container_id, file_name)
        abs_file_path = os.path.join(dest_dir, file_name)

        if os.path.exists(abs_file_path):
            if self._file_matches_hash(abs_file_path, file_hash):
                print('Found local copy of {} with correct content.'.format(file_name))
                return abs_file_path

        response = self._request(endpoint=endpoint, method='GET')

        with open(abs_file_path, 'wb') as fd:
            for chunk in tqdm(
                response.iter_content(),
                desc=file_name, leave=False,
                unit_scale=True, unit='B',
            ):
                fd.write(chunk)

        if not self._file_matches_hash(abs_file_path, file_hash):
            raise Exception('Downloaded file {} has incorrect hash. Should be {}'.format(abs_file_path, file_hash))

        return abs_file_path

    def download_all_file_search_results(self, file_search_results, dest_dir=None):
        '''Download all files contained in the list returned by a call to ScitranClient.search_files()

        Args:
            file_search_results (dict): Search result.
            dest_dir (str): Path to the directory that files should be downloaded to.

        Returns:
            string: Destination directory.
        '''
        file_paths = []
        for file_search_result in tqdm(file_search_results):
            container_id = file_search_result['_source']['acquisition']['_id']
            container_name = file_search_result['_source']['container_name']
            file_name = file_search_result['_source']['name']
            file_hash = file_search_result['_source']['hash']
            abs_file_path = self.download_file(container_name, container_id, file_name, file_hash, dest_dir=dest_dir)
            file_paths.append(abs_file_path)

        return file_paths

    def upload_analysis(self, in_dir, out_dir, metadata, target_collection_id):
        '''Attaches an input file and an output file to a collection on the remote end.

        Args:
            in_dir (str): The path to the directory with input files.
            out_dir (str): The path to the directory with output files.
            metadata (dict): A dictionary with metadata.
            target_collection_id (str): The id of the collection the file will be attached to.

        Returns:
            requests Request object of the POST request.
        '''

        def _find_files(dir):
            # This will eventually recurse into directories, but for now we throw.
            for basename in os.listdir(dir):
                filename = os.path.join(dir, basename)
                assert not os.path.islink(filename), '_find_files does not support symlinks'
                if os.path.isdir(filename):
                    for f in _find_files(filename):
                        yield f
                else:
                    yield filename

        metadata['inputs'] = []
        metadata['outputs'] = []
        multipart_data = []
        filehandles = []

        def _add_file_to_request(filename, dir, metadata_value):
            relative = os.path.relpath(filename, dir)
            fh = open(filename, 'rb')
            filehandles.append(fh)
            metadata_value.append({'name': relative})
            key = 'file{}'.format(len(multipart_data) + 1)
            multipart_data.append((key, (relative, fh)))

        endpoint = 'sessions/{}/analyses'.format(target_collection_id)

        try:
            for filename in _find_files(in_dir):
                _add_file_to_request(filename, in_dir, metadata['inputs'])
            for filename in _find_files(out_dir):
                _add_file_to_request(filename, out_dir, metadata['outputs'])
            response = self._request(
                endpoint, method='POST',
                data={'metadata': json.dumps(metadata)}, files=multipart_data)
        finally:
            error = None
            for fh in filehandles:
                try:
                    fh.close()
                except Exception as e:
                    if not error:
                        error = e
            # We only throw the first error, but we make sure that we close files before we throw.
            if error:
                raise error

        return response

    def submit_job(self, inputs, destination, tags=[]):
        '''Submits a job to the flywheel factory

        Args:
            inputs (dict):
            destination (dict):

        '''
        # submit_job_command = sprintf(
            # 'curl -k -X POST %s/%s -d ''%s'' -H "X-SciTran-Auth:%s" -H "X-SciTran-Name:live.sh" -H "X-SciTran-Method:script" ',
            # st.url, endpoint, job_body, drone_secret);

        endpoint = 'jobs/add'

        job_dict = {}
        job_dict.update({'inputs':inputs})
        job_dict.update({'tags':tags})
        job_dict.update({'destination':destination})

        response = self._request(endpoint=endpoint,
                                 data=json.dumps(job_dict),
                                 headers={'X-SciTran-Name:live.sh', 'X-SciTran-Method:script'})
        return response

    def run_gear_and_upload_analysis(self, metadata_label, container, target_collection_id, command, in_dir=None, out_dir=None):
        '''Runs a docker container on all files in an input directory and uploads input and output file in an analysis.

        Args:
            metadata_label (str): The label of the uploaded analysis.
            container (str): The docker container to run.
            target_collection_id (str): The collection id of the target collection that analyses are uploaded to.
            in_dir (Optional[str]): The input directory to the gear where all the input files reside.
                                        If not given, the self.gear_in_dir will be used.
            out_dir (Optional[str]): The output directory that should be used by the gear. If given, has to be empty.
                                        If not given, the self.gear_out_dir will be used.

        Returns:

        '''
        if not in_dir:
            in_dir = self.gear_in_dir

        if not os.path.exists(in_dir):
            os.mkdir(in_dir)

        if not out_dir:
            out_dir = self.gear_out_dir

        if os.path.exists(out_dir):
            if os.listdir(out_dir):
                print('Output directory {} is not empty!'.format(out_dir))
                return
        else:
            os.mkdir(out_dir)

        try:
            print('Running container {} on with input {} and output {}'.format(container, in_dir, out_dir))
            st_docker.run_container(container, command=command, in_dir=in_dir, out_dir=out_dir)

            print('Uploading results to collection with id {}.'.format(target_collection_id))
            metadata = {'label': metadata_label}
            response = self.upload_analysis(in_dir, out_dir, metadata, target_collection_id=target_collection_id)
            print(
                'Uploaded analysis has ID {}. Server responded with {}.'
                .format(json.loads(response.text)['_id'], response.status_code))
        finally:
            shutil.rmtree(out_dir)
