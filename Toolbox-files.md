## The compute model
The **scitran** and **toolboxes** classes simplify Matlab code and Flywheel data sharing.  The software is designed for this use case.

* One or more Matlab toolboxes for the project, available from a github repository. 
* Flywheel data are accessed using **scitran** and analyzed with these toolboxes.

## Creating a toolbox file
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

## Uploading the toolbox file 

The JSON file is stored on the project page with a **scitran** command 

    project = st.search('projects','project label exact','SOC ECoG (Hermes)');
    st.upload('SOC-ECoG-toolboxes.json','project',idGet(project));

**scitran** functions that analyze the Flywheel data check whether the user has the Matlab toolboxes on their path and, if necessary, install these toolboxes for the user.

## Example toolbox files
The data directory in scitran includes several toolboxes files and a script, s_tbxSave, 
