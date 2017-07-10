%% fwTesting
%
% Trying to read similar structures from the hierarchy on flywheel to use
% for BIDS directory creations.
%
% DH/BW ScitranTeam 2017

%%

chdir(fullfile(stRootPath,'local','BIDS-fw'));
st = scitran('vistalab');

%% Sessions in SOC ECoG (Hermes)
[project, sessions, acquisitions] = st.projectHierarchy('SOC ECoG (Hermes)');

% This gets the subject code for each session
for ii=1:length(sessions)
    sessions{ii}.source.subject.code
end

%%

