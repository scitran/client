from __future__ import print_function

import os
from shutil import copyfile
import json
import settings
from getpass import getpass
from requests import request


def _is_valid_token(url, api_key):
    # wish it were easier to share this code with ScitranClient, but
    # that would require more tightly coupling this to that.
    return request('GET', url + '/api/users/self', headers={
        'Authorization': 'scitran-user ' + api_key
    }).status_code == 200


def _prompt_for_valid_api_key(url):
    prompt = 'Enter your API key here: '
    api_key = getpass(prompt)
    while not _is_valid_token(url, api_key):
        print('Sorry, that key was not valid for {}'.format(url))
        api_key = getpass(prompt)
    return api_key


def create_token(instance_name, config_dir):
    '''
    Get an API key for this instance, requesting a new one if no previous one exists.

    Args:
        instance_name (str): The instance to generate a token for.
        config_dir (str): Path of directory where the tokens live.

    Returns:
        Python tuple: (token (str), client_url (str)): (The requested token, the base url for this client)
    '''
    if not os.path.exists(config_dir):
        os.mkdir(config_dir)

    # Copy the example file over if we don't have auth configuration.
    auth_path = os.path.join(config_dir, 'auth.json')
    if not os.path.exists(auth_path):
        copyfile(os.path.join(settings.EXEC_HOME, 'auth.json.example'), auth_path)

    with open(auth_path, 'r') as f:
        auth_config = json.load(f)

    auth = auth_config.get(instance_name)

    example = json.dumps(dict(api_key='<secret>', url='https://myflywheel.io'), indent=4)
    assert isinstance(auth, dict) and set(auth.keys()) == {'api_key', 'url'}, (
        'Missing or invalid entry in {0} for instance {1}. You can fix this issue by '
        'adding an entry for {1} or making it look more like this: {2}'
        .format(auth_path, instance_name, example))

    # We just wipe out keys that are invalid.
    if auth['api_key'] and not _is_valid_token(auth['url'], auth['api_key']):
        auth['api_key'] = None

    if not auth['api_key']:
        print('You can find your API key by visiting {} and scrolling to the bottom of the page.'.format(
            auth['url'] + '/#/profile'))
        print('If your key is blank, then click "Generate API Key"')
        auth['api_key'] = _prompt_for_valid_api_key(auth['url'])

        with open(auth_path, 'w') as f:
            json.dump(auth_config, f, indent=4)

    return auth['api_key'], auth['url']
