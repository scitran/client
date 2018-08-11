## Github repositories
You can install this scitranClient and another essential toolbox, Guillaume Flandin's code to read and write JSON files (JSONio) by 

    git clone https://github.com/vistasoft/scitran
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
    >   Version: '2.5.0'
    >   Guid: 'd2fd5657-1710-494e-b5e9-23903828bfb3'


### Upgrading

The SDK is under active development, and we anticipate several new releases through 2018 and into 2019.  To install a new specific release number, we suggest you uninstall, restart matlab, and then install.  We have done this sequence several times with success; we haven't succeeded without the restart.  For example, to upgrade to version '2.5.0' you can do this:

    stFlywheelSDK('uninstall');   % This uninstalls the current version
    ...
    **RESTART MATLAB**
    ....
    stFlywheelSDK('install','sdkVersion','2.5.0');   % The latest version changes over time. 

## Connecting
Go to the [next page](Connecting-and-Authenticating) for instructions on how to make an authenticated connection

## Wonkish

The SDK is auto-generated into several different languages (Matlab, Python, and R).


