# Scitran client software

This repository includes utilities to interact with the SciTran API from the client side for search, get, and put

## Matlab setup

* If your terminal environment is set up properly, the best way to use scitranClient services is to start matlab from a terminal (to inherit your shell ENV). But many people start from an icon, which sets up its own idiosyncratic environment. If you click, you may have to set your ENV (PATH) to include paths to python & required libs manually.

* You must have python on your path. The key module is oauth2client.  If you use, say, anaconda to manage your python method than pip is included and you can do the install this way from your terminal
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
* You must have access to port 9000 to open a browser window/tab. By default this should work just fine. This is almost never a problem, apart from some VM installs.

* To open up access to a Flywwheel instancce you will be prompted for the client ID and secret. 
This secret can only be given by an administrator of the instance you wish to connect to.

## Acquiring an authorization token

```token = sdmAuth([],'scitran')```

This will ask you for a client ID and client secret the first time you connect from your account.  These will be acquired by opening a browser and having you login to your google account. The token will be stored for later use. Tokens are stored for about 24 hours. In subsequent cases, you will get the token with the browser, but the client ID and secret will not be needed.  Still, save them somewhere.

