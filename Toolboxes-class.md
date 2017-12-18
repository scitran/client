

## Toolboxes methods
The key **toolboxes** methods are saveinfo, install and clone.  These methods add a github repository with your project's toolbox onto your Matlab path.  The scitran method, 'runFunction', downloads and executes a function stored on the Flywheel site, typically on a project page, that relies on these toolboxes.

We suggest that you include the toolboxes.install or toolboxes.clone within the function you are sharing and that will be executed by scitran.runFunction. The toolboxes command first check whether the toolbox is on your path, and the function only downloads if the toolbox is not present.

### saveinfo
Saves out a JSON toolboxes file.

### read
Reads a JSON file and returns a toolbox

### install
Read a toolbox.json file.  Get a zip archive from github and put it on the user's path.  Commit version or branch is allowed.

### clone
Clone a a git repository and add it to the user's path.  cloneDepth allowed.

### github
Open a browser on the github site

    tbx.github('page','wiki')

### test
Test whether the repository already exists on the user's path

