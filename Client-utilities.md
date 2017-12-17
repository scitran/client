We have implemented a small group of utility functions that are helpful when we use the scitran matlab client.  This describes those utilities, which are in the utility folder.

### idGet
Structs returned by search and list have different formats.  Often we want the id of these structs.  You can extract the id for both types using idGet(s);

### year2sec
Searches with respect to dates need to use time in seconds.  This is handled for you in the scitran **search** method. But some day you may want to convert length in years to seconds, and this routine does it.

### stRootPath
We often store temporary files inside the scitranClient local directory.  Or sometimes we read data files from within that directory.  This utility returns the root of the scitran client on your system, so that 

    fullfile(stRootPath,'local')

works on your system.

### workDirectory

### stPrint

### stParamsFormat
We find it helpful to be able to express parameters as brief phrases, like 'Project label', rather than as strings like 'projectlabel'.  This routine takes a cell array of parameter/val pairs and converts parameter strings (odd entries) to lower case and removes the spaces.  That way the code is always written as projectlabel but the user can specify 'Project Label' or 'project label', adding some grace to life.

### stNewGraphWin
We like plotting functions on this type of a background

### tbxRead, tbxWrite
Read and write a toolboxes file


