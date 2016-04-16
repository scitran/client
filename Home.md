## Scitran Client

See the scitran core wiki page for an introduction to [scientific transparency data management software](https://github.com/scitran/core/wiki) and the Stanford [Project on Scientific Transparency (PoST)](http://post.stanford.edu). 

The **scitran client** repository implements a command line interface to allow users to interact with the scitran database from their own computers.  Specifically, Flywheel and the Wandell lab at Stanford have added features to enable users to perform the following functions

* obtain authorization to read/write from a Flywheel database
* search the database for a collection of sessions and the files therein
* download a representation of the information
* search the local representation for files with specific properties
* download individual files for processing
* create a description of the processing 
* place the results and description of the processing back into the database

These scitran client can be run from anywhere on the Internet, securely addressing the data in the scitran database. In this way, a user can process data stored in a scitran database using their own computational resources.  The key elements that supports reproducible research is this:  The original files are securely stored in a database, the analysis methods are precisely described, and the results and analysis specification are stored back in the database. 

The **scitran client** will include implementations in both Matlab and Python.  The client will include examples of how to reproducibly run many standard functions from FSL, FreeSurfer, SPM, and other packages.

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency] (http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Michael Perry, Renzo Frigato, Gunnar Schaefer, and Brian Wandell.
