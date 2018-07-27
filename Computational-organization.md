* Gears and Jobs
* SDK programming

***
We find it valuable to separate Flywheel computing into two types.  One type involves executes programs that are installed in the user's system (e.g., FSL, Freesurfer, and dcm2niix). To run, these programs must specify input files and parameters.  Many important neuroimaging tools are of this type.

In addition, many users write their own code. They write in a variety of languages (Python, Matlab, R, bash scripts). These users use methods to read and edit the Flywheel data and metadata.

Flywheel supports both types of computation.  Configuring and invoking an existing program is called running a **Gear**.  When a user writes their own program, they interact with Flywheel using the Software Development Kit (**SDK**).

**Scitran** is a Matlab wrapper on the **SDK**. The SDK includes methods to invoke **Gears** and monitor their progress. This gives the user command line access to controlling **Gears**. 

### Analysis object

### [Github toolbox methods](Toolboxes) support reproducible computation using github repositories.
