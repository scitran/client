
A [BIDS](http://bids.neuroimaging.io/) directory can be uploaded to Flywheel using the scitran method bidsUpload.  A Flywheel project that has been uploaded from a BIDS directory can be downloaded using the scitran methods bidsDownload.  The **bids** class and scitran methods are described here.

## Constructing a bids object

If you have a BIDS data directory (dataDir), we you can build a description of the directory using

    thisBIDS = bids(dataDir)

We expect that dataDir is a directory on your computer that contains a BIDS formatted directory tree.  The bids() constructor scans the directory and returns a bids object that contains a listing of all the BIDS directories, meta data files and imaging data files. You can validate the BIDS compliance using

    thisBIDS.validate

Directory names in the bids object are stored relative to the home of the data directory.

## Uploading
You can upload the BIDS data using these Matlab commands.  The example points to a directory on my disk (fw_test) that contains a BIDS directory tree.  I upload the data to a project assigned to my group (BIDSup).

```
data = bids(fullfile(stRootPath,'local','BIDS-examples','fw_test'));
data.projectLabel = 'BIDSUp';
groupLabel = 'Wandell Lab'; 
project = st.bidsUpload(data,groupLabel);
```

## Downloading

Not converted yet with to the new SDK.  Next weekend's project.

     projectLabel = 'The FW project label'
     bidsDir = st.bidsDownload(projectLabel,'destination',<destination directory>);

## Notes

* We are creating API methods to validate that a Flywheel project has the necessary BIDS information and can be downloaded as a BIDS directory.
* We already run several BIDS applications (fMRIprep and XXX) as Gears on any Flywheel site.
* There is a **Python** method for uploading and downloading.  

## BIDS class methods

```
bids (constructor)
listSubjectFolders
listDataFiles 
listMetaDataFiles
validate
countSessions
```




