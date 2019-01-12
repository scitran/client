The **scitran Matlab client** enables users to programmatically control a [Flywheel data and computation system](https://flywheel.io) from their Matlab command window. The client has functions that search, upload, download, read and analyze Flywheel data and metadata. The client also schedules and controls computational jobs (Gears). 

The **scitran matlab client** can be run securely from any computer on the Internet. We have used the client extensively on Mac and Linux systems.

This wiki has a [conceptual overview](Conceptual-overview) of Flywheel and then explanations on how to

* [connect securely with a Flywheel database](Connecting-and-Authentication) 
* search the database contents (files, metadata, gears, and jobs)
* read the metadata about specific files, analyses, and containers (projects, sessions, acquisitions, collections)
* download files, analyses, notes, and containers 
* upload files, analyses, and notes into containers 

This client and Flywheel are part of our software development to support a work environment that supports sharing data and computations. We hope these tools lead to reproducible research that supports better sharing through publications. See the [Stanford Project on Scientific Transparency (PoST)](http://post.stanford.edu) for a statement of our goals.

### Related information

This client is a wrapper on the [Flywheel SDK](Flywheel-SDK) developed by Justin Ehlert. The SDK is a platform independent set of functions that access the endpoints in the Flywheel API.  This client provides an interface to the Flywheel SDK functions that we believe makes them easier to understand and use.  The comments in the code are designed to help people learn about the SDK and to add further functionality.

The same Flywheel SDK is used by [**a scitran python client**](https://github.com/scitran/python-client) and a **scitran** 'R' client.  We are unaware of similar wrappers for those clients.

### Acknowledgement

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency](http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Justin Ehlert, Michael Perry, Gari Lerma, Zhenyi Liu, and Brian Wandell.  We thank Renzo Frigato, Nathaniel Kofalt, Megan Henning, and Jen Reiter for their contributions.
