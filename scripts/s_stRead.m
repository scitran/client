% s_stRead
%
% Test the data downloading and reading methods.
%
% This script implicitly tests the scitran.get method because we get the
% data and then read it in.  We should have some explicit get tests,
% though.
%
% BW, Scitran Team, 2017

%% Open the scitran client

st = scitran('vistalab');
fw = st.fw;

%%  Get an example nifti file

% From the VWFA project
files = st.search('file', ...
    'project label exact','VWFA',...
    'file type','nifti');

fw.downloadFileFromAcquisition(files{1}.parent.x_id,files{1}.file.name,fullfile(pwd,'foo.nii.gz');

[data, destination] = st.read(files{1},'fileType','nifti');

%%
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

[data, destination] = st.read(files{1},'fileType','mat');
delete(destination);

%% OBJ files for visualization

% This is a small fiber tract obj file
files = st.search('files',...
    'file name','Left_Thalamic_Radiation.mni.obj');

[data, destination] = st.read(files{1},'fileType','obj');
delete(destination);

%%