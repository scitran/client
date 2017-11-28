All Flywheel containers, including projects, sessions, acquisitions, files and collections, can have metadata attached to them. These are stored in Information fields attached to the container.  You can see these information containers directly in the user interface by clicking on the drawer on the right.

### File Info
The **setFileInfo** method edits the metadata in the Information field of a file.  The information is contained in a Matlab struct.  This code snippet illustrates the **setFileInfo** method.
```
% Find a json file that has data we will use for the information field
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

%% Extract the fields from the json data and put them in a struct
jsonInfoFields = {'temporalSNR_median_','medianMd','spikes',...
    'maxMd','tr','version','spikeThresh'};
for ii=1:length(jsonInfoFields)
    jsonInfo.(jsonInfoFields{ii}) = qaInfo.(jsonInfoFields{ii});
end
jsonInfo.numSpikes = numel(qaInfo.spikes);

%% Call setFileInfo to attach the information to the file.
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

