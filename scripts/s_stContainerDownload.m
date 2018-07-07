%% s_stContainerDownload
%
% Flywheel has a hierarchy of data containers. The container files can
% be downloaded into a local tar-file using
% scitran.containerDownload().  This script illustrates how to do
% that.
%
% The containers are
%   Project, Session, Acquisition, Collection
%
% Files are treated separately. 
% Analyses are treated separatelky.
%
% BW, Vistasoft Team, 2017
%
% See also
%   s_stFileDownload

%% Open up the scitran object

st = scitran('stanfordlabs');
st.verify;

chdir(fullfile(stRootPath,'local'));

%% Projects can be annoyingly big.  Be careful if youi want to test that

%{
 % This runs, but it is big.  So I commented it out.
 project = st.search('project',...
    'project label exact', 'Brain Beats',...
    'summary',true);
 st.containerDownload('project',idGet(project{1},'project'))
%}

%% Download a session

session = st.search('session',...
    'project label exact', 'Brain Beats',...
    'session label exact','20180319_1232', ...
    'summary',true);

stPrint(session,'session','label');

% Readable way to get the analysis is
id = idGet(session{1},'session');

tarFileName1 = st.containerDownload('session',id);
untar(tarFileName1);

%% Download an acquisition

acquisition = st.search('acquisition',...
    'project label contains','SOC',...
    'session label exact','stimuli');
id = idGet(acquisition{1},'acquisition');
tarFileName2 = st.containerDownload('acquisition',id);
untar(tarFileName2);

%%
delete(tarFileName1);
delete(tarFileName2);
fprintf('You should delete the directory\n');

%%
