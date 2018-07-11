## Github repositories
You can install this scitranClient and another essential toolbox, Guillaume Flandin's code to read and write JSON files (JSONio) by 

    git clone https://github.com/vistasoft/scitran
    git clone https://github.com/gllmflndn/JSONio
    
This will create two directories, scitran and JSONio.  Please add both directories to your path, say by using

    chdir(<scitran directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));

## Flywheel SDK

### Matlab toolbox Add-Ons toolbox

The SDK is installed as a Matlab toolbox managed using their 'Add-Ons' methods. The installation is done once, and you can do the installation with the scitran function

    stFlywheelSDK('install');

That command downloads the toolbox from the web and installs it as an Add-On toolbox. You can verify or uninstall the toolbox using

    status = stFlywheelSDK('verify')
    status = stFlywheelSDK('uninstall')

If you are upgrading we suggest you uninstall, restart matlab, and then install.  We have done this sequence several times with success.  We haven't succeeded without the restart.

    stFlywheelSDK('uninstall');
    RESTART MATLAB
    stFlywheelSDK('install');

### SDK methods
The scitran methods are a kinder, gentler interface to the Flywheel SDK methods. If you want to use the SDK methods directly, the scitran object makes them available through the fw slot. You can see the full list of methods by typing 

    st = scitran('stanfordlabs');
    st.fw.<TAB>

The list of SDK commands will show up as optional Matlab completions. 

* [This api web page](https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html) tersely describes the SDK methods. It also includes some chatty description and examples. 
* [This wiki web page](https://flywheel-io.github.io/core/) has the core documentation.

The SDK is auto-generated into several different languages (Matlab, Python, and R).

## Flywheel command line interface (CLI)

We will write a stFlywheelCLI to install and invoke.  Hasn't happened yet.


