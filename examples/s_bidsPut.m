%% s_bidsPut
%
% In which we take a bids data structure (e.g., s_bids.m) and start to
% create the Flywheel Project/Session/Acquisition structure and where we
% put the files
%
%

%%
st = scitran('vistalab');

% This works.  id is a cell and id{1} is an id string
% [~, id] = st.exist('VWFA FOV','projects')
% 
% % And this works
% [status, gid] = st.exist('wandell', 'groups')
% [status, pid] = st.exist('VWFA FOV', 'projects', 'parentID', gid{1})

%%
thisGroup   = 'wandell';
[status, groupID] = st.exist(thisGroup, 'groups');
if ~status
        fprintf('Group not found %s',thisGroup);
end

%%
thisProject = 'BIDS-Test';
[status, id] = st.exist(thisProject,'projects');
if ~status
    fprintf('Create the project %s\n',thisProject);
    id = st.create(thisGroup,thisProject);
end

    
    