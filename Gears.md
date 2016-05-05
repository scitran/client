## The Gear Concept

Flywheel uses the term 'Gear' to describe the process of

  * retrieving data from a scitran database,
  * selecting the parameters, 
  * analyzing the data with a program stored in a docker container, and
  * placing the result and parameters into the database for scientific transparency and reproducibility

The script **v_stEsearchDocker.m** illustrates one simple Gear for anatomical processing (skull-stripping).  The idea is explained [in this video](https://youtu.be/eS7vRzhbpjg).  

In this example, we execute a docker container built
% to run the FSL brain extraction tool (bet2). Data are retrieved from a
% scitran database and processed. The result are placed back in the scitran
% database.
%
% There will be many other gears for a very wide range of data processing
% purposes. We are building gears for (a) tractography, (b) cortical mesh
% visualization, (c) quality assurance, (d) tissue measurement, (e)
% spectroscopy, and ...
%
% Operating Gears will be possible from within the web browser via an
% easy-to-use graphic interface (pulldown menus and forms to set the
% parameters).
%
% This code shows the principles of what happens behind the graphical user
% interface in the browser window.
%
% This script illustrates how to interact from the command line with the
% scitran database using Matlab. There is also a Python interface.  Using
% these command line tools, you can build your own Gears.
%
% We are committed to making our code and parameters transparent, and we
% are committed to helping you create and share your own Gears.  That's
% why we call this the project on scientific transparency!
%
## Executing a Gear