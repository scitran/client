The **scitran matlab client** provides tools so that Matlab users can interact with a [Flywheel system](https://flywheel.io). The client searches, lists, reads and analyzes data.  It is also capable of setting up analyses. 

The **scitran matlab client** can be run securely from any computer on the Internet. We have used the client extensively on Mac and Linux systems.  We have not tested extensively on Windows systems yet, but at least it seems to run.

This wiki describes the software and provides examples including how to

* obtain authorization to interact with a Flywheel database
* search the database for its contents
* get information about the database contents
* download or read database objects (e.g., files, sessions, projects, analyses)
* upload files to the database (e.g., files, graphs, other attachments)
* upload method descriptions (e.g., analyses, Gears) and programs (e.g., Matlab files) that others can run
* paper of the future (pof) efforts


### Related information

This client is based on the [Flywheel SDK](Flywheel-SDK) that is platform independent, and written in [Golang](https://golang.org/).  The functions in the Flywheel SDK are exported into a library that is called from Matlab. You have direct access to the Flywheel SDK calls from the scitran objects.

The same Flywheel SDK is also exported into libraries for [**a scitran python client**](https://github.com/scitran/python-client) and a **scitran** 'R' client.

See the [scitran core data model page](https://github.com/scitran/core/wiki/Data-Model) for an introduction to scientific transparency data management software and the Stanford [Project on Scientific Transparency (PoST)](http://post.stanford.edu). 

### Acknowledgement

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency](http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Michael Perry and Brian Wandell.  We thank Renzo Frigato for his contributions.
