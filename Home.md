The **scitran client** repository allows users to use Matlab to interact with the a scitran database. The main use at this point in time is to interact with the [Flywheel](https://flywheel.io) data and computational management system.

This wiki page describes the general software and provides many examples, such as how to

* obtain authorization to read/write from a Flywheel database
* search the database
* download database objects (e.g., files, sessions, projects, analyses)
* upload results (e.g., files, graphs, other attachments)
* upload method descriptions (e.g., analyses, Gears)
* Write and store programs on the Flywheel database so that others can check your work 

The **scitran client** can be run securely from any computer on the Internet to process data stored in a scitran database either using their local computer or from a larger computational resource such as a compute engine on the cloud.

The key elements that supports **reproducible research** are these
  * The original files are securely stored in a database
  * The analysis methods are implemented reproducibly (using [Gears](https://github.com/scitran/client/wiki/Gears)), and 
  * The results and analysis specification are stored back in the database. 

The **scitran client** has a related implementation in Python.

See the [scitran core wiki page](https://github.com/scitran/core/wiki) for an introduction to scientific transparency data management software and the Stanford [Project on Scientific Transparency (PoST)](http://post.stanford.edu). 

The Wandell lab gratefully acknowledge the [Simons Foundation](https://www.simonsfoundation.org/) and particularly the [Simons Foundation Autism Research Initiative](https://sfari.org/) for their support of the [Project on Scientific Transparency] (http://post.stanford.edu).  The code in this repository and the api functionality are being developed by Michael Perry, Renzo Frigato, and Brian Wandell.
