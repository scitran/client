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

Here is a script if you prefer to install from the Matlab command line.

https://github.com/scitran/client/blob/master/utility/installScitran.m


