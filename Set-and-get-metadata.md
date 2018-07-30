All Flywheel containers (projects, sessions, acquisitions, files and collections) have metadata. The metadata are stored in Information fields attached to the container; the information fields are rendered in the interface by clicking on the drawer on the right and selecting 'Information.'

The metadata are a very powerful aspect of analyzing the data. They represent features of the data files such as the subject, the time and date of the experiment, the parameters of the instrument, notes that the experimenters made about the experiment, and so forth.  Just like the experimental data take many forms (e.g., different types of MRI measurements), the metadata too are usefully organized into different categories.

### Info

Files have metadata associated with them. For example, when we read a DICOM file from a scanner, Flywheel automatically extracts the header information and incorporates much of it into Information file for the dicom file. This makes the header information searchable in the database. 

To read this metadata use the **fileInfoGet** method.
```
st = scitran('cni');
files = st.search('file',...
          'filename exact','16504_4_1_BOLD_EPI_Ax_AP.dicom.zip',...
          'filetype','dicom',...
          'project label exact','qa');

% This returns info as a slot within the files{} struct
info = st.fileInfoGet(files{1});

% The info structure has a lot of fields with useful metadata
info.classification
  CommonClassification with properties:

         Intent: {'Functional'}
    Measurement: {'T2*'}

info.info
  AcquisitionDate: 20171113
  AcquisitionMatrix: [4×1 double]
  AcquisitionNumber: 1
  AcquisitionTime: 84103
  AngioFlag: 'N' 
...
fprintf('%d\n',info.info.EchoTime)
30
```
### fileInfoSet
The **fileInfoSet** method lets you edit metadata in a file's Information field. This code snippet, which was run on the CNI site, illustrates the **fileInfoSet** method.
```
% This json file has metadata we use in our quality assurance testing
  files = st.search('file',...
    'project label exact','qa',...
    'session label exact','16542',...
    'acquisition label exact','4_1_BOLD_EPI_Ax_AP',...
    'filename contains','json',...
    'filetype','qa',...
    'summary',true);

%% Download the json file into this qaInfo struct
qaInfo = st.fileRead(files{1})

%% Add a field to the struct
qaInfo.numSpikes = numel(qaInfo.spikes);

%% Call setFileInfo to attach the information to the file.
st.fileInfoSet(files{1},qaInfo);
```

### Container info

The search and list operations typically return the metadata (info) about a container.  The getContainerInfo and setContainerInfo methods return structs with the metadata (info). They are not used a lot because the information is also present from a list or search.  (MORE INSTRUCTIONS NEEDED HERE).


## Modality and classification
The Flywheel database recognizes different types of experimental modalities.  For many people, the principle modality is magnetic resonance data (MR). But new modalities (e.g., EEG, PET, Computer Graphics, Dental) have also been used.  Users are free to create new **modalities** and to classify data within the modality.  By choosing the right modality and setting up its classification, you provide a framework for the metadata in that modality.

Relevant scitran routines for creating modalities are

```
st.modalityCreate;
st.modalityReplace;
st.modalityDelete;
```

Each modality has different classifications with in it.  These are part of the metadata about the data.  For example, the classification fields of MR data are extremely rich.  Click on an information for an MR Dicom data file to see some of the fields.

You can read and set these fields programmatically using 

```
st.dataFileModalitySet
st.dataFileModalityGet
```

## Scratch code to deal with somewhere

```
%{
% st.fw.getAcquisitionFileInfo(thisAcquisition.id,thisFile.name)
% Not sure if we can replace modality and classification, or only
% classification
thisStruct = struct('modality','CG','classification',struct('asset',{{'car'}}));
thisStruct = struct('asset',{{'car'}});
st.fw.setAcquisitionFileClassification(thisAcquisition.id, files.name, thisStruct)
%}
%{
% We think this follows the logic.  Let's ask JE what we should do
%
st.fw.replaceAcquisitionFileClassification(thisAcquisition.id, files.name, struct('asset',{{'car'}}))
%}

%%
%{
st = scitran('stanfordlabs');
h = st.projectHierarchy('Graphics assets');

% How do we adjust cInput?
% cInput = flywheel.model.ClassificationUpdateInput;
acquisitions = h.acquisitions{2};   % From session 2
thisAcquisition = acquisitions{2};
files = thisAcquisition.files;
thisFile = files{1}
%}
```