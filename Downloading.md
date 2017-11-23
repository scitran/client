## Downloading and reading

You can download many different types of Flywheel objects: project, session, acquisition, file, collection or analysis.  In most cases these are downloaded as a zip file.

    project = st.search('projects','project label','VWFA');
    st.download('project',project{1}.id,'destination','tarfile name');

For detailed examples see the script s_stDownload.m

## Analysis upload

Create an analysis and upload it to an Analysis tab
s_stGears.m line