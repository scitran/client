There are two principal classes in the client toolbox.  The **scitran** class and the **toolboxes** class.  The scitran class, described here, facilitates interactions with Flywheel data.  The **toolboxes** class supports reproducible computation and is described [in a separate page](Toolboxes).

A scitran object is instantiated by a call that identifies which Flywheel database you wish to address. 
```
st = scitran('stanfordlabs');
```

The scitran object contains the Flywheel database url, the instance name, a way to access the Flywheel SDK, and some hidden information about user permission.
```
st = 

  scitran with properties:

         url: 'https://vistalab.flywheel.io'
    instance: 'vistalab'
          fw: [1×1 Flywheel]
```
The [authentication page](Authorization) describes how to create an instance (in this example 'vistalab') and save your Flywheel permission information.

## Methods
Scitran methods enable you to find database contents, get information about these objects, download and upload files, and modify metadata. See the [Flywheel terms](Flywheel-terms) page to learn about the conceptual organization of Flywheel data.

Usage of these scitran class methods are provided in other wiki pages.  When the architecture of the input parameters stabilizes, we will put more information in the wiki.  Because the code is still under development, for now we encourage you to type

    doc scitran.METHODNAME

This will bring up the current information in the method.

```
(IN PROGRESS; INCOMPLETE)

%% Search and list
st.search()  -  Search for objects constrained by many possible limits (file type, label, date...).
st.list()    - List objects within a parent; might change to getObjects
st.projectHierarchy() - Create a struct summarizing the project, sessions and acquisitions

% Download and Read
st.fileDelete()   - Delete remote file
st.fileDownload() - Write file to disk
st.fileRead()     - Certain file types can be downloaded and read into a Matlab variable  
st.fileInfoGet()
st.fileInfoSet()
st.fileUpload()


% Container methods (project, session, acquisition)
st.containerUpload()   - Not sure this is real
st.containerDownload() - Download a directory tree containing a database object as a tar file
st.containerCreate()   - Create a project or a session or an acquisition
st.containerDelete() - Delete container objects
st.containerInfoSet()  - Set database values (e.g., subject code, sex ...)
st.containerInfoGet()  - Get database values (e.g., subject code, sex ...)

% MRI utilities
st.dwiDownload - Read a nifti file and its associated bvec/bval data
st.dicomInfoGet   - Information about files or database objects
st.vistaDownload* - Create a local vistasoft data structure

% Not sure why this isn't grouped with container, but probably a good reason
st.collectionCreate()
st.collectionDelete()

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





