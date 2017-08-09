%% Test the toolbox code
%
% v_stToolbox
%
%
% BW Scitran Team, 2017

%% Set up a scitran client
st = scitran('vistalab');

%% Make a json file and download the github repository

% Clone it and remove it

% Download a zip version and then remove it

%% Find a toolbox on the remote site.

% There should be a standard toolbox.  Or maybe we should always put it up
% so we know it is there.  For now, we happen to know there is one
tbxFile = st.search('files','project label','SOC ECoG (Hermes)','filename','toolboxes.json');
tbx = toolboxes('scitran',st,'file',tbxFile{1});
tbx.install;

%% Read a local file and download a shallow clone

% Does not work yet.  File not there.
tbx = toolboxes('file','WLVernierAcuity.json');
tbx.clone('cloneDepth',1);

%% Or a particular commit as a zip file
tbx.gitrepo.commit = '5a84c98e969633de853a470c9fa631ef8468b21d';
tbx.install;

%% A simple method using only the scitran client object.
tbxFile = st.search('files',...
    'project label','SOC ECoG (Hermes)',...
    'file name','toolboxes.json');

%%