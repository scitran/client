The **toolboxes** class is designed to help share computational methods in Matlab.  This class assists let you in posting a Matlab function on a Flywheel site and make it simple for a colleague to execute the function. In many cases, you may be sharing the function with your future self.

The key elements of this computation is to provide a place to store individual functions, simplify access to the Flywheel data using scitran, and to automate downloading of the github repositories that contain toolboxes needed to run the functions.

Flywheel Toolboxes for Matlab (FTM) is one of two approaches they take to reproducible computing.  FTM is very useful for custom software and software development. Flywheel uses the Gears mechanism, docker containers packaged with a manifest that allows you to control the parameter setting, for executing standard tools. The Gears system also includes job control for running many jobs on elastic cloud systems, say using kubernetes (k8s).

## TOOLBOXES class methods
The key @toolboxes methods are install and clone.  These methods add a github repository with your project's toolbox onto your Matlab path.  The scitran method, 'runFunction', downloads and executes a function stored on the Flywheel site, typically on a project page, that relies on these toolboxes.

We suggest that you include the toolboxes.install or toolboxes.clone within the function you are sharing and that will be executed by scitran.runFunction. The toolboxes command first check whether the toolbox is on your path, and the function only downloads if the toolbox is not present.

### The install method
Read a toolbox.json file and get a zip archive, put it on path

### The clone method
Clone a a git repository and add it to your path.  cloneDepth allowed.

### Creating and uploading a toolbox.json file

## Examples

### Single unit physiology (Newsome)

### FMRI example (Logothetis)

### ECoG example (Hermes)
