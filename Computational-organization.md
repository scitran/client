## Gears
**Flywheel Gears** are a way to share software between users.  Gears are stored in the Flywheel system.  They are typically created for stable and widely shared software. Nearly any program that runs without user-intervention can be transformed into a Flywheel Gear.  Flywheel has converted many programs into Gears, including some of the FSL, Freesurfer, ANTS and HCP programs. We use Chris Rorden's dcm2niix utility frequently.  

Most sites have many Gears; you can see the Gears at your site by clicking on 'Gears installed' on the left panel of the Flywheel web page. Most sites have added Gears based on their specific interests. These Gears can be based on a compiled program, or they can be based on Python, Matlab or R programs. [Read about Gears on this page](Gears).

## Jobs
The Flywheel system can execute many Gears in parallel. The main limit is the size of your compute architecture. For example, you may want to run a Brain Extraction tool on 100 datasets.  You can instruct the Flywheel system to start up 100 Jobs that execute Gears on different data sets.  The inputs, program parameters, and results will be stored in the Analysis tab.  There is an Analysis tab for each Session, and there is an Analysis tab for each Project. 

A record of when the jobs were run and their status (e.g., running or completed) is available in the Provenance Tab.

## Software Development Kit (SDK)
Many labs develop their own analysis programs; during the development process it is convenient to be able to access Flywheel data and methods. The Flywheel-SDK is a collection of utilities that lets developers interact with the database through their programming environment, either Python, Matlab or R. The **scitran** methods described here are a wrapper on the Matlab version of the Flywheel-SDK.

### Methods
[**Scitran** methods](https://github.com/vistalab/scitran/wiki/scitran-methods) are organized into actions that apply to containers, data files, info (metadata), analyses, gears, and jobs. The naming convention we use is to specify the **type of object** followed by an **action**.  For example, suppose you create a **scitran** object, 

    st = scitran('stanfordlabs');

The **scitran** instance has many methods.  The naming convention for the methods is <noun><Action>.  The <noun> describes the type of object you are working on (e.g., a container) and the <Action> describes what you are doing.  For example,

```
st.containerDownload - downloading one of the several container types
st.containerCreate   - create a container on the remote site
st.fileDownload      - downloads a data file
st.fileDelete        - delete a file
st.analysisUpload    - create and upload an analysis structure
```
Use tab-completion (e.g., st.file<Tab>-completion) to see the list of methods. Or, to see an overview of a method run

     doc scitran
     doc scitran.containerDownload

For most methods, you can see examples of how they are used with the stExamplesShow function.  For example,

    stExamplesShow('scitran.containerDownload');
    stExamplesShow('scitran.fileRead');
    stExamplesShow('scitran.analysisDownload');

The Flywheel **SDK** also includes methods for securely connecting to the site, reading and writing data and metadata, storing analysis results, creating projects, controlling Gears and Jobs, and more.

## CLI - Command line interface

We will add text about this separate programming utility at a later time.


