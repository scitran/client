# Scitran client software for Matlab

This repository includes Matlab utilities to work with the SciTran API, which is implemented in Flywheel and openNeuro.org. The Matlab client implements many functions, including search, get, and put. See the [scitran client wiki page](https://github.com/scitran/client/wiki) for a manual with examples of how to use this code.

Most MRI databases require some authorization before you can download, upload, or search. Speak to your administrator about the appropriate method for your database.

## Installing from the terminal

You can install this scitranClient and another essential toolbox - Guillaume Flandin's code to read and write JSON files (JSONio) - by: 

    git clone https://github.com/scitran/client
    git clone https://github.com/gllmflndn/JSONio
    
This will create two directories, client and JSONio.  We suggest renaming the 'client' directory 'scitranClient'.  

Add both directories to your Matlab path, with:

```matlab
    chdir(<scitran client directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));
```

## Installing from Matlab

We provide a script [(installScitran.m)](https://github.com/scitran/client/blob/master/utility/installScitran.m) to enable installation from the Matlab command line<sup>*</sup>

That script can be run interactively from within Matlab (>=R2014b):

```matlab
eval(webread('https://raw.githubusercontent.com/scitran/client/master/utility/installScitran.m'));
```

<sup>*</sup> Requires `git` command-line tool to be available via Matlab.
