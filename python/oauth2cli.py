"""
to run it:
sudo pip install oauth2client
python oauth2cli.py --auth_host_port 9000 --client-secret <client-secret> --client-id <client-id>

it creates a json file called "credentials_sdm"
the access_token in the credentials is also printed to stdout
"""

from oauth2client.client import OAuth2WebServerFlow, OAuth2Credentials
from oauth2client.file import Storage
import argparse
from oauth2client import tools
import contextlib
import sys
import cStringIO
import httplib2


@contextlib.contextmanager
def nostdout():
    save_stdout = sys.stdout
    sys.stdout = cStringIO.StringIO()
    yield
    sys.stdout = save_stdout

def main(args):
    flow = OAuth2WebServerFlow(client_id=args.client_id,
                           client_secret=args.client_secret,
                           scope='https://www.googleapis.com/auth/userinfo.email')
    storage = Storage(args.filename)
    credentials = tools.run_flow(flow, storage, args)
    return credentials

def refresh(args):
    try:
        with open(args.filename, 'rU') as f:
            credentials = OAuth2Credentials.from_json(f.read())
    except IOError:
        print >> sys.stderr, 'file', args.filename, 'does not exist'
        return
    if credentials.invalid:
        print >> sys.stderr, 'invalid_grant: Token has been revoked.'
        return
    if credentials.access_token_expired:
        try:
            credentials.refresh(httplib2.Http())
            storage = Storage(args.filename)
            storage.put(credentials)
            credentials.set_store(storage)
        except Exception as e:
            print >> sys.stderr, e
            return
    return credentials

def revoke(args):
    try:
        with open(args.filename, 'rU') as f:
            credentials = OAuth2Credentials.from_json(f.read())
    except IOError:
        print >> sys.stderr, 'file', args.filename, 'does not exist'
        return
    try:
        credentials.revoke(httplib2.Http())
        storage = Storage(args.filename)
        storage.put(credentials)
        credentials.set_store(storage)
    except Exception as e:
        print >> sys.stderr, e
        return

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--filename', type=str, default='credentials_sdm')
    subparsers = parser.add_subparsers()
    subparser_create = subparsers.add_parser('create', help='create a new token', parents=[tools.argparser])
    subparser_create.add_argument('--client-id', type=str, required=True)
    subparser_create.add_argument('--client-secret', type=str, required=True)
    subparser_create.set_defaults(func=main)
    subparser_refresh = subparsers.add_parser('refresh', help='refresh an existing token')
    subparser_refresh.set_defaults(func=refresh)
    subparser_refresh = subparsers.add_parser('revoke', help='revoke a token')
    subparser_refresh.set_defaults(func=revoke)
    args = parser.parse_args()
    with nostdout():
        c = args.func(args)
    if c:
        print c.access_token
