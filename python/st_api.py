from __future__ import print_function
from pprint import pprint

import os
import requests
from requests_futures import sessions
import st_exceptions
import st_auth
import urlparse
import json
from elasticsearch_dsl import Search

__author__ = 'vsitzmann'

class InstanceHandler(object):
    '''Handles api calls to a certain instance.

    Attributes:
        instance (str): instance name.
        base_url (str): The base url of that instance, as returned by stAuth.create_token(instance, st_dir)
        token (str): Authentication token.
        st_dir (str): The path to the directory where token and authentication file are kept for this instance.
    '''

    def __init__(self, instance_name, st_dir, debug=False):
        self.session = requests.Session()
        self.instance = instance_name
        self.st_dir = st_dir
        self.authenticate()
        self.debug = debug

        if self.debug:
            self.session.hooks = dict(response=self._print_request_info)

    def _check_status_code(self, response):
        status_code = response.status_code

        if status_code == 200:
            return

        exceptions_dict = {
            403: st_exceptions.NoPermission,
            404: st_exceptions.NotFound,
            400: st_exceptions.WrongFormat,
            500: st_exceptions.BadRequest
        }

        exception = exceptions_dict.get(status_code)

        if exception:
            raise exception(response.text)

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

        print("\nRequest dump:\n")

        pprint(prepared_request.method)
        pprint(prepared_request.url)
        pprint(prepared_request.headers)
        pprint(prepared_request.body)

        print('\n')

    def _authenticate_request(self, request):
        if self.token:
            request.headers.update({
                'Authorization':self.token
            })

            return request
        else:
            raise st_exceptions.InvalidToken('Not Authenticated!')

    def search_anything_should_joined(self, path='', file_props={}, acq_props={}, collection_props={}, session_props={}, project_props={}):
        constraints = {}

        if file_props:
            constraints.update(self._bool_match_multiple_field('files', file_props))

        if acq_props:
            constraints.update(self._bool_match_multiple_field('acquisitions', acq_props))

        if collection_props:
            constraints.update(self._bool_match_multiple_field('collections', collection_props))

        if session_props:
            constraints.update(self._bool_match_multiple_field('sessions', session_props))

        if project_props:
            constraints.update(self._bool_match_multiple_field('sessions', project_props))

        return self.search_remote(path, constraints)[os.path.basename(path)]

    def authenticate(self):
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

    def search_remote(self, path, constraints, num_results=-1):
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

        if num_results != -1:
            search_body.update({'size':num_results})

        search_body.update(constraints)
        response = self._request(endpoint="search", data=json.dumps(search_body))

        return json.loads(response.text)

    def _bool_match_single_field(self, element, field_name, matching_strings):
        ''' Assembles the common elasticsearch-query of specifieng several possible values for a single field.
        '''
        result = {
            element:{
                'bool':{
                    'should': [ {'match':{field_name:matching_string}} for matching_string in matching_strings ]
                }
            }
        }

        return result

    def _bool_match_multiple_field(self, element, field_value_dict):
        ''' Assembles the common elasticsearch-query of wanting to specify several field-value pairs for a certain element.
        '''
        constraints_list = []
        for field, value in field_value_dict.iteritems():
            if isinstance(value, list):
                constraints_list.extend([{'match':{field:single_value}} for single_value in value])
            else:
                constraints_list.append({'match':{field:value}})

        result = {
            element:{
                'bool':{
                    'should':constraints_list
                }
            }
        }

        return result

    def search_sessions(self, session_props={}, collection_labels=[], project_labels=[]):
        '''Searches the remote end for specific sessions.

        Handles the common case where we search for a session with specific properties (i.e. session_code etc.) within
        projects or collections of which we know the labels.

        Args:
            session_props (dict): field_name, field_value pairs to specify the sought-after session, i.e. {'session_code':...}
            collection_labels (list of strings): The labels of collections that the sessions may reside in.
            project_labels(list):  The labels of projects the sessions may reside in.

        Returns:
            List of dicts, where each dict represents one search result.
        '''
        path = 'sessions'
        constraints = {}

        if session_props:
            constraints.update(self._bool_match_multiple_field('sessions', session_props))

        if collection_labels:
            constraints.update(self._bool_match_single_field('collections', 'label', collection_labels))

        if project_labels:
            constraints.update(self._bool_match_single_field('projects', 'label', collection_labels))

        search_results_dict = self.search_remote(path, constraints)['sessions']

        return search_results_dict

    def search_all_files(self, file_props={}, collection_labels=[], session_labels=[], project_labels=[], num_results=-1):
        '''Searches all files in remote.

        This function implements the common case to search for a specific file name, type etc.
        within sessions, collections or projects with a known name. For more flexibility, the "_search_remote()" function
        allows to pass in a user-assembled search query.

        Args:
            file_props (dict): A dictionary specifying single properties of files. Properties will be connected with a "should" query.
            collection_labels (list): A list of labels of collections that the searched files can reside in.
            session_labels (list): A list of session names that the searched files can reside in.
            project_labels (list): A list of project labels that the searched files can reside in.
            num_results (int): The number of search results to be returned. If left at -1, will return as many as possible.

        Returns:
            python list of dicts, where each dict represents one search result.
        '''
        path = 'files'
        constraints = {}

        if file_props:
            constraints.update(self._bool_match_multiple_field('files', file_props))

        if session_labels:
            constraints.update(self._bool_match_single_field('sessions', 'label', sessions))

        if collection_labels:
            constraints.update(self._bool_match_single_field('collections', 'label', collection_labels))

        if project_labels:
            constraints.update(self._bool_match_single_field('projects', 'label', project_labels))

        search_results = self.search_remote(path, constraints, num_results=num_results)['files']

        return search_results

    def search_acquisition_files(self, file_props={}, acq_props={}, num_results=-1, collection_labels=[], project_labels=[]):
        '''Searches files in acquisitions.

        This function implements the common case where we search for a file with specific properties (certain type, name etc.) within
        an aqcuisition with certain properties (measurement...) that we know resides in one or several collections, projects or
        sessions of which we know the labels.

        Args:
            file_props (dict): field-name field-value pairs specifying single file properties. Will be should-connected.
            acq_props (dict): field-name, field-value pairs specifying single acquisition properties. Will be should-connected.
            num_results (int): The number of search results to return. If -1, return as many as possible.
            collection_labels (list of strings): A list of labels of collections the files may reside in.
            project_labels (list of strings): A list of labels of projects the files may reside in.

        Returns:
            list of dicts, where each dict represents one search result.
        '''
        path = 'acquisitions/files'
        constraints = {}

        if file_props:
            constraints.update(self._bool_match_multiple_field('files', file_props))

        if acq_props:
            constraints.update(self._bool_match_multiple_field('acquisitions', acq_props))

        if collection_labels:
            constraints.update(self._bool_match_single_field('collections', 'label', collection_labels))

        if project_labels:
            constraints.update(self._bool_match_single_field('projects', 'label', project_labels))

        search_results_dict = self.search_remote(path, constraints, num_results=num_results)['files']

        return search_results_dict

    def old_search_remote(self, search_query, fields='*', num_results=50, lenient=True, target='sessions', collection=''):
        '''Searches the remote site.

        Args:
            search_query (str): The search string.
            fields (list of strings): Which fields should be considered when matching the search string.
            lenient (bool):
            collection (str): If none, search the whole database. Else, search only in the given collection.

        Returns:
            python list of search results in the form of python dicts.

        '''
        path = '/api/search/%s'%(target)
        headers = {
            'Authorization':self.token,
            'Content-Type':'application/json'
        }

        params = {}
        if collection:
            params.update({'collection':collection})
        else:
            params.update({'size':num_results})

        search_body = {
            'multi_match':{
                'fields':fields,
                'query':search_query,
                'lenient':lenient
            }
        }

        response = requests.get(self._url(path), headers=headers, params=params, data=json.dumps(search_body))

        return json.loads(response.text)

    def download_file(self, container_type, container_id, file_name, dest_dir):
        '''Download a file that resides in a specified container.

        Args:
            container_type (str): The type of container the file resides in (i.e. acquisition, session...)
            container_id (str): The elasticsearch id of the specific container the file resides in.
            dest_dir (str): Path to where the acquisition should be downloaded to.
            file_name (str): Name of the file.

        Returns:
            string. The absolute file path to the downloaded acquisition.
        '''
        endpoint = "%s/%s/files/%s"%(container_type, container_id, file_name)
        abs_file_path = os.path.join(dest_dir, file_name)

        response = self._request(endpoint=endpoint, method='GET')

        with open(abs_file_path, 'wb') as fd:
            for chunk in response.iter_content():
                fd.write(chunk)

        return abs_file_path

    def upload_analysis(self, in_file_path, out_file_path, metadata, target_collection_id):
        '''Attaches an input file and an output file to a collection on the remote end.

        Args:
            in_file_path (str): The path to the input file.
            out_file_path (str): The path to the output file.
            metadata (dict): A dictionary with metadata.
            target_collection_id (str): The id of the collection the file will be attached to.

        Returns:
            requests Request object of the POST request.
        '''
        endpoint = "collections/%s/analyses"%(target_collection_id)

        in_filename= os.path.split(in_file_path)[1]
        out_filename = os.path.split(out_file_path)[1]

        # If metadata doesn't contain it yet, add the output and the input file names.
        metadata.update({
            'outputs':[{'name':out_filename}],
            'inputs':[{'name':in_filename}]
        })

        payload = {
           'metadata':json.dumps(metadata)
        }

        files = {'file1':open(in_file_path, 'rb'), 'file2':open(out_file_path, 'rb')}

        response = self._request(method='POST', endpoint=endpoint, data=payload, files = files)
        return response






