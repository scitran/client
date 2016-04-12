## Scitran Client

The **scitran client software** is part of our software tools to support scientific transparency and reproducible research.

The heart of Stanford's [Project on Scientific Transparency (PoST)](http://post.stanford.edu) is the [scientific transparency data management (SDM) software](https://github.com/scitran). The software works with a MongoDB database, and it comprises a collection of tools to interact with the database (api), and an AngularJS front end to manage, view, search, annotate, and generally interact with the data.

PoST has transitioned its work from developing the SDM system to creating application programs to run on the SDM platform. These programs are being developed to support reproducible methods in neuroimaging research.

The SDM continues to be developed by [Flywheel Exchange](https://flyweel.io). They are extending the SDM functions, and they are offering support for installation and maintenance for these sophisticated tools.

This project, **scitran client**, is a command line interface to allow users to interact with the Flywheel (SDM) database.  Flywheel and the Wandell lab at Stanford have added features to enable users to perform the following functions

* obtain authorization to read/write from a Flywheel database
* search the database for files
* download the files for processing
* put the results 
* put a description of the analysis into the database.  

These functions can be run from anywhere on the Internet. In this way, a user can process data stored in a Flywheel database using their own computational resources.  The results and precise specification of the analysis can then be placed in the database.

The **scitran client** includes implementations in both Matlab and Python.

