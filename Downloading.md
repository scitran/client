## Downloading and reading

You can download a project, session or acquisition to a tar file using

    project = st.search('projects','project label','VWFA');
    st.download('project',project{1}.id,'destination','tarfile name');

For detailed examples see the script s_stDownload.m

## Analysis upload

Create an analysis and upload it to an Analysis tab
s_stGears.m line