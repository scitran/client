There are two principal classes in the client toolbox.  The **scitran** class and the **toolboxes** class.  The scitran class, described here, facilitates interactions with Flywheel data.  The **toolboxes** class supports reproducible computation and is described [in a separate page](Toolboxes).

A scitran object is instantiated by a call that identifies which Flywheel database you wish to address. 
```
st = scitran('vistalab');
```

The scitran object contains the Flywheel database url, the instance name, a way to access the Flywheel SDK, and some hidden information about user permission.
```
st = 

  scitran with properties:

         url: 'https://vistalab.flywheel.io'
    instance: 'vistalab'
          fw: [1×1 Flywheel]
```
The [authorization page](Authorization) describes how to create an instance (in this example 'vistalab') and save your Flywheel permission information.

## Methods

The scitran methods enable you to find database contents, get information about these objects, download and upload files, and modify metadata. See the [Flywheel terms](Flywheel-terms) page to learn about the conceptual organization of Flywheel data.

Usage of these scitran class methods are provided in other wiki pages.

```
(IN PROGRESS; INCOMPLETE)

%% Search and list
st.search(objType,...)  -  Search for objects constrained by many possible limits (file type, label, date...).
st.listObjects(objType, parentID, ...) - List objects within a parent; might change to getObjects
[p,s,a] = st.projectHierarchy - List the sessions and acquisitions in a project hierarchy

% Metadata
st.setFileInfo  - Set metadata for a file
st.getdicominfo - Information about files or database objects

% Download and Read
st.downloadFile(file,...) -
st.downloadObject(file,...)  - Download a directory tree containing a database object as a tar file
data = st.read(file,...)  - Certain file types can be downloaded and read into a Matlab variable  
st.dwiLoad - Read a nifti file and its associated bvec/bval data

% Create, modify, upload
st.upload - File upload
st.create - Create a project or a session or an acquisition
st.createCollection
st.modify - Modify database values (e.g., subject code, sex ...)

% Delete
st.deleteFile   - Delete a file
st.deleteObject - Delete container objects

% Computational
st.docker
st.runFunction - Download toolboxes and run a function from a remote site
st.runScript
st.toolbox

% Miscellaneous
st.exist - See if a particular object exists
st.verify
st.browser - Bring a browser to a location

% Not yet decided
st.putAnalysis
st.bidsUpload
st.bidsDownload
```





