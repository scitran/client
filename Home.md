The **scitran Matlab client** enables users to programmatically control a [Flywheel data and computation system](https://flywheel.io) from their Matlab command window. The client has functions that search, upload, download, read and analyze Flywheel data and metadata. The client also schedules and controls computational jobs (Gears). 

The **scitran matlab client** can be run securely from any computer on the Internet. We have used the client extensively on Mac and Linux systems.

This wiki has a [conceptual overview](Conceptual-overview) of Flywheel and then explanations on how to

* [connect securely with a Flywheel database](Connecting-and-Authentication) 
* search the database contents (containers, files, metadata, gears, analyses, jobs)
* read the metadata of files, analyses, and containers (projects, sessions, acquisitions, collections)
* download files, analyses, notes, and containers 
* upload files, analyses, and notes into containers
* start Flywheel Gears (computations) and check on its progress

This client and Flywheel are part of the Wandell lab software to support sharing data and reproducible computations. See the [Stanford Project on Scientific Transparency (PoST)](http://post.stanford.edu) for a statement of our goals.

### About the scitran Matlab client

This **scitran** client is a wrapper on the [Flywheel SDK](Flywheel-SDK) developed by Justin Ehlert. That SDK accesses the endpoints of the Flywheel API; these endpoints are how users interact with Flywheel through the browser. We wrote this client to make the code easier to understand and use.The comments in the code and the examples are designed to help people learn about the SDK and to add further functionality.

Justin exposes the same Flywheel endpoints into a [**a scitran python client**](https://github.com/scitran/python-client) and a **scitran 'R' client**.  We are unaware of wrappers for those languages, but perhaps the Matlab wrapper could offer a model.

### Flywheel documentation.

* [Flywheel API documentation](https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html)
* [Flywheel SDK Matlab examples](https://flywheel-io.github.io/core/branches/master/matlab/examples.html)
* [Flywheel manual - Command line interface](https://docs.flywheel.io/display/EM/CLI+and+SDKs)
* [Flywheel manual - About](https://docs.flywheel.io/display/EM/About+Flywheel)
* [Flywheel manual - data hierarchy](https://docs.flywheel.io/display/EM/Data+Hierarchy)

### Acknowledgement

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency](http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Justin Ehlert, Michael Perry, Gari Lerma, Zhenyi Liu, and Brian Wandell.  We thank Renzo Frigato, Nathaniel Kofalt, Megan Henning, and Jen Reiter for their contributions.
