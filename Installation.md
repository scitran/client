## Github repositories
You must install this scitran repository and Guillaume Flandin's (JSONio). 

    git clone https://github.com/vistalab/scitran
    git clone https://github.com/gllmflndn/JSONio
    
Please add both directories to your path, say by using

    chdir(<scitran directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));

## Flywheel-SDK

### First installation

The Flywheel-SDK is meant to be installed as a Matlab Add-Ons toolbox. You can do the installation using the **scitran** Matlab function

    stFlywheelSDK('install');

The function downloads the Flywheel-SDK from the web and installs it. To verify the installation use

```
>> stFlywheelSDK('verify');
Verified installed version: 4.3.2
```

### Upgrading

We anticipate new Flywheel-SDK releases through 2018 and into 2019, 

New releases may require some adjustments to the scitran client.  The client updates are managed by a git pull of the scitran repository.

To install a new Flywheel-SDK release, use the stFlywheelSDK function.  A typical set of upgrade commands is:

    stFlywheelSDK('verify')       % What is the status?
    stFlywheelSDK('uninstall');   % This uninstalls the current version
    ...
    **RESTART MATLAB**
    ....
    stFlywheelSDK('install');   % The latest version changes over time. 

**N.B. During the upgrade, a warning may advise you to remove directories from the Add-Ons directory. Please do so.**


