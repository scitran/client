Flywheel helps you share Matlab functions reproducibly with colleagues. In many cases, you will be sharing the function with your future self. 

The **toolboxes** class is an important component, that works with the scitran class, to implement this reproducible computing.  The idea is to write a Matlab function that uses **scitran** to access Flywheel data, and uses **toolboxes** to download Matlab libraries from github that are needed to run these functions.

There are two steps in using toolboxes.  First, create an FTM file and upload it to the project page. Second, include a call to the **scitran** toolbox method that reads this toolbox file and checks that the user has the toolboxes installed on their path. If the toolboxes are not found, the **scitran** toolbox method will try to do the install.

FTM is useful for custom software and software development. Flywheel uses the Gears concept, docker containers packaged with a manifest that allows you to control the parameter setting, for executing standard tools. The Gears system also includes job control for scheduling and logging jobs. Flywheel is well on its way towards implementing an elastic cloud system using distributed storage and kubernetes (k8s).
