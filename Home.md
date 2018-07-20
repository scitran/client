The **scitran matlab client** enables Matlab users to compute with a [Flywheel data and computation system](https://flywheel.io). The client methods help you search, upload, download, read and analyze Flywheel data and metadata. The client also schedules and controls jobs (Gears). 

The **scitran matlab client** can be run securely from any computer on the Internet. We have used the client extensively on Mac and Linux systems.

This wiki describes the software and explains how to

* obtain authorization to interact with a Flywheel database
* list and search the database contents (files, metadata, and jobs)
* download and read database objects (e.g., files, sessions, projects, analyses)
* upload files, notes, and attachments (e.g., files, graphs, metadata)
* upload analyses and software (e.g., Matlab files) for computational sharing

This client is part of our vision of using Flywheel to create a reproducible research paper that shares both data and computations. 

See the [Stanford Project on Scientific Transparency (PoST)](http://post.stanford.edu) for an overview of our goals.

### Related information

This client relies on the [Flywheel SDK](Flywheel-SDK) a platform independent set of functions that are written in [Golang](https://golang.org/).  This client calls the Flywheel SDK functions from Matlab. The same Flywheel SDK is used by [**a scitran python client**](https://github.com/scitran/python-client) and a **scitran** 'R' client.

### Acknowledgement

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency](http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Michael Perry and Brian Wandell.  We thank Renzo Frigato, Nathaniel Kofalt, Megan Henning, and Jen Reiter for their contributions.
