%% s_stToolboxes
%
%  The scitran toolboxes clas is intended to help reproduciblility and
%  sharing of Matlab functions run against Flywheel sites.
%
%  Matlab functions are often based on custom toolboxes. scitran helps you
%  run a function on a Flywheel site that relies on a custom toolbox
%  located in a github repository.
%
%  The idea is this: We store a very simple JSON file on the Flywheel site
%  that defines how to get the toolboxes and test that the toolbox is
%  installed. The scitran toolbox method reads the JSON file, tests whether
%  the toolbox is installed, and if not the toolbox is downloaded and added
%  to the user's path.
%
% BW Scitran Team, 2017

%% Illustrates use of the @scitran toolbox method

% Open a scitran object
st = scitran('vistalab');

%% 

% Checks for the toolboxes and installs if necessary.
tbx = st.toolbox('aldit-toolboxes.json',...
    'project','ALDIT',...
    'install',false);

%% Alternatively, install

% Test and install.  Default method is zip download.
tbx = st.toolbox('aldit-toolboxes.json',...
    'project','ALDIT',...
    'install',true);

%% This is for a different project

% Find the toolboxes file for a
tbxFile = st.search('file', ...
    'filename','fw_Apricot6.json',...
    'project label contains','EJ Apricot');

% Checks for the toolboxes and installs if necessary.
st.toolbox(tbxFile{1},'install',false);

%%