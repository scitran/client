import os

# The path to the python exectuable
EXEC_HOME = os.path.dirname(__file__)
# The user home directory
USER_HOME = os.path.expanduser("~")

AUTH_DIR = os.path.join(USER_HOME, '.stclient')

DEFAULT_DOWNLOADS_DIR = os.path.join(USER_HOME, 'Downloads')
DEFAULT_INPUT_DIR = os.path.join(DEFAULT_DOWNLOADS_DIR, 'input')
DEFAULT_OUTPUT_DIR = os.path.join(DEFAULT_DOWNLOADS_DIR, 'output')
