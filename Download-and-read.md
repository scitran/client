## Downloading and reading

Flywheel objects (e.g., project, session, acquisition, file, collection or analysis) can be downloaded. A file is downloaded as, well, a file. The method is

    outfile = scitran.downloadFile(file, ...);

where file is a struct, like the one that is returned from a search.  When downloading certain files (matlab, json, obj, nifti) you can both download and return the contents of the file into a Matlab variable, as in

    [data, outfile] = scitran.read(file,...);

A project, session, acquisition, collection or analysis is downloaded as a tar file. 

    outfile = scitran.downloadObject(objectID, ...);

And it is also possible to download a project in [BIDS](BIDS) format.

## downloadFile

    scitran.downloadFile(file,'destination',filename,'size',size)

For detailed examples see the script s_stDownload.m

## downloadObject

We are expecting to get an endpoint that downloads a tar-file of a container.  ** NOT YET IMPLEMENTED **

    project = st.search('project','project label exact','VWFA');
    id = idGet(project{1});
    st.download('project',id,'destination','tarfileName');

## read

TBD - the read method is like downloadFile plus a read command.  To run this, however, you require certain auxiliary functions (e.g., niftiRead).  We are considering how to make sure these read functions are in the distribution.


