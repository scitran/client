# Scitran client software

This repository includes Matlab utilities to work with the SciTran API, which is implemented in Flywheel and openFMRI, from the client side.  The Matlab side implements many functions, including search, get, and put. See the [scitran project wiki page](https://github.com/scitran/client/wiki) for a manual and examples of how to use this code.

Most MRI databases require some authorization before you can download, upload, or search. Speak to your administrator about the appropriate method for your database.

## Python

Even when using the Matlab client, you must have python on your path to enable authorization. The essential Python module is oauth2client.  If you use, say, anaconda to manage your python method than pip is included and you can do the install this way from your terminal
   ```
   pip install oauth2client
   ```
There are many ways to do the install for other systems, and we will add other examples here later.

The python executable must be in the path environment variable in Matlab.  You can find your path by typing
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
## Installing from within Matlab

You can install this scitranClient and another essential toolbox, Guillaume Flandin's code to read and write JSON files (JSONio) by 

    git clone https://github.com/scitran/client
    git clone https://github.com/gllmflndn/JSONio
    
and adding both directories to your path.  We suggest renaming the 'client' directory 'scitranClient'.

This is implemented in the following few lines of Matlab code.

```
fprintf('\n\n');
prompt = sprintf('Do you want to install into %s [Y/N]\n',pwd);
str = input(prompt,'s');

if isequal(lower(str),'y')
    thisDir = pwd;
    status = system('git clone https://github.com/scitran/client');
    if status, error('Problem cloning the scitran client repository'); end
    movefile('client','scitranClient');
    
    status = system('git clone https://github.com/gllmflndn/JSONio');
    if status, error('Problem cloning the JSONio repository'); end
    
    chdir('scitranClient'); addpath(genpath(pwd));
    chdir(thisDir); chdir('JSONio'); addpath(genpath(pwd));
    
    chdir(thisDir);
    
    % Tell user where they are
    fprintf('\nscitranClient and JSONio toolboxes are installed in \n---\n \t %s\n---\n',thisDir);
else
    fprintf('User canceled installation.\n');
end
```

## Docker

You may want to run docker containers, which requires that you have Docker installed on your local machine. To do that visit the docker website for [OSX](https://docs.docker.com/engine/installation/mac/) and [Linux](https://docs.docker.com/linux/step_one/) instructions. If you have Homebrew on OSX, you can install the toolbox from the command line with `brew cask install dockertoolbox`.

Once Docker is installed you can invoke any docker machine and container you set up on your computer. To set up the configuration for your computer, use the command [matlab/stDockerConfig.m](https://github.com/scitran/client/blob/master/utility/stDockerConfig.m).

## Deprecated - right?

I think there is now a configure routine, right?  So this text no longer applies?

If your terminal environment is set up properly, the best way to initiate scitran client is to start matlab from a terminal. In that case, the Matlab program inherits your shell ENV. Many people start Matlab from an icon, however. This sets up Matlab's own idiosyncratic environment. In that case, you may have to set your ENV (PATH) to include paths to python & required libs manually from within Matlab. See XXX for instructions on how to do this.


