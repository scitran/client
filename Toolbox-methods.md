Toolbox files specify the github repository and a command for testing for the presence of the repository. The specification is stored on Flywheel, often on the project page.  The specification is a JSON file.  This code snippet reads a file stored on the Flywheel site
```
st = scitran('vistalab');
tbx = st.toolboxGet('aldit-toolboxes.json','project','ALDIT');
```
tbx is a toolboxes object that contains information about the github repositories where the toolboxes can be found.

### Validating a toolbox
Validate whether a toolbox is on your path this way
```
>> st.toolboxValidate(tbx);
Repo dti-error (dtiError) found.
Repo vistasoft (vistaRootPath) found.
```
### Installing or cloning a toolbox
If the toolboxes are not on your path, install them using install or clone methods. The install version download a zip file from the github site.
```
tbx = st.toolboxInstall(tbx);
```
The clone method calls 'git clone' on the github site.  
``` 
tbx = st.toolboxClone(tbx);
```
Both of these methods can be used with flags that specify a commit or branch or clone depth.

## About Toolboxes
### Printing toolbox info
```
tbxPrint(tbx);

Toolbox 1
-------------
Toolbox project name dti-error
User account: scitran-apps
Commit:  master
Repository url:  https://github.com/scitran-apps/dti-error
-------------
 dtiError is on your current path in directory /Users/wandell/Documents/MATLAB/dti-error/src.

Toolbox 2
-------------
Toolbox project name vistasoft
User account: vistalab
Commit:  master
Repository url:  https://github.com/vistalab/vistasoft
-------------
 vistaRootPath is on your current path in directory /Users/wandell/Documents/MATLAB/vistasoft.
```
### Creating the JSON toolbox file
Information about the toolboxes is stored in a small JSON file that is attached to a Flywheel project page.  

For example, the Wandell lab uses the vistasoft toolbox.  The **toolbox** specifies (a) a command that can be used to test whether the toolbox is installed on the user's path (testcmd), and (b) the user and project on the github site.  This information is saved in a JSON file as follows.
```
tbx.testcmd     = 'vistaRootPath';
tbx.gitrepo.user    = 'vistalab';  % https://github.com/vistalab/vistasoft
tbx.gitrepo.project = 'vistasoft'; % https://github.com/vistalab/vistasoft
tbx.saveinfo;                      % Save the toolbox information to vistasoft.json
```
Optionally, the JSON file can specify a specific commit or branch on github.  The gitrepo structure contains this information
```
>> disp(tbx.gitrepo)
       user: 'scitran-apps'
    project: 'dti-error'
     commit: 'master'
```
By default, the latest commit from the master branch is assumed.

A project may depend on multiple toolboxes.  For example, Dora Hermes wrote an ECoG toolbox which is specified in ecogBasic.json. To analyze data in her ECoG project we merge the two toolboxes into a single file
```
clear tbx
tbx(1) = stToolbox('ecogBasicCode.json');
tbx(2) = stToolbox('vistasoft.json');
tbxWrite('SOC-ECoG-toolboxes.json',tbx);
```

### Uploading the JSON toolbox file

The JSON file defining the toolboxes is stored on the project page with a **scitran** command 

    project = st.search('projects','project label exact','SOC ECoG (Hermes)');
    st.upload('SOC-ECoG-toolboxes.json','project',idGet(project));

### Example files
The data directory in scitran includes several toolboxes files and a script, s_tbxSave, 
