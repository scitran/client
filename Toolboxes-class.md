

## Toolboxes methods
The key **toolboxes** methods are saveinfo, install and clone.  These methods add a github repository with your project's toolbox onto your Matlab path.  The scitran method, 'runFunction', downloads and executes a function stored on the Flywheel site, typically on a project page, that relies on these toolboxes.

We suggest that you include the toolboxes.install or toolboxes.clone within the function you are sharing and that will be executed by scitran.runFunction. The toolboxes command first check whether the toolbox is on your path, and the function only downloads if the toolbox is not present.

### saveinfo

### install
Read a toolbox.json file and get a zip archive, put it on path

### clone
Clone a a git repository and add it to your path.  cloneDepth allowed.

### github
Open a browser on the github site

    tbx.github('page','wiki')


