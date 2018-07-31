* Gears and Jobs
* SDK programming
* Github

***
Flywheel recognizes two types of typical user computing.  
* Most users execute programs that are installed in the user's system (e.g., FSL, Freesurfer, and dcm2niix). These programs can be installed within the Flywheel system and then run by specifying input files and parameters. 
* Some users also develop their **own code** in Python, Matlab, R, or bash scripts. These users need tools to obtain authorization to read and edit Flywheel data and metadata, and to store the results of their analyses

Flywheel supports both types of computation; the computational methods of Flywheel are expanding all the time.

* Running a program that is installed within Flywheel is called running a **Gear**.   
* Users writing their own code are supported through the Flywheel Software Development Kit (**SDK**).

**Scitran** is a Matlab wrapper on the Flywheel **SDK**. The **SDK** is quite large and includes methods to invoke **Gears** and monitor their progress. The SDK also has methods for authorizing the user to read and write to the Flywheel system, creating projects, and much more.

## Gears
Certain types of programs are important utilities that are run by many different users. Rather than having every user install, it is possible to install the program within Flywheel as a *Gear*.  The installation is usually managed by Flywheel itself or by the site manager.  You can see the set of *Gears* installed at your site by clicking on 'Gears installed' on the left panel of the Flywheel web page.

An example of an important utility used by many people is [**dcm2niix**](https://github.com/rordenlab/dcm2niix) by Chris Rorden and his colleagues.  This important utility converts DICOM files to the NIfTI files that many people use in their data analysis.  Flywheel sites typically have a Gear that can be run automatically to convert DICOM files.  This is a 'Utility Gear'.

Another important program is [**FreeSurfer**](https://surfer.nmr.mgh.harvard.edu/), by Bruce Fischl and his colleagues. This is a tool that performs many analyses of T1 anatomical files.  If you obtain permission from the MGH group, you can run this 'Analysis Gear' on a Flywheel site.

The advantage of running these Gears within Flywheel is that (a) you do not have to download and install the program itself, (b) the version and time when you ran the program is archived on the site itself, and (c) the outputs of the program are stored on the site either adjacent to the data (Utility Gear) or in an Analysis page (Analysis Gear).

## SDK

## CLI - Command line interface

## Analysis containers

## Github

[Github toolbox methods](Toolboxes) support reproducible computation using github repositories.
