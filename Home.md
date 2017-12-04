The **scitran matlab client** enables Matlab users to interact with a [Flywheel data and computation system](https://flywheel.io). The client methods search, list, upload, download, read and analyze Flywheel data and metadata.  The client can control job scheduling. 

The **scitran matlab client** can be run securely from any computer on the Internet. We have used the client extensively on Mac and Linux systems.

This wiki describes the software and explains how to

* obtain authorization to interact with a Flywheel database
* search the database to get information about its contents
* download and read database objects (e.g., files, sessions, projects, analyses)
* upload files, notes, and attachments to the database (e.g., files, graphs, metadata)
* upload analyses and software (e.g., Matlab files) for computational sharing

This client is part of our vision of using Flywheel to create a reproducible research paper that shares both data and computations. 

### Related information

This client interacts with Flywheel using the [Flywheel SDK](Flywheel-SDK) a platform independent set of functions that are written in [Golang](https://golang.org/).  The Flywheel SDK functions are in a library that is called from Matlab. The scitran matlab client accesses the Flywheel SDK for many basic utilities.

The same Flywheel SDK is also exported into libraries for [**a scitran python client**](https://github.com/scitran/python-client) and a **scitran** 'R' client.

See the [scitran core data model page](https://github.com/scitran/core/wiki/Data-Model) for an introduction to scientific transparency data management software and the Stanford [Project on Scientific Transparency (PoST)](http://post.stanford.edu). 

### Acknowledgement

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency](http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Michael Perry and Brian Wandell.  We thank Renzo Frigato for his contributions.
