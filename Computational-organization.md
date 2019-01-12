* Gears and Jobs
* SDK programming
* Github

***

## Gears
Most users execute programs that are installed in their local computer. These programs can be executables written and shared by someone else (e.g., the FSL and Freesurfer packages, or important utilities such as dcm2niix).  These programs might be written by someone at your own site.  Or, they might be scripts that call a series of executables. Often, a site will have a very stable version of the executable code and many people will want to share that code.  Flywheel provides a mechanism so that all users have access to the program and run it on the Flywheel site. These installed programs are called Flywheel Gears.

Programs that run without user-intervention, say from a command line, can be transformed into a Flywheel Gear. Any program that can takes files as inputs, sets parameters on the command line, and returns files as outputs, can be installed as a Flywheel Gear.  Most Flywheel sites have many Gears already.  You can see the set of *Gears* installed at your site by clicking on 'Gears installed' on the left panel of the Flywheel web page.

You can read more about [Gears on this page](Gears).

## Software Development Kit (SDK)
### Methods

[**Scitran** methods](https://github.com/vistalab/scitran/wiki/scitran-methods) are organized into actions that apply to containers, data files, info (metadata), analyses, gears, and jobs. The naming convention we use is to specify the **type of object** followed by an **action**.  For example, suppose you create a scitran object, 

    st = scitran('stanfordlabs');

The scitran object has many methods, such as
```
st.containerDownload - downloading one of the several container types
st.containerCreate - Create a container on the remote site
st.fileDownload - downloads a data file
st.fileDelete -  delete a file
st.analysisUpload - Create and upload an analysis structure
```
Use tab-completion (e.g., st.file<Tab>) to see the list of methods, or run

     doc scitran

**Scitran** is a Matlab wrapper on the Flywheel **SDK**, which is quite extensive.  There are methods for connecting to the site and authorizing the user, reading and writing data and metadata, storing analysis results, creating projects, and much more. The SDK also includes methods to invoke **Gears** and monitor their progress. 

This entire wiki is an explanation of tools that invoke the SDK from Matlab.

## CLI - Command line interface


