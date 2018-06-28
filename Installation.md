## Installing from the terminal

### Github repositories
You can install this scitranClient and another essential toolbox, Guillaume Flandin's code to read and write JSON files (JSONio) by 

    git clone https://github.com/scitran/client
    git clone https://github.com/gllmflndn/JSONio
    
This will create two directories, client and JSONio.  We suggest renaming the 'client' directory 'scitranClient'.  Please add both directories to your path, say by using

    chdir(<scitran client directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));

### Flywheel Add-Ons

You will also need to have the Flywheel Add-Ons library installed.  This is done once using

    stFlywheelAddons('install',true);

Subsequently, you can verify that the install is there using

    status = stFlywheelAddons('exist',true)

and you can uninstall using

    status = stFlywheelAddons('uninstall',true);

