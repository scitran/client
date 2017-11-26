The **toolboxes** object contains two types of information.  One is a command that can be executed to test whether the toolbox is on the path (testcmd).  The second is a structure that contains enough information to download a git repository (gitrepo). 

Here is an example toolboxes object, tbx.
```
disp(tbx)
  toolboxes with properties:

    testcmd: 'dtiError'
    gitrepo: [1×1 struct]
```
The gitrepo structure contains this information
```
>> disp(tbx.gitrepo)
       user: 'scitran-apps'
    project: 'dti-error'
     commit: 'master'
```
The data directory in scitran includes several toolboxes files and a script, s_tbxSave, used to write those JSON files. The code looks like this:
```
tbx = toolboxes('');
tbx.testcmd     = 'dtiError';
tbx.gitrepo.user    = 'scitran-apps'; 
tbx.gitrepo.project = 'dti-error'; 
tbxWrite('dti-error.json',tbx);
```
Multiple toolboxes can be combined into a single file and uploaded. In this example, the stToolbox() function reads two JSON files, describing two repositories.  These are placed in an array, and written out to a new JSON file. 
```
tbx(1) = stToolbox('dtiError.json');
tbx(2) = stToolbox('vistasoft.json');
tbxWrite('aldit-toolboxes.json',tbx);
% Subsequently, you can read the combined file to get the toolboxes array
% tbx = stToolbox('aldit-toolboxes.json');
```
Uploading the file to the project looks like this
```
% upload to the project page
project = st.search('project','project label exact','ALDIT');
st.upload('aldit-toolboxes.json','project',project{1}.project.x_id);
```
