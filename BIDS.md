# Brain Imaging Data Structure (BIDS)

The scitran Matlab client includes a class definition for BIDS (Brain Imaging Data Structure). The class constructor is invoked by

    thisBIDS = bids(dataDir)

where dataDir is the directory containing a BIDS formatted directory tree.  The invocation scans the directory and returns a structure with a listing of all the BIDS directories, meta data and imaging data files. There is a @bids.validate method, and a few other utilities.

Directory names are stored relative to the main directory.

@bids methods include - bids (constructor), listSubjectFolders, listDataFiles, listMetaDataFiles, validate, countSessions

## Uploading a BIDS directory tree to Flywheel

The @scitran class has a method (bidsUpload) for uploading the @bids data to Flywheel.  An example of its usage is
```
thisBids = bids(bidsDir);
thisBids.projectLabel = 'The FW project label you want';
@scitran.bidsUpload(thisBids,'group label');
```
This will create a project on Flywheel that contains the data and meta data from the bidsDir.  

To download a BIDS project from Flywheel you can use

     projectLabel = 'The FW project label'
     bidsDir = @scitran.bidsDownload(projectLabel,'destination',<destination directory>);



