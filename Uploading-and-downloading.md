
NOTES.  This should be about st.download() and st.read() methods.

## Uploading

### Create a project

    @scitran.create(); 

### Example

Create a data structure and put it (upload) to the site.

https://github.com/vistalab/Newsome--Kiani-2014-CurrentBiology/blob/master/upload_data.m

Should we make an analysis object with its own create, put, get? Check how this would work with the code in s_stGears.m

## Downloading

You can download a project, session or acquisition to a tar file using

    project = st.search('projects','project label','VWFA');
    st.download('project',project{1}.id,'destination','tarfile name');

For detailed examples see the script s_stDownload.m

## Analysis upload

Create an analysis and upload it to an Analysis tab
s_stGears.m line


