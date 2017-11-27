### Create a project
Create a project hierarchy 
``` 
% Create a project hierarcy and upload a file.  Try various deletions.
st = scitran('vistalab'); 
gName = 'Wandell Lab';
pLabel = 'deleteMe';
sLabel = 'deleteSession';
aLabel = 'deleteAcquisition';

% id has a project, session and acquisition slot.
id     = st.create(gName, pLabel,'session',sLabel,'acquisition',aLabel);
```
## Upload a file
Upload and then check that you can find it.  Sometimes the search takes a few seconds to update the database.
```
fullFileName = fullfile(stRootPath,'data','dtiError.json');
st.upload(fullFileName,'project',id.project);
files = st.search('file',...
      'project label exact',pLabel,...
      'file name','dtiError.json');
```   
### Delete the project
All the subcontainers are deleted, too.
```
containerType = 'project';
containerID = id.project;
st.deleteObject(containerType,containerID);
```

## Analysis upload

Create an analysis and upload it to an Analysis tab
s_stGears.m line

## Check these examples

https://github.com/vistalab/Newsome--Kiani-2014-CurrentBiology/blob/master/upload_data.m

Should we make an analysis object with its own create, put, get? Check how this would work with the code in s_stGears.m




