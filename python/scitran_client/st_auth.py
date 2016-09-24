from __future__ import print_function
from builtins import input

import httplib2
import argparse
from oauth2client import client, file, tools
import os
import shutil
import json
import settings

__author__ = 'vsitzmann'

def _handle_instance_auth(instance, st_dir):
    '''
    Provides client_ID, client_secret and client_url of the given instance,
    reading it from stAuth.json file or querying the user (and saving it for later reference) if unavailable

    Args:
        instance (str): The instance that information is requested for
        st_dir (str): Path to the directory where the stAuth.json file is located / should be created

    Returns:
        tuple of client_ID, client_secret and client_url (all strings) for the given instance
    '''
    if not os.path.isdir(st_dir):
        os.mkdir(st_dir)

    local_auth_file_path = os.path.join(st_dir, 'stAuth.json')
    # TODO (Vincent): where to put stAuth.json file?
    if not os.path.isfile(local_auth_file_path):
        shutil.copyfile(os.path.join(settings.EXEC_HOME, 'stAuth.json.example'), local_auth_file_path)


    with open(local_auth_file_path, 'r') as local_auth_file:
        local_auth = json.load(local_auth_file)

    if not instance in local_auth:
        print('Known instances:')
        print(instance.keys())

        prompt_txt = 'Unknown instance: \n \'%s\' is not a known instance. ' \
                     '\n Would you like to add it to your local config? (y/n)'%instance

        if input(prompt_txt) == 'y':
            try:
                client_id = input('Please enter the client_id: ')
                client_secret = input('Please enter the client secret: ')
                client_url = input('Please enter the instance url: ')
            except EOFError:
                print('One or more fields have been left entry. Abort.')
                return -1

            local_auth[instance] = dict()
            local_auth[instance]['client_id'] = client_id
            local_auth[instance]['client_secret'] = client_secret
            local_auth[instance]['client_url'] = client_url

            with open(local_auth_file_path, 'w') as local_auth_file:
                json.dump(local_auth, local_auth_file)

            print('Instance ID, URL, and secret saved.')

        else:
            print('Abort.')

    if not local_auth[instance]['client_secret']:
        prompt_txt = 'AUTH: Connecting to \'%s\'. \n Please enter the client secret:'%instance

        try:
            client_secret = input(prompt_txt)
        except EOFError:
            print("Abort.")
            return -1

        local_auth[instance]['client_secret'] = client_secret

        with open(local_auth_file_path, 'w') as local_auth_file:
            json.dump(local_auth, local_auth_file)

        print("Client secret saved.")

    instance_info = local_auth[instance]

    return instance_info['client_id'], instance_info['client_secret'], instance_info['client_url']


def create_token(instance, st_dir):
    '''
    Get an authentication token for instance, refreshing an existing one or requesting a new one if no previous one exists.

    Args:
        instance (str): The instance to generate a token for.
        st_dir (str): Path of directory where the tokens live.

    Returns:
        Python tuple: (token (str), client_url (str)): (The requested token, the base url for this client)
    '''

    try:
        client_id, client_secret, client_url = _handle_instance_auth(instance, st_dir)
    except TypeError:
        print('The authentication details for instance %s could not be fetched. Aborting.'%instance )

    token_file_path = os.path.join(st_dir, 'st_token_' + instance)

    if os.path.isfile(token_file_path):
        with open(token_file_path, 'r') as token_file:
            token = json.load(token_file)

        if not token['client_id'] == client_id:
            os.remove(token_file_path)

    if os.path.isfile(token_file_path):
        print('Found an existing token for this instance.')

        with open(token_file_path) as token_file:
            credentials = client.OAuth2Credentials.from_json(token_file.read())

        try:
            credentials.refresh(httplib2.Http())
            storage = file.Storage(token_file_path)
            storage.put(credentials)
            credentials.set_store(storage)
            print('The existing token has been refreshed.')
        except client.HttpAccessTokenRefreshError:
            print('This token has been revoked. Deleting it...')
            os.remove(token_file_path)

    if not os.path.isfile(token_file_path):
        print('Requesting a new token.')

        parser = argparse.ArgumentParser(parents=[tools.argparser])
        parser.set_defaults(auth_host_port=[9000])
        flags = parser.parse_args()

        flow = client.OAuth2WebServerFlow(client_id=client_id,
                                          client_secret=client_secret,
                                          scope='https://www.googleapis.com/auth/userinfo.email')
        storage = file.Storage(token_file_path)
        credentials = tools.run_flow(flow, storage, flags)

    return (credentials.access_token, client_url)

def revoke_token(instance, st_dir):
    '''
    Deletes an existing token for instance.

    Args:
        instance (str): Instance with a (supposedly) existing token that should be revoked and removed.
        st_dir (str): Path of directory where the tokens live.

    Returns:
        int: 0 if successful, -1 if not.
    '''
    token_file_path = os.path.join(st_dir, 'st_token_' + instance)

    try:
        with open(token_file_path) as token_file:
            credentials = client.OAuth2Credentials.from_json(token_file.read())
    except IOError:
        print('No token exists for instance %s: File %s does not exist.'%(instance, token_file_path))
        return -1

    try:
        credentials.revoke(httplib2.Http())
        storage = file.Storage(token_file_path)
        storage.put(credentials)
        credentials.set_store(credentials)
    except client.TokenRevokeError:
        print('This token has been revoked previously.')

    os.remove(token_file_path)
    print('Successfully removed token for instance %s.'%instance)

    return 0
