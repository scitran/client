## Downloading and reading

Flywheel objects can generally be downloaded.  This includes project, session, acquisition, file, collection or analysis objects. A project, session, acquisition, collection or analysis is downloaded as a tar file.  

A file is downloaded as, well, a file.

## downloadFile

    scitran.downloadFile(file,'destination',filename,'size',size)

    project = st.search('projects','project label exact','VWFA');
    st.download('project',project{1}.id,'destination','tarfile name');

For detailed examples see the script s_stDownload.m

## Analysis upload

Create an analysis and upload it to an Analysis tab
s_stGears.m line