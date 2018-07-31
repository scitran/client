* Gears and Jobs
* SDK programming
* Github

***
Flywheel recognizes two typical modes of computing.  

1. Nearly all users execute some programs that are installed in their local (e.g., FSL, Freesurfer, and dcm2niix). These programs also can be installed within the Flywheel system and run by specifying input files and parameters. 
2. Some users develop their **own code** in Python, Matlab, R, or bash scripts. Flywheel supports these users with tools to obtain authorization to read and edit data and metadata and to store the analysis results.

Running a program that is installed within Flywheel is called running a **Gear**. The tools to support users writing their own code is called the Flywheel Software Development Kit (**SDK**).

**Scitran** is a Matlab wrapper on the Flywheel **SDK**, which is quite extensive.  There are methods for connecting to the site and authorizing the user, reading and writing data and metadata, storing analysis results, creating projects, and much more. The SDK also includes methods to invoke **Gears** and monitor their progress. 

## Gears
Certain types of programs are run routinely by many users. Such programs can be installed within Flywheel as a *Gear*.  The installation is usually managed by Flywheel itself or by the site manager.  You can see the set of *Gears* installed at your site by clicking on 'Gears installed' on the left panel of the Flywheel web page.

An example of an important program used by many people is [**dcm2niix**](https://github.com/rordenlab/dcm2niix) by Chris Rorden and his colleagues.  This utility converts DICOM files to the NIfTI files that many people use in their data analysis.  By installing this program as a Flywheel Gear, individual users are saved the trouble of downloading and installing. This is an example of a 'Utility Gear'.

Another important program is [**FreeSurfer**](https://surfer.nmr.mgh.harvard.edu/), by Bruce Fischl and his colleagues. This tool performs many analyses of T1 anatomical files.  If you obtain a (free) license from the MGH group, you can run FreeSurfer as an 'Analysis Gear' on a Flywheel site.  This saves users from downloading and installing.  Flywheel also manages resources so that people can run the tool in parallel on many data sets. This is particularly effective when the Flywheel instance is hosted on the Google Cloud Platform.

The advantage of running Gears within Flywheel is that (a) you do not have to download and install the program itself, (b) the version and time when you ran the program is archived on the site itself, and (c) the outputs of the program are stored on the site either adjacent to the data (Utility Gear) or in an Analysis page (Analysis Gear), and (d) the Flywheel engine (Lab Edition) supports running multiple copies of Analysis Gears.

## SDK

## CLI - Command line interface

## Analysis containers

## Github

[Github toolbox methods](Toolboxes) support reproducible computation using github repositories.
