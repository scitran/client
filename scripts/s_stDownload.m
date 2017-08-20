%% s_stDownload
%
% Test downloading a small project, a session, an acquisition, and a
% collection.
%
% Not quite right yet, but close.  Deal with file naming.
%
% BW Scitran Team, 2017

%%
st = scitran('vistalab');

curDir = pwd;
chdir(fullfile(stRootPath,'local'));

%% Test whole project

project = st.search('projects','project label','Templates Macaque');
st.download('project',project{1}.id,'destination','MacaqueTemplate.tar');

%% Test session

session = st.search('sessions','project label','Templates Macaque','session label','D99 Macaque Atlas');
st.download('session',session{1}.id,'destination','MacaqueSession.tar');

%% Test acquisition

acquisition = st.search('acquisitions','project label','Templates Macaque','acquisition label','example');
destination = st.download('acquisition',acquisition{1}.id,'destination','MacaqueAcquisition.tar');
fprintf('Acquisition stored in %s\n',destination);

%%
chdir(curDir);

%%