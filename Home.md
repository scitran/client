The **scitran Matlab client** enables users to compute with a [Flywheel data and computation system](https://flywheel.io) from their Matlab command line. The client has functions that search, upload, download, read and analyze Flywheel data and metadata. The client also schedules and controls jobs (Gears). 

The **scitran matlab client** can be run securely from any computer on the Internet. We have used the client extensively on Mac and Linux systems.

This wiki has a conceptual overview of Flywheel and then explanations on how to

* obtain authorization and connect with a Flywheel database
* list and search the database contents (files, metadata, and jobs)
* download and read database objects (e.g., files, sessions, projects, analyses)
* upload files, notes, and attachments (e.g., files, graphs, metadata)
* upload analyses and software (e.g., Matlab files) for computational sharing

This client and Flywheel are part of our vision to create a work environment that supports sharing data and computations. We hope this work will lead to reproducible research that is accessed through publications. See the [Stanford Project on Scientific Transparency (PoST)](http://post.stanford.edu) for an overview of our goals.

### Related information

This client relies on the [Flywheel SDK](Flywheel-SDK) a platform independent set of functions.  This client calls the Flywheel SDK functions from Matlab. The same Flywheel SDK is used by [**a scitran python client**](https://github.com/scitran/python-client) and a **scitran** 'R' client.

### Acknowledgement

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency](http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Justin Ehlert, Michael Perry, Gari Lerma, Zhenyi Liu, and Brian Wandell.  We thank Renzo Frigato, Nathaniel Kofalt, Megan Henning, and Jen Reiter for their contributions.
