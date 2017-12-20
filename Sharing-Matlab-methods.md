## The compute model
The **scitran** and **toolboxes** classes simplify sharing Matlab-code that uses Flywheel-data. A main goal is to support reproducible methods for publication. Flywheel already incorporates Gears and Analyses to help with reproducibility. The Flywheel Matlab client supports a different niche; you are preparing analyses and figures for a paper.  

In general, we suppose that:

* There are one or more Matlab toolboxes for the project, available from a github repository. 
* You have your own project-specific Matlab functions that use these toolboxes
* Your functions access Flywheel data using **scitran** methods

## scitran toolbox methods

**scitran** toolbox methods help with the following tasks

* **toolboxGet**      - read a specification of the toolboxes used in the project
* **toolboxValidate** - test whether the toolboxes are installed on your path
* **toolboxInstall**  - download a zip record of the toolboxes
* **toolboxClone**    - git clone the toolboxes to your computer
* **runFunction**     - run (locally) a Matlab function stored on the Flywheel site 

During installation or cloning, the toolboxes are added to the user's path.

