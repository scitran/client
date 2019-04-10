All Flywheel containers (projects, sessions, acquisitions, files and collections) have metadata. The metadata are stored in Information fields attached to the container; the information fields are rendered in the interface by clicking on the drawer on the right and selecting 'Information.'

The metadata are a very powerful aspect of analyzing the data. They represent features of the data files such as the subject, the time and date of the experiment, the parameters of the instrument, notes that the experimenters made about the experiment, and so forth.  Just like the experimental data take many forms (e.g., different types of MRI measurements), the metadata too are usefully organized into different categories.

### File metadata (Information)

Every Flywheel file has metadata; the specific entries depends on the type of file. For example, when we read a DICOM file from an MR scanner, Flywheel automatically extracts the header information and incorporates much of it into Information file for the DICOM file. This makes the header information searchable in the database. 

To read the file metadata use the **fileInfoGet** method.
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
The **fileInfoSet** method edits the file's Information field (metadata). This code snippet, which was run on the CNI site, illustrates the **fileInfoSet** method. In this example, we add a metadata field to the file.  The field represents the number of noise spikes in the MR data for this quality assurance test.

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
Containers also have Information fields (metadata). The containerInfoGet and containerInfoSet methods return objects with the metadata. (MORE INSTRUCTIONS NEEDED HERE).

## Modality and classification
Flywheel identifies one special type of metadata, the data **modality**. This is a major description summarizing the type of data.  For most users, the principal modality is magnetic resonance (MR). But some Flywheel users also story data from other modalities (e.g., EEG, PET, Computer Graphics, Dental).  Users are free to create new **modalities** and to associate each modality with specific types of classification data that are unique to that modality.  This can be very helpful for searching and organizing data.

For example, at Stanford we use a Computer Graphics ('CG') modality to store assets for rendering.  We are still experimenting with the fields we will use for classifying the assets, but they include notions of the asset type (e.g., car or pedestrian), and other features (skymap, object).  

Relevant scitran routines for creating modalities and their classifications are

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