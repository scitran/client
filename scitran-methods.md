### Tips
* Projects, sessions and acquisitions are containers.  
* Collections are a special type of container.  
* Some files are data files, other files are attachments.  
* Info refers to metadata
* Notes, tags and attachments are special kinds of metadata

## Data methods
```
%% Search and list
st.search  -  Search for files, containers, and related
st.list    - List objects within a parent; might change to getObjects
st.projectID - Return the id of the project
st.projectHierarchy - List the project, sessions and acquisitions

% File
st.fileDelete   - Delete remote data file
st.fileDownload - Write data file to disk
st.fileUpload   - Upload a data file
st.fileRead     - Certain file types can be downloaded and read into a Matlab variable  
st.fileInfoGet  - Get file metadata
st.fileInfoSet  - Set file metadata

% Container methods (project, session, acquisition)
st.containerUpload   - Not sure this is real
st.containerDownload - Download the container and its contents as a tar file
st.containerCreate   - Create a project or a session or an acquisition
st.containerDelete   - Delete container and its contents
st.containerInfoSet  - Set metadata values (e.g., subject code, sex ...)
st.containerInfoGet  - Get metadata values (e.g., subject code, sex ...)

% A special type of container
st.collectionCreate
st.collectionDelete
```
## Computational methods
```
% Analysis
st.analysisAddNote
st.analysisCreate
st.analysisDownload
st.analysisInfoGet
st.analysisInfoSet
st.analysisUpload

% MRI utilities
st.dwiDownload - Read a nifti file and its associated bvec/bval data
st.dicomInfoGet   - Information about files or database objects
st.vistaDownload* - Create a local vistasoft data structure

% Github Toolbox methods
st.toolboxClone()
st.toolboxGet()
st.toolboxInstall()
st.toolboxValidate()

% Computational utilities
st.docker*
st.runFunction* - Download toolboxes and run a function from a remote site

```
## Miscellaneous methods
```
st.exist   - See if a container with a particular label exists
st.verify  - Test that the connection was made
st.browser - Bring a browser to a location
st.listInstances
st.showToken

% Also miscellaneous 
st.authAPIKey
st.print*
st.help*
st.API;
st.siteConfig()

*Early in development
```
