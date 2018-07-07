%% s_stFileRead
%
% Test data downloading and reading methods. 
%
% TODO:  More file types should be recognized and read.
%
% BW, Scitran Team, 2017

%% Open the scitran client

st = scitran('stanfordlabs');

%%  Get an example nifti file from the VWFA project
files = st.search('file', ...
    'project label exact','VWFA',...
    'file type','nifti',...
    'summary',true);

[data, destination] = st.fileRead(files{1});
niftiView(data);
delete(destination);

%% Matlab data

% From the showdes (logothetis) project
files = st.search('files',...
    'project label contains','showdes', ...
    'file name','e11au1_roidef.mat');
stPrint(files,'file','name');

[data, destination] = st.fileRead(files{1}); %#ok<*ASGLU>
delete(destination);

%% OBJ files for visualization

% This is a small fiber tract obj file
% Make this work when we have analysisFile running
%{
files = st.search('files',...
    'file name','lh.white.obj',...
    'summary',true);

data = st.analysisFile(files{1},'save',false); %#ok<*NASGU>
%}
%% Return JSON file as a struct

file = st.search('file',...
      'project label contains','SOC', ...
      'filename','SOC-ECoG-toolboxes.json',...
      'summary',true);
data = st.fileRead(file{1});

%%