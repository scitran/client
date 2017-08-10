%% Test the toolbox code
%
% v_stToolbox
%
%
% BW Scitran Team, 2017

% If you a json file defining the directory, you can just read it
%
%   tbx = toolboxes('file','WLVernierAcuity.json');
% 
% Or, 
%
%   tbx = toolboxes;
%   tbx.read('WLVernierAcuity.json');
%   
% Or 

%% Set up a scitran client
st = scitran('vistalab');

%% Make a json file that represents a small github repository

% Create the toolbox and define its parameters
tbx = toolboxes;
tbx.testcmd      = 'dtiError';
tbx.gitrepo.user    = 'scitran-apps'; 
tbx.gitrepo.project = 'dti-error'; 

% Save it in the local directory
chdir(fullfile(stRootPath,'local'));
tbxName = tbx.saveinfo;

%% Read the toolbox back in

% Create a fresh, empty toolbox
tbx = toolboxes;
tbx.read(tbxName);

%% Test the clone method
chdir(fullfile(stRootPath,'local'));
tbxDir = tbx.clone;

%%
fprintf('Removing the dtiError directory %s',tbxDir);
rmdir(tbxDir,'s');

%% Place the toolbox we created on the remote site.
project = st.search('projects','project label','DEMO');
st.put(tbxName,project);
[~,baseName,ext] = fileparts(tbxName);
fname = [baseName,ext];

%% Place the 
% There should be a standard toolbox.  Or maybe we should always put it up
% so we know it is there.  For now, we happen to know there is one
tbxFile = st.search('files','project label','DEMO','filename',fname);
tbx = toolboxes('scitran',st,'file',tbxFile{1});
tbxDir = tbx.install;

%% 
disp('Deleting the directory');
rmdir(tbxDir,'s');

%% Read a local file and download a shallow clone

tbxDir = tbx.clone('cloneDepth',1);
rmdir(tbxDir,'s');

%% Or a particular commit as a zip file
tbx.gitrepo.commit = '0b944082e0c850e568ed46d1ad001fcb2bc658b7';
tbxDir = tbx.install;

%% A simple method using only the scitran client object.
tbxFile = st.search('files',...
    'project label','SOC ECoG (Hermes)',...
    'file name','toolboxes.json');

%%