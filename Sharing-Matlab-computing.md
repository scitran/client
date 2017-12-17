The **scitrian matlab client** simplifies coding sharing of Matlab functions and toolboxes. In many cases, you will be sharing the function with your future self.  The **toolboxes** and **scitran** classes support this sharing and reproducible computing.  

## The compute model
You have written a Matlab toolbox for your project, myToolbox, and you keep your toolbox in a github repository. You and your collaborators write functions that access the Flywheel data and rely on the toolbox.  

## The toolboxes definition
First, you specify the github toolboxes. We do this by creating a small JSON file that is added as an attachment to the Flywheel project page.  As an example, the Wandell lab uses the vistasoft toolbox.  To specify the toolbox we identify a command that can be used to test whether the toolbox is installed on the user's path (testcmd) and we specify the user and project on the github site.  We then save this information to a file.
```
tbx.testcmd     = 'vistaRootPath';
tbx.gitrepo.user    = 'vistalab';  % https://github.com/vistalab/vistasoft
tbx.gitrepo.project = 'vistasoft'; % https://github.com/vistalab/vistasoft
tbx.saveinfo;                      % Save the toolbox information to vistasoft.json
```
You can read this toolbox with the command

    tbx = stToolbox('vistasoft.json');

Using a similar method, Dora Hermes wrote a toolbox, ecogBasic.json, for ECoG data that is necessary for this example. We can merge the two toolboxes into a single file
```
clear tbx
tbx(1) = stToolbox('ecogBasicCode.json');
tbx(2) = stToolbox('vistasoft.json');
tbxWrite('SOC-ECoG-toolboxes.json',tbx);
```
We load multiple toolboxes using the parameters in the merged file

    tbx = stToolbox('SOC-ECoG-toolboxes.json');

## Is the toolbox on your path?

You can test for the toolbox by running

    tbx(1).test

## Running the function
