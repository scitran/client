To download a container (e.g., project, session, acquisition,  collection or analysis) or a file use a **download**<> method. To get metadata about a file or container, The **read** method downloads a file and calls a function to load/read the data, and then deletes the file.

## File download
A file is downloaded as, well, a file. At present, the downloadFile method requires that you know the container type and the container ID of the file.  This is because files can be attached to many containers (projects, sessions, acquisitions, analyses) and the files themselves do not have IDs.  

### Download from search 

     st = scitran('vistalab');
     file = st.search('file','project label exact','DEMO','filename','dtiError.json');
     fName = st.downloadFile(file{1});

Note that file{1} is a struct, like the one that is returned from a search. At a minimum the struct must contain the fields `file{1}.file.name, file{1}.parent.type and file{1}.parent.x_id`.

### Container type and id known

If you know the container type and id, you can use this form (which also specifies the destination)

    fName = st.downloadFile('dtiError.json',...
          'containerType','project','containerID',id, ...
          'destination',fullfile(pwd,'deleteme.json'));


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

