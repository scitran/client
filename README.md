# Scitran client software

This repository includes Matlab utilities to work with the SciTran API, which is implemented in Flywheel and openFMRI, from the client side.  The Matlab side implements many functions, including search, get, and put. See the [scitran project wiki page](https://github.com/scitran/client/wiki) for a manual and examples of how to use this code.

Recall that most MRI databases require authorization. Speak to your administrator about the client ID and secret.

## Python setup

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
You might verify that you succeeded by trying from within your Matlab command window
   ```
   system('which python')
   ```
* If your terminal environment is set up properly, the best way to initiate scitran client is to start matlab from a terminal.  In that case, the Matlab program inherits your shell ENV. Many people start Matlab from an icon, however. This sets up Matlab's own idiosyncratic environment. In that case, you may have to set your ENV (PATH) to include paths to python & required libs manually from within Matlab.  See XXX for instructions on how to do this.

## JSONio

We rely upon Guillaume Flandin's code to read and write JSON files.  The version we use is forked and a particular commit, which you can get here 
   ```
   git clone https://github.com/vistalab/JSONio.git
   ```
   
## Docker requirements

For certain applications, you will want to run docker containers. This will require that you have Docker installed on your local machine. To do that visit the docker website for [OSX](https://docs.docker.com/engine/installation/mac/) and [Linux](https://docs.docker.com/linux/step_one/) instructions. If you have Homebrew on OSX, you can install the toolbox from the command line with `brew cask install dockertoolbox`.

Once you have Docker installed you can invoke any docker machine and container you set up on your computer.

If you're using `docker-machine` on OSX there are a couple more steps required. First you will need to first create a 'machine'. To create a machine you should issue the `create` command (below we use 'default' for the machine name):

   ```
   docker-machine create --driver virtualbox default
   ```

To get the machine started, issue the `start` command followed by the machine name:

  ```
  docker-machine start default
  ```
Now you're ready to issue docker commands through Matlab or Python. See [matlab/stDockerConfig.m](https://github.com/scitran/client/blob/master/utility/stDockerConfig.m) for Matlab implementation details.



