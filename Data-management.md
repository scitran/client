Scitran data management methods enable you to find database contents, get information about these objects, download and upload files, and modify metadata. See the [Flywheel terms](Flywheel-terms) page to learn about the conceptual organization of Flywheel data.

Usage details of these methods are provided in other wiki pages.   Because the code is still under development, for now we encourage you to type help or doc to bring up the current information in the method, say

    doc scitran.MethodName

As the methods input and return parameters stabilize, we will put more information in the wiki.  

```
%% Search and list
st.search  -  Search for objects constrained by many possible limits (file type, label, date...).
st.list    - List objects within a parent; might change to getObjects
st.projectHierarchy - Create a struct summarizing the project, sessions and acquisitions
st.projectID - Return the id of the project

% File
st.fileDelete   - Delete remote file
st.fileDownload - Write file to disk
st.fileRead     - Certain file types can be downloaded and read into a Matlab variable  
st.fileInfoGet
st.fileInfoSet
st.fileUpload

% Container methods (project, session, acquisition)
st.containerUpload   - Not sure this is real
st.containerDownload - Download a directory tree containing a database object as a tar file
st.containerCreate   - Create a project or a session or an acquisition
st.containerDelete - Delete container objects
st.containerInfoSet  - Set database values (e.g., subject code, sex ...)
st.containerInfoGet  - Get database values (e.g., subject code, sex ...)

% Analysis
st. analysisAddNote
st.analysisCreate
st.analysisDownload
st.analysisInfoGet
st.analysisInfoSet
st.analysisUpload

% Not sure why this isn't grouped with container, but probably a good reason
st.collectionCreate
st.collectionDelete

% MRI utilities
st.dwiDownload - Read a nifti file and its associated bvec/bval data
st.dicomInfoGet   - Information about files or database objects
st.vistaDownload* - Create a local vistasoft data structure

% Computational
st.docker*
st.runFunction* - Download toolboxes and run a function from a remote site
st.toolboxClone()
st.toolboxGet()
st.toolboxInstall()
st.toolboxValidate()

% Miscellaneous
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

% BIDS related
st.bidsUpload*
st.bidsDownload*

*Early in development
```





