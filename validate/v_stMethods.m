%% Illustrate scitran class methods
%
%  BW, SCITRAN Team, 2017

%%
st = scitran('stanfordlabs');

%% Browse the site
st.browser;

%% Search to count the projects
st.search('projects','summary',true);

%% Search for templates with a name

p = st.search('projects','project label contains','Template');
for ii=1:length(p)
    p{ii}.source.label
end

%% Exact match to project label
projectLabel = 'VWFA FOV';
[project, sessions, acquisitions] = st.projectHierarchy(projectLabel);

% The acquisitions are associated with each of the sessions
nAcquisitions = 0;
for ii=1:length(sessions)
    nAcquisitions = nAcquisitions + length(acquisitions{ii});
end

fprintf('%s project\n%d sessions\n%d acquisitions\n',...
    projectLabel,length(sessions),nAcquisitions);

%% Show the prifvate token

token = st.showToken;
fprintf('Token: %s\n',token);

%% Read Flywheel data directly to a Matlab variable

% A nifti file from ADNI
file = st.search('files','project label','ADNI: T1','subject code',4256,'filetype','nifti');
nii = st.read(file{1},'fileType','nifti');

% A Matlab file from showdes
file = st.search('files','project label','showdes','subject code','E11','filetype','matlab');
data = st.read(file{1},'fileType','mat');

file = st.search('files','project label contains','SOC ECoG','filename','toolboxes.json');
data = st.read(file{1},'fileType','json');

file = st.search('files','collection label contains','Visualization','filename','Left_Thalamic_Radiation.mni.obj');
data = st.read(file{1},'fileType','obj');

%% TODO:  exist, create*, delete*, docker, get*

%%