* Gears and Jobs
* SDK programming
* Github

***
## Gears
Most MRI Centers have computer programs that are used by many users.  These programs can be inserted into the Flywheel system, and users can run them from the web interface or through the SDK. To add a specific program into the system you create a **Flywheel Gear**. Compiled programs that run without user-intervention, say from a command line, can be transformed into a Flywheel Gear.  Most Flywheel sites have many Gears. These are executable programs that are place into Docker containers using a specific organization. You can see the Gears at your site by clicking on 'Gears installed' on the left panel of the Flywheel web page.

You can run a Flywheel Gear on data from pull down menus in the web-interface.  The computational system can execute many jobs in parallel. For example, you may want to run a Brain Extraction tool on 100 datasets.  You can instruct the Flywheel system to start up 100 Gears.  The inputs, program parameters, and results will be stored in the Analysis tab.  A record of when the jobs were run and their status (e.g., running or completed) is available in the Provenance Tab.

Examples of programs that we have converted into Gears are some of the FSL, Freesurfer and HCP tools.  We also use Chris Rorden's dcm2niix utility frequently.  We also added Gears based on the work of people at our site, including both Python and Matlab programs. You can read more about [Gears on this page](Gears).

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


