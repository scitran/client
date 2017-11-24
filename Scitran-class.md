There are two principal classes in the client toolbox.  The **scitran** class and the **toolboxes** class.  The scitran class, described here, is designed to interact with the contents of the Flywheel database.  The toolboxes class is described in a separate page.  It is designed to help you reproduce Matlab computations with Flywheel data.

The scitran object has an expanding and evolving number of methods. This page describes those methods, and we plan to update this information regularly.

The scitran class includes the URL of the Flywheel database, the name of the instance, and the Flywheel SDK class that communicates with the database.  Not shown is the information that authorizes you to see your portion of the database.

```
>> st = scitran('vistalab')

st = 

  scitran with properties:

         url: 'https://vistalab.flywheel.io'
    instance: 'vistalab'
          fw: [1×1 Flywheel]
```

The scitran methods help you identify the contents of the database (search), get information about these objects (e.g., getfileinfo), download and read files stored in the data base.

In addition, there are methods to download a project, session, acquisition, or collection.  A project can be downloaded in the format of a [BIDS directory](http://bids.neuroimaging.io/).

## Methods
```
search -  Search for projects, sessions, acquisitions, collections, files, subjects constrained by many possible limits (file type, label, date...).
downloadFile -
read -   Certain file types can be downloaded and read into a Matlab variable  
downloadObject - Download a directory tree containing a database object as a tar file
projectHierarchy - A listing of the sessions and acquisitions in a project hierarchy 
create - Create a project or a session or an acquistion
put, or putAnalysis - Files, analyses, ...
update - Database values (e.g., subject code, sex ...)
runFunction - Download toolboxes and run a function from a remote site
deleteProject - 

getdicominfo - Information about files or database objects

bidsUpload
bidsDownload

browser - Bring up a browser to a location






