Flywheel **toolboxes** for Matlab (FTM) is a class helps you share Matlab functions reproducibly with colleagues. In many cases, you will be sharing the function with your future self. The idea is to write a Matlab function that uses **scitran** to access Flywheel data, and uses **toolboxes** to download Matlab libraries from github that are needed to run these functions.

FTM is useful for custom software and software development. Flywheel uses the Gears concept, docker containers packaged with a manifest that allows you to control the parameter setting, for executing standard tools. The Gears system also includes job control for scheduling and logging jobs. Flywheel is well on its way towards implementing an elastic cloud system using distributed storage and kubernetes (k8s).

## TOOLBOXES class methods
The key **toolboxes** methods are saveinfo, install and clone.  These methods add a github repository with your project's toolbox onto your Matlab path.  The scitran method, 'runFunction', downloads and executes a function stored on the Flywheel site, typically on a project page, that relies on these toolboxes.

We suggest that you include the toolboxes.install or toolboxes.clone within the function you are sharing and that will be executed by scitran.runFunction. The toolboxes command first check whether the toolbox is on your path, and the function only downloads if the toolbox is not present.

### saveinfo


### install
Read a toolbox.json file and get a zip archive, put it on path

### clone
Clone a a git repository and add it to your path.  cloneDepth allowed.

### Creating and uploading a toolbox.json file

## Examples

### Single unit physiology (Newsome)

### FMRI example (Logothetis)

### ECoG example (Hermes)
