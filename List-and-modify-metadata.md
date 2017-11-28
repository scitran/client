There are times when you want a listing of the containers and files in a particular project, session or acquisition (parent container). The scitran **list** method returns a list of the metadata within a parent container. The returned information is similar, but not exactly the same, as what is returned by the **search** method.  Search returns information about containers or files that may not have a single parent, but rather can be spread across the whole database.

This list and search methods both return metadata, while the downloadFile method retrieves the file itself.  

## list method
```
st = scitran('vistalab');

% If you start with data from an elastic search, the parent id
% is formatted like this
project      = st.search('project','project label exact','VWFA');
sessions     = st.list('session',project{1}.project.x_id);

% You can also start with data from the list method.
% In that case the group name (not label) is sent for the project
projects     = st.list('project','wandell');

% Notice that the format of the returned struct differs
sessions     = st.list('session',projects{1}.id);
acquisitions = st.list('acquisition',sessions{3}.id); 
files        = st.list('file',acquisitions{1}.id); 
```

### File info

All Flywheel containers, including projects, sessions, acquisitions, files and collections, can have metadata attached to them. These are stored in Information fields attached to the container.  You can see these information containers directly in the user interface by clicking on the drawer on the right.

The setFileInfo method edits the metadata in the Information field of a file.  The information is delivered in the form of a Matlab struct.  This code snippet illustrates the **setFileInfo** method.
```
files = st.search('file',...
    'project label exact','qa',...
    'session label exact','16542',...
    'acquisition label exact','16542_4_1_BOLD_EPI_Ax_AP',...
    'filename contains','json',...
    'filetype','qa',...
    'summary',true);

%% Download the json file
destination = st.downloadFile(files{1});
qaInfo = jsonread(destination);

%% Now, extract the fields we want for the json info data 
jsonInfoFields = {'temporalSNR_median_','medianMd','spikes',...
    'maxMd','tr','version','spikeThresh'};
for ii=1:length(jsonInfoFields)
    jsonInfo.(jsonInfoFields{ii}) = qaInfo.(jsonInfoFields{ii});
end
jsonInfo.numSpikes = numel(qaInfo.spikes);

%% Attach it to the JSON file
st.setFileInfo(files{1},jsonInfo);
```

### Dicom file info
Dicom files are particularly important because their headers contain so much information.  That information is automatically incorporated in to the Information file for the dicom data, when they are read from the scanner.  You can read this metadata using the **getdicominfo** method.
```
st = scitran('cni');
files = st.search('file',...
          'filename exact','16504_4_1_BOLD_EPI_Ax_AP.dicom.zip',...
          'filetype','dicom',...
          'project label exact','qa');

% This returns info as a slot within the files{} struct
files = st.getdicominfo(files);
fprintf('Echo Time %s\n',files{1}.info.('EchoTime'))
Echo Time 30
```

