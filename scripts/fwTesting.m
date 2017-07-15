%% fwTesting
%
% Read a qualified BIDS hierarchy on flywheel and pull it down and create a
% BIDS directory tree.
%
% DH/BW ScitranTeam 2017

%%

chdir(fullfile(stRootPath,'local','BIDS-fw'));
st = scitran('vistalab');

%% Sessions in SOC ECoG (Hermes)
[project, sessions, acquisitions] = st.projectHierarchy('SOC ECoG (Hermes)');

%% This gets the subject code for each session
for ii=1:length(sessions)
    sessions{ii}.source.subject.code
end

%%

