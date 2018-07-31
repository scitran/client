* Download methods (st.fileDownload, st.containerDownload)
* Read methods (st.fileRead, st.containerDownload)
* BIDS download

***

The download methods bring a file or a tar file of everything in a container (e.g., project, session, acquisition,  collection or analysis) to your local disk. 

The **read** methods can be used with certain file types. These methods download a file, read the file's data into a variable, and then delete the file.

## File download
A file is downloaded as, well, a file. At present, the downloadFile method requires that you know the container type and the container ID of the file.  This is because files can be attached to many containers (projects, sessions, acquisitions, analyses) and the files themselves do not have IDs.  

### Download from search 

     st = scitran('stanfordlabs');
     srchfile = st.search('file','project label exact','DEMO','filename','dtiError.json');
     fName = st.fileDownload(srchfile{1});

### Download from a list 
    acquisitions = st.list('acquisition','project label exact','DEMO');
    listfile = st.dataFileList(acquisitions{1});
    fName = st.fileDownload(listfile{1});

### File name, container type and id

If you know the file name, container type and id, you can use this form.  Notice that we also illustrate the use of the key/val parameter 'destination'.
```
project = st.search('file','project label exact','DEMO');
[cType, cID] = st.objectParse(project{1})
fName = st.fileDownload('dtiError.json',...
    'containerType',cType,'containerID',cID, ...
    'destination',fullfile(pwd,'deleteme.json'));
```

### File read

When used with the vistasoft repository, the data from certain file types (matlab, json, obj, nifti) can be read directly into a Matlab variable.  In all cases a matlab file can be read, and a json file can be read.  For obj and nifti files, however, you must have niftiRead and objRead on your path (hence the use of vistasoft).

    [data, outfile] = st.fileRead(file,...);

For detailed examples see the script s_stDownload.m

We are considering how to make sure these read functions are in the distribution.

## Container download

A container download includes everything inside the container.  For example, when a project all the sessions, acquisitions, and files within the container are downloaded.  The data are packaged as a tar-file, and when the tar-file is unpacked the directory structure reflects the Flywheel organization.  The top directory is the group name, then container directories.  Files are within the appropriate container.

This download method is an alternative to using the command line interface and exporting to a BIDS format.

    project = st.search('project','project label exact','VWFA');
    [ cType, cID] = st.objectParse(project{1});
    st.containerDownload(cType,cID,'destination','tarfileName');

A project, session, acquisition, collection or analysis is downloaded as a tar file. The default download destination is 

    fullfile(pwd,sprintf('Flywheel-%s-%s.tar',containerType,id));

## BIDS

Using the CLI to download a project in [BIDS](BIDS) format.

