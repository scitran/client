## The compute model
The **scitran** and **toolboxes** classes simplify Matlab code and Flywheel data sharing with a particular goal of helping create reproducible processes in support of publication. The image we have is that users will develop scripts and functions that are the basis of their research paper.  As the project closes down, they will examine what Matlab toolboxes and functions they used for their analyses, and they will want a record that can be shared and retrieved. 

This leads to the following model for the typical use case:

* One or more Matlab toolboxes for the project, available from a github repository. 
* Flywheel data are analyzed with functions the user creates that use these toolboxes, but may not be in the repository
* Flywheel data are accessed using **scitran** methods

## scitran toolbox methods
To help manage the Matlab toolboxes on github, **scitran** methods can get a github toolbox (toolboxGet), test whether the Matlab toolbox is installed (toolboxValidate), and install the toolbox locally, (toolboxInstall or toolboxClone).  
The methods can place a toolbox on the user's path.

There are also specific **toolboxes** methods, but usually the user invokes this via the higher-level **scitran** methods
