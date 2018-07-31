## Gears
Gears are executable programs installed to run with the data in a Flywheel site.  Typically, the Gears run programs that are of interest to many users. The installation is usually managed by Flywheel itself or by the site manager.  You can see the set of *Gears* installed at your site by clicking on 'Gears installed' on the left panel of the Flywheel web page.  

There is continuing growth in the number of Gears and what they do. For the Center Edition of Flywheel, where many users share a central resource, the ability to run Gears is usually restricted to programs that have modest computational demands and are used by many users.  If you hear about a *Gear* at a site other than your own, you can ask for it to be installed.  

Computationally demanding Gears that are used for specialized purposes are typically installed and run on the Lab Edition. This lets Flywheel determine the costs of computation and memory so the charge can be assigned to the appropriate research group.

### Utility Gears
* [Flywheel Utility Gears - Needs improvement](https://docs.flywheel.io/display/EM/Utility+Gears)

An example of an important utility used by many people is [**dcm2niix**](https://github.com/rordenlab/dcm2niix) by Chris Rorden and his colleagues.  This important utility converts DICOM files to the NIfTI files that many people use in their data analysis.  Flywheel sites typically have a Gear that can be run automatically to convert DICOM files.  This is a 'Utility Gear'.

### Analysis Gears
* [Flywheel Analysis Gears - Needs improvement](https://docs.flywheel.io/display/EM/Analysis+Gears)

Another important program is [**FreeSurfer**](https://surfer.nmr.mgh.harvard.edu/), by Bruce Fischl and his colleagues. This is a tool that performs many analyses of T1 anatomical files.  If you obtain permission from the MGH group, you can run this 'Analysis Gear' on a Flywheel site.

### Why use Gears?
Some advantages of running Gears within Flywheel is that (a) you do not have to download and install the program itself, (b) the version and time when you ran the program is archived on the site itself, and (c) the outputs of the program are stored on the site either adjacent to the data (Utility Gear) or in an Analysis page (Analysis Gear), and (d) the Flywheel engine (Lab Edition) supports running multiple copies of Analysis Gears.

## Wonkish
Gears are implemented as Docker containers, combined with an interface for letting the user configure the input parameters. Gear execution is managed by specialized software that queues up the jobs as resources become available. Flywheel maintains an [online resource](https://github.com/flywheel-io/exchange) for building and exchanging Gears.  In the long-run, this will expand.