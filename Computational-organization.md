* Gears and Jobs
* SDK programming
* Github

***

## Types of computing
Flywheel recognizes two typical modes of computing.  

1. Nearly all users execute some programs that are installed in their local (e.g., FSL, Freesurfer, and dcm2niix). These programs also can be installed within the Flywheel system and run by specifying input files and parameters. 
2. Some users develop their **own code** in Python, Matlab, R, or bash scripts. Flywheel supports these users with tools to obtain authorization to read and edit data and metadata and to store the analysis results.

## Gears and the SDK

Running a program that is installed within Flywheel is called running a **Gear**. The tools to support users writing their own code is called the Flywheel Software Development Kit (**SDK**).

**Scitran** is a Matlab wrapper on the Flywheel **SDK**, which is quite extensive.  There are methods for connecting to the site and authorizing the user, reading and writing data and metadata, storing analysis results, creating projects, and much more. The SDK also includes methods to invoke **Gears** and monitor their progress. 

## CLI - Command line interface


