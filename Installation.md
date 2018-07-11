## Installing

### Github repositories
You can install this scitranClient and another essential toolbox, Guillaume Flandin's code to read and write JSON files (JSONio) by 

    git clone https://github.com/vistasoft/scitran
    git clone https://github.com/gllmflndn/JSONio
    
This will create two directories, scitran and JSONio.  Please add both directories to your path, say by using

    chdir(<scitran directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));

### Flywheel SDK

The SDK is installed as a toolbox in in the Matlab Add-Ons.  This is done once using the scitran function

    stFlywheelSDK('install');

That command downloads the toolbox and installs it in the Add-Ons directory. You can verify or uninstall using

    status = stFlywheelSDK('verify')
    status = stFlywheelSDK('uninstall')

It seems that if you are upgrading it may be necessary to restart matlab.  We have done this sequence several times with success.  We are not sure why the restart may be necessary

    stFlywheelSDK('uninstall');
    RESTART MATLAB
    stFlywheelSDK('install');

### Accessing the SDK

When you create the scitran object, st = scitran('stanfordlabs'), the Flywheel SDK methods are attached in the fw slot.  You can see them by typing st.fw.<TAB>.  The list of SDK commands will show up as options.

This document tersely describes the [SDK methods](https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html).  The scitran methods (st.<TAB>) are intended to be a gentler, kinder, interface to these methods.

The base wiki for [the SDK is here](https://flywheel-io.github.io/core/) The SDK is auto-generated into several different languages (Matlab, Python, and R).

## Flywheel command line interface (CLI)

We will write a stFlywheelCLI to install and invoke.  Hasn't happened yet.


