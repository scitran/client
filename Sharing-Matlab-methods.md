## The compute model
The **scitran** and **toolboxes** classes simplify  sharing Matlab-code and Flywheel-data. A particular goal is to help create reproducible methods for publication. We imagine that users develop scripts and functions that are the basis of their research paper.  These scripts use Matlab toolboxes and functions, and they want to store a record of the processing that can be shared and retrieved. 

Hence, we model the typical use case:

* One or more Matlab toolboxes for the project, available from a github repository. 
* Flywheel data are analyzed with user functions that use the toolboxes, but are not necessarily in them
* Flywheel data are accessed using **scitran** methods

## scitran toolbox methods
**scitran** methods can get a github toolbox (toolboxGet), test whether the Matlab toolbox is installed (toolboxValidate), and install (toolboxInstall) or clone (toolboxClone) the toolbox from github locally. During installation, the methods place the toolbox on the user's path.

