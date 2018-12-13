* This page describes how to download the scitranClient code.
* The [next page, Connecting](Connecting-and-Authentication) describes how to connect to the Flywheel site.

## Github repositories
You can install this scitranClient and another essential toolbox, Guillaume Flandin's code to read and write JSON files (JSONio) by 

    git clone https://github.com/vistalab/scitran
    git clone https://github.com/gllmflndn/JSONio
    
This will create two directories, scitran and JSONio.  Please add both directories to your path, say by using

    chdir(<scitran directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));

## Flywheel SDK

### Matlab toolbox Add-Ons toolbox

#### First installation

The SDK is installed as a Matlab toolbox managed using their 'Add-Ons' methods. You can do the installation with the scitran function from Matlab

    stFlywheelSDK('install');

That command downloads the toolbox from the web and installs it as an Add-On toolbox. You can verify that the toolbox was installed using

    stFlywheelSDK('verify')
    
    >   Name: 'flywheel-sdk'
    >   Version: '4.3.2'
    >   Guid: 'd2fd5657-1710-494e-b5e9-23903828bfb3'


### Upgrading

The SDK is under active development, and we anticipate several new releases through 2018 and into 2019.  Sometimes just invoking 'uninstall' and then 'install' works. In other cases, we have had to 'uninstall', restart matlab, and then 'install'. 

    stFlywheelSDK('uninstall');   % This uninstalls the current version
    ...
    **RESTART MATLAB**
    ....
    stFlywheelSDK('install');   % The latest version changes over time. 

## Connecting
Go to the [next page](Connecting-and-Authentication) for instructions on how to make an authenticated connection

## Wonkish

The SDK is auto-generated into several different languages (Matlab, Python, and R).


