## Scitran Client

The **scitran client software** is part of our software tools to support scientific transparency and reproducible research.

The heart of the [Project on Scientific Transparency (PoST)](http://post.stanford.edu) is the [scientific transparency data management software](https://github.com/scitran). The software works with a MongoDB database, and it comprises a collection of tools to interact with the database (api), and an AngularJS front end to manage, view, search, annotate, and generally interact with the data.

PoST has transitioned its work from developing the scitran software to creating application programs to run on the platform. These programs are being developed to support reproducible methods in neuroimaging research.

The code within [scitran](https://scitran.github.io/) continues to be developed by [Flywheel Exchange](https://flyweel.io) and the Wandell Lab at Stanford. Through a cooperative agreement, these teams are extending the scitran functions.  Flywheel also offers support for installation and maintenance for these sophisticated tools, a task which is beyond the scope of the Wandell lab. In addition, the [Stanford Center for Reproducible Research](http://reproducibility.stanford.edu/) led by Poldrack has engaged members of the Wandell lab to make adjustments to the **scitran** code to support their project needs.

The **scitran client** repository implements a command line interface to allow users to interact with the Flywheel (SDM) database from their own computers.  Specifically, Flywheel and the Wandell lab at Stanford have added features to enable users to perform the following functions

* obtain authorization to read/write from a Flywheel database
* search the database for files
* download the files for processing
* put the results into the database
* put a description of the analysis into the database.  

These functions can be run from anywhere on the Internet. In this way, a user can process data stored in a Flywheel database using their own computational resources.  The results and precise specification of the analysis can then be placed in the database.

The **scitran client** includes implementations in both Matlab and Python.

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency] (http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Michael Perry, Renzo Frigato, Gunnar Schaefer, and Brian Wandell.
