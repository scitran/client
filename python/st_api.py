__author__ = 'vsitzmann'

import os
import requests
import stAuth
import urlparse
import json

class InstanceHandler():
    '''Handles api calls to a certain instance.

    Attributes:
        instance (str): instance name.
        base_url (str): The base url of that instance, as returned by stAuth.create_token(instance, st_dir)
        token (str): Authentication token.
        st_dir (str): The path to the directory where token and authentication file are kept for this instance.
        local (bool): If this is a local instance.
    '''
    instance = ''
    base_url = ''
    token = ''
    st_dir = ''
    local = False

    def __init__(self, instance_name, st_dir, local=False):
        self.instance = instance_name
        self.st_dir = st_dir
        self.local = local

    def _url(self, path):
        '''Assembles a url from this classes's base_url and the given path.

        Args:
            path (str): path part of the URL.

        Returns:
            string: The full URL.
        '''
        return urlparse.urljoin(self.base_url, path)

    def authenticate(self):
        self.token, self.base_url = stAuth.create_token(self.instance, self.st_dir)

    def search_remote(self, search_query, fields='*', num_results=50, lenient=True, target='sessions', collection=''):
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
        # TODO (vsitzmann): Handling of bad HTTP status codes

        return json.loads(response.text)

    def download_acquisition(self, acq_id, acq_name, dest_dir, file_name=''):
        '''Download an acquisition to disk.

        Args:
            acq_id (str): The id of the acquisition as found in the search result's '_id' field.
            acq_name (str): The name of the acquisition as found in the search result's 'name' field.
            dest_dir (str): Path to where the acquisition should be downloaded to.
            file_name (str, optional): Name under which the file should be saved. If left empty, the acq_name is used.

        Returns:
            string. The absolute file path to the downloaded acquisition.
        '''
        path = "api/acquisitions/%s/files/%s"%(acq_id, acq_name)
        headers = {"Authorization": self.token}

        print('Searching...')
        response = requests.get(self._url(path), headers=headers)
        # TODO (vsitzmann): Handling of bad HTTP status codes

        abs_file_path = os.path.join(dest_dir, acq_name)

        if response.status_code == 200:
            print('File found. Saving to %s.'%abs_file_path)
            with open(abs_file_path, 'wb') as fd:
                for chunk in response.iter_content():
                    fd.write(chunk)

        return abs_file_path

    def upload_attachment(self, file_path, target, db_id):
        filename= os.path.split(file_path)[1]
        path = "api/acquisitions/%s/files/%s"%(target, db_id, filename)
        headers = {"Authorization": self.token}
        files = {'file': (filename, open(file_path, 'rb'))}

        response = requests.post(self._url(path), headers=headers, files=files)
        # TODO (vsitzmann): Handling of bad HTTP status codes

        return response

