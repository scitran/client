* Gears and Jobs
* SDK programming

***
As Flywheel developed, we find it valuable to separate user programming into two groups, both important.  Certain types of programming involved important programs that were downloaded and installed into their system.  These programs, such as the suite of tools from FSL, Freesurfer, and dcm2niix, are invoked by specifying the input files and a set of parameters that define how the program should be run.  Some of the most important neuroimaging tools are of this type.

In addition to running packaged programs, many users also write their own code.  They write in a variety of languages (Python, Matlab, R). These users need methods to read and edit the Flywheel data and metadata.

Flywheel supports both types of programming.  Configuring and invoking an existing programs is called running a **Gear**.  Interacting with the database through a programming language is called using the Software Development Kit (**SDK**).  **Scitran** is a wrapper on the **SDK** and thus supports local programming. But the SDK also includes methods to invoke **Gears** and monitor their progress, giving the user command line access to **Gears**. 

### Analysis object

### [Github toolbox methods](Toolboxes) support reproducible computation using github repositories.
