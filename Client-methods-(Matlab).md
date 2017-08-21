There are two principal classes in the client toolbox.  The **scitran** class and the **toolboxes** class.

## SCITRAN class methods

The main @scitran methods are search, get, put, read, runFunction, browser.  There are other methods (e.g.,  ...).  Here we explain the main methods and point to scripts that use these methods.

### search
Find projects, sessions, acquisitions, collections, files, subjects constrained by many possible limits (file type, label, date...).  This is big.

### get
Individual files.

### read
File read and return data in a Matlab variable

### download
A tar file of a project, session, or acquisition

### projectHierarchy
A listing of the sessions and acquisitions in a project hierarchy

### bids download/upload
Download or upload a BIDS directory tree

### create
Create a project or a session or an acquistion

### put, or putAnalysis
Files, analyses, ...

### update
Database values (e.g., subject code, sex ...)

### runFunction
Download toolboxes and run a function from a remote site

### browser
Bring up a browser to a location

### deleteProject

## TOOLBOXES class methods
The main @toolboxes methods are install and clone.  In addition there are ().

### install
Read a toolbox.json file and get a zip archive, put it on path

### clone
Clone a a git repository and add it to your path.  cloneDepth allowed.

## BIDS class methods

### bids

### validate





