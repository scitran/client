We have implemented a small group of utility functions that are helpful when we use the scitran matlab client.  This describes those utilities, which are in the utility folder.

### idGet
Structs returned by **search** and **list** have different formats.  Often we want the id of these structs.  You can extract the id for both types using idGet(s);

### year2sec
Searches with respect to dates need to use time in seconds.  This is handled for you in the scitran **search** method. But some day you may want to convert length in years to seconds, and this routine does it.

### stRootPath
We often store temporary files inside the scitranClient local directory.  Or sometimes we read data files from within that directory.  This utility returns the root of the scitran client on your system, so that 

    thisDir = fullfile(stRootPath,'local')

returns the correct directory path on your system.

### workDirectory
For various purposes, we define working directories (e.g., temporary downloads). This utility changes into a working directory, or if it does not exist creates it and then changes into it.

### stPrint
The structs returned by search are complex.  **stPrint** simplifies listing critical fields.  For example, we can print out the label of all the projects returned by a search

    projects = st.search('project');
    stPrint(projects,'project','label');

Or we can print out the label of the projects in the wandell group

```
projects = st.list('project','wandell');
stPrint(projects,'label','')
Returned 12 objects (project)

 label 
-----------------------------
	1 - VWFA 
	2 - HCP 
	3 - Weston Havens 
	4 - Reading Longitude: DWI 
	5 - VWFA FOV Hebrew 
	6 - VWFA FOV 
	7 - Plasticity Retinal Damage 
	8 - EJ Apricot 
	9 - SOC ECoG (Hermes) 
	10 - Rorie PLoS One 2010 
	11 - Kiani Current Biology 2014 
	12 - Brain Beats 
```
Or the subject codes for a particular project
```
project = st.search('project','project label exact','VWFA');
id = idGet(project{1});
sessions = st.list('session',id);   % Parent id
stPrint(sessions,'subject','code')
Returned 4 objects (session)

 subject code
-----------------------------
	1 - ex11353 
	2 - ex11347 
	3 - ex11348 
	4 - ex11352 

```
This function is in active development.  We feel the need, but we are not satisfied with the current solution.

### stParamsFormat
We find it helpful to be able to express parameters as brief phrases, like 'Project label', rather than as strings like 'projectlabel'.  This routine takes a cell array of parameter/val pairs and converts parameter strings (odd entries) to lower case and removes the spaces.  That way the code is always written as projectlabel but the user can specify 'Project Label' or 'project label', adding some grace to life.

### stNewGraphWin
We like plotting functions on this type of a background and menu settings.  So we call **stNewGraphWin** rather than figure.

### tbxRead, tbxWrite
Read and write a toolboxes file


