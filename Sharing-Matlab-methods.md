## The compute model
The **scitran** and **toolboxes** classes simplify sharing Matlab-code that uses Flywheel-data. A main goal is to suppport reproducible methods for publication. We want to provide simple tools to help users store a record of the processing that can be shared and retrieved. 

Flywheel already incorporates Gears and Analyses to help with reproducibility.  The Flywheel Matlab client fills a different nice. This client models the case in which you are preparing analyses and figures for a paper.  This work uses

* One or more Matlab toolboxes for the project, available from a github repository. 
* Your own project-specific Matlab functions that use these toolboxes
* Flywheel data are accessed using **scitran** methods

## scitran toolbox methods

**scitran** toolbox methods help with the following tasks

* **toolboxGet**      - get a specification of the toolboxes used in the project
* **toolboxValidate** - test whether the toolboxes are installed on your path
* **toolboxInstall**  - download a zip record of the toolboxes
* **toolboxClone**    - git clone the toolboxes to your computer

During installation or cloning, the toolboxes are added to the user's path.

