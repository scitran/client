## The compute model
The **scitran** and **toolboxes** classes simplify Matlab code and Flywheel data sharing.  The software is designed for this use case.

* One or more Matlab toolboxes for the project, available from a github repository. 
* Flywheel data are accessed using **scitran** and analyzed with functions based on these toolboxes.

## scitran toolbox methods
The **scitran** class has methods that gets a toolbox file (getToolbox), tests whether the Matlab toolbox is installed (toolboxValidate), and downloads and installs the toolbox placing on the user's path (toolbox).  The install can be either based on downloading a zip file or cloning the github repository.

## toolboxes class
The **toolboxes** methods simplify installing (either zip or clone) github repositories.  The methods also test whether a toolbox is already on the user's path.  Most people do not use these methods directly, but use them via methods in the **scitran** class.
