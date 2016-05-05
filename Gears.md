Flywheel uses the term **Gear** to describe the process of

  * retrieving data from a scitran database,
  * selecting the analysis program and its parameters
  * executing the program to produce results
  * placing the result and parameters into the database for scientific transparency and reproducibility

Gears are usually built around programs stored in a [docker container](https://www.docker.com/what-docker).  This is a tool that Docker containers wrap the analysis program in a complete filesystem that contains everything it needs to run: code, runtime, system tools, system libraries – anything you can install on a server. This guarantees that it will always run the same, regardless of the environment it is running in.  This supports a main goal of this project:  Reproducible research.

Gears will be available within the web browser via an easy-to-use graphic interface (pulldown menus and forms to set the parameters).  There will be a Flywheel system for managing Gear execution and storing results from the web interface.  The code here shows how you can execute and manage gears from within Matlab.

### Executing a Gear

The script [**v_stEsearchDocker.m**](https://github.com/scitran/client/blob/master/matlab/validate/v_stElasticSearches.m) illustrates one simple Gear for anatomical processing (skull-stripping).  The idea is explained [in this video](https://youtu.be/eS7vRzhbpjg).  

In this example, data are retrieved from a scitran database and processed. The result are placed back in the scitran
database.

There will be many other gears for a very wide range of data processing purposes. We are building gears for (a) tractography, (b) cortical mesh visualization, (c) quality assurance, (d) tissue measurement, (e) spectroscopy, and ...

This code shows the principles of what happens behind the graphical user interface in the browser window.

This script illustrates how to interact from the command line with the scitran database using Matlab. There is also a Python interface.  Using these command line tools, you can build your own Gears.

We are committed to making our code and parameters transparent, and we are committed to helping you create and share your own Gears.  That's why we call this the project on scientific transparency!

### Building a Gear

