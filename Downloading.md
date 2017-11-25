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

    project = st.search('projects','project label exact','VWFA');
    st.download('project',project{1}.id,'destination','tarfile name');

For detailed examples see the script s_stDownload.m

## downloadObject


## read


