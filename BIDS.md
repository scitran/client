## Brain Imaging Data Structure (BIDS)

The scitran Matlab client includes a class definition for BIDS (Brain Imaging Data Structure). The class constructor is invoked by

    thisBIDS = bids(dataDir)

where dataDir is the directory containing a BIDS formatted directory tree.  The constructor scans the directory and returns a bids object that contains a listing of all the BIDS directories, meta data files and imaging data files. There is a @bids.validate method, and a few other utilities to help you check that the directory is compliant. 

Directory names in the bids object are stored relative to the home of the data directory.

@bids methods include - bids (constructor), listSubjectFolders, listDataFiles, listMetaDataFiles, validate, countSessions

### BIDS uploading to Flywheel

The @scitran class has a method (bidsUpload) for uploading the @bids data to Flywheel.  The following code creates a Flywheel project that contains the data and meta data from the BIDS compliant directory in bidsDir.  

```
st = scitran(<your flywheel instance>)
thisBids = bids(bidsDir);
thisBids.projectLabel = 'The project label you choose';
st.bidsUpload(thisBids,'group label');
```

### BIDS downloading from Flywheel

To download a BIDS project that is stored on Flywheel use

     projectLabel = 'The FW project label'
     bidsDir = @scitran.bidsDownload(projectLabel,'destination',<destination directory>);

## General downloading from Flywheel

More generally, you can download any project to a tar file simply using

    project = st.search('projects','project label','VWFA');
    st.download('project',project{1}.id,'destination','tarfile name');


