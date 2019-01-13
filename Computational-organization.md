## Gears
A **Flywheel Gear** is a way to share software across many users.  Gears are typically created for relatively stable and widely used software. A program that runs without user-intervention, say from a command line, can be transformed into a Flywheel Gear.  Most Flywheel sites have many Gears. You can see the Gears at your site by clicking on 'Gears installed' on the left panel of the Flywheel web page.

The Flywheel system can execute many Gears in parallel. The main limit is the size of your compute architecture. For example, you may want to run a Brain Extraction tool on 100 datasets.  You can instruct the Flywheel system to start up 100 Gears.  The inputs, program parameters, and results will be stored in the Analysis tab.  A record of when the jobs were run and their status (e.g., running or completed) is available in the Provenance Tab.

Flywheel has converted many programs into Gears, including some of the FSL, Freesurfer, ANTS and HCP programs. We use Chris Rorden's dcm2niix utility frequently.  Most sites have added their own Gears, based on their specific interests. These Gears can begin with a compiled program, or they can be based on Python and Matlab programs. You can read more about [Gears on this page](Gears).

## Software Development Kit (SDK)
Many labs develop their own analysis programs; during the development process it is convenient to be able to access the Flywheel data without downloading it. And before the methods are stable, it is often useful to test them using the data in the Flywheel system.

The Flywheel-SDK is a collection of utilities that lets developers interact with the database through their programming environment, either Python, Matlab or R. The **scitran** methods described here are a wrapper on the Matlab version of the Flywheel-SDK.

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


