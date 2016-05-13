Flywheel uses the term **Gear** to describe the process of

  * identifying scitran input files
  * selecting the analysis program and its parameters
  * executing the program to produce output files
  * placing the analysis information (inputs, analysis, outputs) into the database

The intention of the Gear is to be complete and provide for scientific transparency and reproducibility.

The methods used in Gears are usually built around programs stored in a [docker container](https://www.docker.com/what-docker).  The Docker container wraps the analysis program and its parameters in a complete filesystem that contains everything it needs to run: code, runtime, system tools, system libraries – anything you can install on a server. This guarantees that it will always run the same, regardless of the environment it is running in.  This supports the main goal of the scitran project:  Reproducible research.

The code here shows how you can execute and manage gears from within Matlab. Shortly, **Gears** will be available for execution from the web browser (pulldown menus and forms to set the parameters).  Flywheel engineers are implementing a system for managing Gear execution, storing results, and searching through about Gear usage and properties.

### Executing a Gear

The script [**s_stDocker.m**]() illustrates one simple Gear for anatomical processing (skull-stripping).

In this example, data are retrieved from a scitran database and processed. The result are placed back in the scitran
database.

There will be many other gears for a very wide range of data processing purposes. We are building gears for (a) tractography, (b) cortical mesh visualization, (c) quality assurance, (d) tissue measurement, (e) spectroscopy, and ...

This code shows the principles of what happens behind the graphical user interface in the browser window.

This script illustrates how to interact from the command line with the scitran database using Matlab. There is also a Python interface.  Using these command line tools, you can build your own Gears.

We are committed to making our code and parameters transparent, and we are committed to helping you create and share your own Gears.  That's why we call this the project on scientific transparency!

### Building a Gear

