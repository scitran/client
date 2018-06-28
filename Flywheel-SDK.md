The Matlab scitran client is designed to be a clear interface to the Flywheel SDK commands.  

## Installing the SDK2 (modern stuff)

We download the SDK2 as a matlab toolbox that will be installed in the Add-Ons directory. As of April 12, 2018, Here is a link.  This might be updated over time, and we need a more automated procedure for doing the install for updates.

https://github.com/flywheel-io/core/releases/download/2.1.4/flywheel-sdk-2.1.4.mltbx

Here are the api calls

https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html

And the base wiki

https://flywheel-io.github.io/core/

## Mac/Windows

On Mac and Windows (probably) just click on the file.

## Linux

[Mathworks instructions for Linux](https://www.mathworks.com/help/matlab/ref/matlab.addons.toolbox.installtoolbox.html).  Basically, do this.

    tbxFile = 'flywheel-sdk-2.1.4.mltbx';
    tbx = matlab.addons.toolbox.installToolbox(tbxFile)

If this is the first time you are installing on Linux, a directory 'Add-Ons' will be created in your userpath directory.  You should make sure that Add-Ons is included in your path, such as

    addpath(genpath((fullfile(userpath,'Add-Ons'))));

## Programming
This page lists the Flywheel SDK commands, grouped redundantly in two organizations. First, there is a list in terms of the objects, and then there is a list in terms of the actions.

For example, all the project methods are listed, which include downloadProject.  Then the download methods are listed, which also includes downloadProject. 

The methods listed here are part of the Flywheel.m class file, which is created and attached whenever you create a scitran instance.

This is the Flywheel SDK constructor

        function obj = Flywheel(apiKey)
            % Usage Flywheel(apiKey)
            %  apiKey - API Key assigned for each user through the Flywheel UI
            %          apiKey must be in format <domain>:<API token>
            
The constructor and its methods are auto-generated for several languages (Matlab, Python, and R) as part of the Flywheel SDK.
