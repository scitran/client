## Scitran Client

The **scitran client** is part of our software tools to support scientific transparency and reproducible research.

The deliverable of the [Project on Scientific Transparency (PoST)](http://post.stanford.edu) is the [scientific transparency data management software](https://scitran.github.io/). The software works with a MongoDB database, and it comprises a collection of tools to interact with the database (scitran/core), and an AngularJS front end to manage, view, search, annotate, and generally interact with the data.

The Stanford PoST team has transitioned its work from developing the scitran software to creating application programs to run with the platform. These programs are being developed to support reproducible methods in neuroscience research.

The [scitran code](https://github.com/scitran) continues to be developed by [Flywheel Exchange](https://flyweel.io) and the PoST team (Wandell lab). Through a cooperative agreement, these teams are extending the scitran functions.   In addition, the [Stanford Center for Reproducible Research](http://reproducibility.stanford.edu/) led by Poldrack has engaged members of the Wandell lab to make adjustments to the [scitran code](https://scitran.github.io/) to support their project needs. [Flywheel](https://flywheel.io) also offers support for installation and maintenance of these sophisticated tools; such support is beyond the scope of the Wandell lab.

The **scitran client** repository implements a command line interface to allow users to interact with the scitran database from their own computers.  Specifically, Flywheel and the Wandell lab at Stanford have added features to enable users to perform the following functions

* obtain authorization to read/write from a Flywheel database
* search the database for files
* download the files for processing
* put the results into the database
* put a description of the analysis into the database.  

These functions can be run from anywhere on the Internet. In this way, a user can process data stored in a scitran database using their own computational resources.  The results and precise specification of the analysis can then be placed in the database.

The **scitran client** includes implementations in both Matlab and Python.

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency] (http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Michael Perry, Renzo Frigato, Gunnar Schaefer, and Brian Wandell.
