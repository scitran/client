## Github repositories
You must install this scitran repository and Guillaume Flandin's (JSONio). 

    git clone https://github.com/vistalab/scitran
    git clone https://github.com/gllmflndn/JSONio
    
Please add both directories to your path, say by using

    chdir(<scitran directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));

## Flywheel SDK

### Matlab toolbox Add-Ons toolbox

#### First installation

The SDK is installed as a Matlab toolbox managed using their 'Add-Ons' methods. You can do the installation with the scitran function from Matlab

    stFlywheelSDK('install');

That command downloads the toolbox from the web and installs it as an Add-On toolbox. You can verify that the toolbox was installed using

```
>> stFlywheelSDK('verify');
Verified installed version: 4.3.2
```

### Upgrading

We anticipate new releases through 2018 and into 2019.  To install a new release, you should be able to call stFlywheelSDK with the 'uninstall' and then 'install' arguments. In certain cases, we have had to 'uninstall', restart Matlab, and then 'install'. 

    stFlywheelSDK('uninstall');   % This uninstalls the current version
    ...
    **RESTART MATLAB**
    ....
    stFlywheelSDK('install');   % The latest version changes over time. 

When running stFlywheelSDK, you may get some directions about removing directories from the Add-Ons directory.  Please follow those directions,



