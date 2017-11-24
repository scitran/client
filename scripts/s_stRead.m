%% s_stRead
% Test data downloading and reading methods.
%
% This script implicitly tests the scitran.download method because we
% download the data and read it in.  We should have some explicit download
% tests, though.
%
% BW, Scitran Team, 2017

%% Open the scitran client

st = scitran('vistalab');

%%  Get an example nifti file from the VWFA project
files = st.search('file', ...
    'project label exact','VWFA',...
    'file type','nifti');

[data, destination] = st.read(files{1});
niftiView(data);
delete(destination);

% if ismac
%    % There is an mriCro app for Mac and we could use that for some
%    % glamorous visualization of the NIFTI data.
%    % https://itunes.apple.com/us/app/mricro/id942363246?ls=1&mt=12
% end

%% Matlab data

% From the showdes (logothetis) project
files = st.search('files',...
    'project label contains','showdes', ...
    'file name','e11au1_roidef.mat');

[data, destination] = st.read(files{1}); %#ok<*ASGLU>
delete(destination);

%% OBJ files for visualization

% This is a small fiber tract obj file
files = st.search('files',...
    'file name','Left_Thalamic_Radiation.mni.obj');

data = st.read(files{1},'save',false); %#ok<*NASGU>

%% Return JSON file as a struct

file = st.search('file',...
    'project label contains','SOC',...
    'filename','toolboxes.json');
data = st.read(file{1},'save',false);

%%