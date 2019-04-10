## Gears
Gears are executable programs installed to in a Flywheel site. The Gears are typically either (a) of interest to many users, or (b) run many times (cloud-scale) by the members of a group. Gear installation is managed by the the site manager.  The *Gears* installed at your site are listed when you select 'Installed Gears' on the left panel of the Flywheel web page.  

The Center Edition of Flywheel, where many users share a central resource, usually restricts Installed Gears to programs with modest computational demands that are helpful to many users. The Lab Edition of Flywheel typically has Installed Gears that are more complex and serve specialized lab goals. Gears are distinguished this way because of cost.  MRI service centers do not typically cover the computational costs of data analysis for all the users. Flywheel separates Center and Lab usage so that the computational costs can be assigned to the proper organization (Center vs. Lab).  

The decision about which Gears to install at the Center and Lab is left up to the people at the site. There is no technology issue because *Gears* can be run on almost any platform; they are embedded in a Container technology (Docker Container). Thus, if you learn about a *Gear* at a site other than your own, you can ask for it to be installed at your site.

### Utility Gears
* [Flywheel Utility Gears - Will be added here](https://flywheelio.zendesk.com/hc/en-us)

An example of an important utility used by many people is [**dcm2niix**](https://github.com/rordenlab/dcm2niix) by Chris Rorden and his colleagues.  This important utility converts DICOM files to the NIfTI files that many people use in their data analysis.  Flywheel sites typically have a Gear that can be run automatically to convert DICOM files.  This is a 'Utility Gear'.

### Analysis Gears
* [Flywheel Analysis Gears - Needs improvement](https://docs.flywheel.io/display/EM/Analysis+Gears)

Another important program is [**FreeSurfer**](https://surfer.nmr.mgh.harvard.edu/), by Bruce Fischl and his colleagues. This is a tool that performs many analyses of T1 anatomical files.  If you obtain permission from the MGH group, you can run this 'Analysis Gear' on a Flywheel site.

### Why use Gears?
Some advantages of running Gears within Flywheel is that (a) you do not have to download and install the program itself, (b) the version and time when you ran the program is archived on the site itself, and (c) the outputs of the program are stored on the site either adjacent to the data (Utility Gear) or in an Analysis page (Analysis Gear), and (d) the Flywheel engine (Lab Edition) supports running multiple copies of Analysis Gears.

## Wonkish
Gears are implemented as Docker containers, combined with an interface for letting the user configure the input parameters. Gear execution is managed by specialized software that queues up the jobs as resources become available. Flywheel maintains an [online resource](https://github.com/flywheel-io/exchange) for building and exchanging Gears.  In the long-run, this will expand.