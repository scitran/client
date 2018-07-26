To download a container (e.g., project, session, acquisition,  collection or analysis) or a file use a **download** method. The **read** methods apply to certain file types; these methods download a file, then read the data into a variable, and then delete the downloaded file.

## File download
A file is downloaded as, well, a file. At present, the downloadFile method requires that you know the container type and the container ID of the file.  This is because files can be attached to many containers (projects, sessions, acquisitions, analyses) and the files themselves do not have IDs.  

### Download from search 

     st = scitran('stanfordlabs');
     file = st.search('file','project label exact','DEMO','filename','dtiError.json');
     fName = st.fileDownload(file{1});

Note that file{1} is a flywheel.model.searchResponse.

### Container type and id known

If you know the container type and id, you can use this form (which also specifies the destination)
```
project = st.search('file','project label exact','DEMO');
idGet(project{1},'data type','project')
fName = st.fileDownload('dtiError.json',...
    'containerType','project','containerID',id, ...
    'destination',fullfile(pwd,'deleteme.json'));
```

### File read

* PARTIALLY IMPLEMENTED

When downloading certain files (matlab, json, obj, nifti) you can return the contents of the file into a Matlab variable

    [data, outfile] = scitran.read(file,...);

For detailed examples see the script s_stDownload.m

The read method is the downloadFile method followed by a read/load command and then delete of the downloaded file.

The method is incomplete because for certain file types the load requires an auxiliary functions (e.g., niftiRead). We are considering how to make sure these read functions are in the distribution.

## Container download

** NOT YET IMPLEMENTED **

We are expecting to get an endpoint that downloads a tar-file of a container.  

    project = st.search('project','project label exact','VWFA');
    id = idGet(project{1});
    st.downloadContainer('project',id,'destination','tarfileName');

A project, session, acquisition, collection or analysis is downloaded as a tar file. 

It will soon be possible to download a project in [BIDS](BIDS) format.

