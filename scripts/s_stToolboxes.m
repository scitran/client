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
st = scitran('stanfordlabs');

% Read the toolboxes
tbx = st.toolboxGet('aldit-toolboxes.json',...
    'project','ALDIT');
tbxPrint(tbx)

%% See if it is in place

st.toolboxValidate(tbx);

%% Alternatively, install

tbx = toolboxes('WLVernierAcuity.json');
st.toolboxInstall(tbx,'destination',pwd);

%% Clone test
st.toolboxClone(tbx,'destination',pwd);

%% This is for a different project

% Find the toolboxes file for a
tbxFile = st.search('file', ...
    'filename','fw_Apricot6.json',...
    'project label contains','EJ Apricot');

% Checks for the toolbox requirements and validates whether or not they are
% on the path
[tbx, valid] = st.toolboxGet(tbxFile,'validate',true);

%%

