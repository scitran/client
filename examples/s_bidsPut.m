%% s_bidsPut
%
% In which we take a bids data structure (e.g., s_bids.m) and start to
% create the Flywheel Project/Session/Acquisition structure and where we
% put the files
%
%
%
% %If needed
% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','7t_trt');
% b = bids(bidsDir);
%
% Wandell, Scitran Team, 2017

%% Here is an example bids data set

bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds001');

% Create the bids object
b = bids(bidsDir);

%%
st = scitran('vistalab');

% This works.  id is a cell and id{1} is an id string
% [~, id] = st.exist('VWFA FOV','projects')
% 
% % And this works
% [status, gid] = st.exist('wandell', 'groups')
% [status, pid] = st.exist('VWFA FOV', 'projects', 'parentID', gid{1})

%%  Validate the group

thisGroup   = 'wandell';
[status, groupID] = st.exist(thisGroup, 'groups');

if ~status, fprintf('Group not found %s\n',thisGroup);
else,       fprintf('Group %s found\n',thisGroup);
end

%% Create the project

thisProject = 'BIDS-Test';
[status, projectID] = st.exist(thisProject,'projects');
if ~status
    fprintf('Create the project %s\n',thisProject);
    projectID = st.create(thisGroup,thisProject);
else
    fprintf('Project %s exists\n',thisProject);
end

%% Make the session

% If we have no sessions, we could just do this
for ii=1:length(b.subjectFolders)
    
    % This is how we put a session.  
    thisSessionLabel = b.subjectFolders{ii};
    [status, sessionID] = st.exist(thisSessionLabel,'sessions','parentID',projectID);
    if ~status
        fprintf('Create the project %s\n',thisProject);
        sessionID = st.create(thisGroup,thisProject,'session',thisSessionLabel);
    else
        fprintf('Session %s exists\n',thisSessionLabel);
    end
    
    % For each subject folder find the subjectData fields
    acqNames = fieldnames(b.subjectData(ii).session);
    for jj=1:length(acqNames)
        thisAcquisitionLabel = acqNames{jj};
        [status, acquisitionID] = st.exist(thisAcquisitionLabel,'acquisitions','parentID',sessionID);
        if ~status
            fprintf('Create the acquisition %s\n',thisAcquisitionLabel);
            acquisitionID = st.create(thisGroup,thisProject,'session',thisSessionLabel,'acquisition',thisAcquisitionLabel);
        else
            fprintf('Acquisition %s exists\n',thisAcquisitionLabel);
        end
    end
end


%% Make the acquistion

% thisAcquisitionLabel = 'anat';
% [status, acquisitionID] = st.exist(thisAcquisitionLabel,'acquisitions','parentID',sessionID);
% if ~status
%     fprintf('Create the acquisition %s\n',thisAcquisitionLabel);
%     acquisitionID = st.create(thisGroup,thisProject,'session',thisSessionLabel,'acquisition',thisAcquisitionLabel);
% else
%     fprintf('Acquisition %s exists\n',thisAcquisitionLabel);
% end

%%

%%
[p,s,a] = st.projectHierarchy(thisProject);

%%
st.deleteProject(thisProject);

    
    