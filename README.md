# Scitran client software

This repository includes Matlab utilities to work with the SciTran API, which is implemented in Flywheel and openNeuro.org. The Matlab client implements many functions, including search, get, and put. See the [scitran client wiki page](https://github.com/scitran/client/wiki) for a manual with examples of how to use this code.

Most MRI databases require some authorization before you can download, upload, or search. Speak to your administrator about the appropriate method for your database.

## Installing from the terminal

You can install this scitranClient and another essential toolbox, Guillaume Flandin's code to read and write JSON files (JSONio) by 

    git clone https://github.com/scitran/client
    git clone https://github.com/gllmflndn/JSONio
    
This will create two directories, client and JSONio.  We suggest renaming the 'client' directory 'scitranClient'.  Please add both directories to your path, say by using

    chdir(<scitran client directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));

## Installing from Matlab (alternative)

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

