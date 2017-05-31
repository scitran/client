%% s_stToolboxes
%
%  We store a JSON file on the scitran site that defines which Matlab
%  toolboxes need to be installed on the path, say to run the scripts in a
%  project.  The scitran object can then download and install these
%  toolboxes.
%
%  The purpose is to help reproduciblility of the scripts and the ability
%  to run them at other sites.
%
% BW Scitran Team, 2017

%% Illustrates use of scitran toolboxes function

st = scitran('action', 'create', 'instance', 'scitran');

tbxFile = st.search('files',...
    'project label contains','Diffusion Noise',...
    'file name','toolboxes.json');

% Get the tbx, but don't install
tbx = st.toolbox(tbxFile{1},'install',false);

tbx.install;

% Default is install=true
tbx = st.toolbox(tbxFile{1});

%%
