## The compute model
The **scitrian** and *toolboxes** classes simplify Matlab code and Flywheel data sharing; in many cases, sharing with your future self.  The software is designed for this case.  There is one or more Matlab toolboxes for the project; these toolboxes are hosted in a github repository. Your team writes functions that access the Flywheel data and use these toolboxes.

## Creating a toolbox file
The **toolboxes** class comprises methods that specify the github toolboxes and facilitate downloading and installing these toolboxes.  Information about the toolboxes is stored in a small JSON file that is an attachment on the Flywheel project page.  

For example, the Wandell lab uses the vistasoft toolbox.  The **toolbox** is specified with respect to (a) a command that can be used to test whether the toolbox is installed on the user's path (testcmd), and (b) the user and project on the github site.  This information is saved in a JSON file as follows.
```
tbx.testcmd     = 'vistaRootPath';
tbx.gitrepo.user    = 'vistalab';  % https://github.com/vistalab/vistasoft
tbx.gitrepo.project = 'vistasoft'; % https://github.com/vistalab/vistasoft
tbx.saveinfo;                      % Save the toolbox information to vistasoft.json
```
The function **stToolbox** reads the file and returns it as a toolboxes object.

    tbx = stToolbox('vistasoft.json');

Sometimes a project has multiple toolboxes.  For example, Dora Hermes wrote an ECoG toolbox which is specified in ecogBasic.json. To analyze data in her ECoG project we merge the two toolboxes into a single file
```
clear tbx
tbx(1) = stToolbox('ecogBasicCode.json');
tbx(2) = stToolbox('vistasoft.json');
tbxWrite('SOC-ECoG-toolboxes.json',tbx);
```
Multiple toolboxes are loaded, again by the **stToolbox** command.

    tbx = stToolbox('SOC-ECoG-toolboxes.json');

## Uploading the toolbox file 

The JSON file is stored on the project page with a **scitran** command 

    project = st.search('projects','project label exact','SOC ECoG (Hermes)');
    st.upload('SOC-ECoG-toolboxes.json','project',idGet(project));

Once this file is placed on the project page, **scitran** functions that analyze the Flywheel data can check whether the user has the Matlab toolboxes on their path and, if necessary, install these toolboxes for the user.
