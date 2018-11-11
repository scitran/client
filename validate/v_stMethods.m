%% Illustrate scitran class methods
%
% There are a great many other methods beyond the ones illustrated here.
% But the methods here
%
%   * search
%   * list
%   * objectParse
%   * projectHierarchy
%   * showToken
%   * browser
%   * fileRead
%   * the utility function stPrint()
%
% are a reasonable start.
%
% BW, SCITRAN Team, 2017

%%
st = scitran('stanfordlabs');

%% Browse the site
st.browser;

%% Search to count the projects
st.search('projects','summary',true);

%% Search for templates with a name
p = st.search('projects','project label contains','Template');
stPrint(p,'project','label')

%% Download hierarchy of a project

projectLabel = 'VWFA FOV';
pHierarchy = st.projectHierarchy(projectLabel);

% The acquisitions are associated with each of the sessions
nAcquisitions = 0;
for ii=1:length(pHierarchy.acquisitions)
    nAcquisitions = nAcquisitions + length(pHierarchy.acquisitions{ii});
end

fprintf('%s project\n%d sessions\n%d acquisitions\n',...
    projectLabel,length(pHierarchy.sessions),nAcquisitions);

%% List the sessions in a small project

project  = st.search('project','project label exact','VWFA');
id       = st.objectParse(project{1});
sessions = st.list('sessions',id);

stPrint(sessions,'label');

%% Show the prifvate token

token = st.showToken;
fprintf('Token: %s\n',token);

%% Read Flywheel data directly to a Matlab variable

% A nifti file from ADNI
file = st.search('files','project label exact','ADNI: T1','subject code',4256,'filetype','nifti');
nii  = st.fileRead(file{1},'fileType','nifti');

%% There are other types of file reads

%{
file = st.search('files','project label exact','showdes','subject code','E11','filetype','MATLAB data');
data = st.fileRead(file{1},'fileType','mat');

file = st.search('files','project label contains','SOC ECoG','filename','SOC-ECoG-toolboxes.json');
data = st.fileRead(file{1},'fileType','json');

file = st.search('files','collection label contains','Visualization','filename','Left_Thalamic_Radiation.mni.obj');
data = st.fileRead(file{1},'fileType','obj');
%}

%%