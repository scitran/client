# Scitran client software

This repository includes Matlab and Python utilities to interact with the SciTran API from the client side for search, get, and put.  See the [project wiki page](https://github.com/scitran/client/wiki) for a general introduction and links to specific manual pages.

## Matlab Client Setup

* If your terminal environment is set up properly, the best way to use scitranClient services is to start matlab from a terminal (to inherit your shell ENV). But many people start from an icon, which sets up its own idiosyncratic environment. If you click, you may have to set your ENV (PATH) to include paths to python & required libs manually.

* Even when using the Matlab version, you must have python on your path to enable authorization. The key Python module is oauth2client.  If you use, say, anaconda to manage your python method than pip is included and you can do the install this way from your terminal
   ```
   pip install oauth2client
   ```
There are many ways to do the install for other systems, and we will add other examples here later.

* The python executable must be in the path environment variable in Matlab.  You can find your path by typing
   ```
   getenv('PATH')
   ```
If the path to python is not in this list, then you set add it, say be
   ```
   setenv('PATH',['/Users/wandell/anaconda/bin/:',getenv('PATH')]);
   ```
You might verify that you succeeded by trying
   ```
   system('which python')
   ```


## Dependencies

* To open up access to a Flywheel instance you will be prompted for the client ID and secret.
This secret can only be given by an administrator of the instance you wish to connect to.

* JSONlab
The MATLAB SciTran client uses JSONlab to load, save, and parse json objects. JSONlab must therefore be on your MATLAB path. You can download JSONlab from https://github.com/fangq/jsonlab.  Version XXX is included in this distribution.

* You must have access to port 9000 to open a browser window/tab. By default this should work just fine. This is almost never a problem, apart from some VM installs. (Deprecate?)


## Python Client
Coming soon...
