## Download, Get, and Read
To download a container or a file use a **download**<> method. To get metadata about a file or container, use a **get**<> method. The **read** method downloads a file and calls a function to load/read the data, and then deletes the file.

### File download
Flywheel objects (e.g., project, session, acquisition, file, collection or analysis) can be downloaded. A file is downloaded as, well, a file. The method is

    outfile = scitran.downloadFile(file, ...);

where file is a struct, like the one that is returned from a search. 

### Container download

** NOT YET IMPLEMENTED **

We are expecting to get an endpoint that downloads a tar-file of a container.  

    project = st.search('project','project label exact','VWFA');
    id = idGet(project{1});
    st.downloadContainer('project',id,'destination','tarfileName');

A project, session, acquisition, collection or analysis is downloaded as a tar file. 

It will soon be possible to download a project in [BIDS](BIDS) format.

## File read

* PARTIALLY IMPLEMENTED

When downloading certain files (matlab, json, obj, nifti) you can download and return the contents of the file into a Matlab variable, as in

    [data, outfile] = scitran.read(file,...);

For detailed examples see the script s_stDownload.m

The read method is like downloadFile followed by a read/load command.  For certain file types, the load requires an auxiliary functions (e.g., niftiRead). We are considering how to make sure these read functions are in the distribution.


