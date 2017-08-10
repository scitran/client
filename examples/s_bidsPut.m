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
%
thisGroup   = 'wandell';
[status, groupID] = st.exist(thisGroup, 'groups');

if ~status, fprintf('Group not found %s\n',thisGroup);
else,       fprintf('Group %s found\n',thisGroup);
end

%% Create the project
%
% Try running this against 'dev-flywheel.io' and see if the default group
% permissions are set correctly.

thisProject = 'BIDS-Test';
[status, projectID] = st.exist(thisProject,'projects');
if ~status
    fprintf('Create the project %s\n',thisProject);
    projectID = st.create(thisGroup,thisProject);
else
    fprintf('Project %s exists\n',thisProject);
end

%% Make the sessions, acquisitions and upload the data files

% If we have no sessions, we could just do this
for ii=1:length(b.subjectFolders)
    % This is how we put a session.
    thisSessionLabel = b.subjectFolders{ii};
    fprintf('Uploading for subject %s\n',thisSessionLabel);
    sessionID = st.create(thisGroup,thisProject,'session',thisSessionLabel);
    pause(2);
    session = st.search('sessions','session id',sessionID);
    
    % We can add more subject fields here
    data.subject.code = thisSessionLabel;
    st.update(data,'container', session{1});
    
    if b.nSessions(ii) == 0
        % For each subject folder find the subjectData fields
        acqNames = fieldnames(b.subjectData(ii).session);
        for jj=1:length(acqNames)
            thisAcquisitionLabel = acqNames{jj};
            fprintf('Create acquisition %s in session %s\n',thisAcquisitionLabel,thisSessionLabel);
            acquisitionID = st.create(thisGroup,thisProject,'session',thisSessionLabel,'acquisition',thisAcquisitionLabel);
            pause(2);
            
            % Upload the data files
            nFiles = length(b.subjectData(ii).session.(thisAcquisitionLabel));
            acquisition = st.search('acquisitions','acquisition id',acquisitionID);
            if ii== 1
                % Only for the first subject, upload some files
                fprintf('Subject %d.  Uploading %d files',ii,nFiles);
                for kk=1:nFiles
                    fname = fullfile(b.directory,b.subjectData(ii).session.(thisAcquisitionLabel){kk});
                    st.put(fname,acquisition);
                end
                fprintf('Done with file upload\n');
            end
            % Label the files at some point with a measurement type.
            %    switch (thisAcquistionLabel)
            %       case 'anat'
            %         d.measurement = 'anatomy'
            %       case 'func'
            %         d.measurement = 'functional';
            %       otherwise
            %         d.measurement = 'unknown'
            %     end
            %  st.update(d,'containerid', acquisitionID,'container',acquisition{1});
            % 
        end
    end
end

%% Upload the metadata


%% How to set with default group permission
% # Create a project (with default group permissions)
% curl -X POST -H "Content-Type: application/json" -H "Authorization: scitran-user <your_API_key>" -d '{
%     "label": "your new project",
%         "group": "scitran"
% }' "https://docker.local.flywheel.io:8443/api/projects"

%% How to set the subject code

% Scitran data model V2
% https://github.com/scitran/core/wiki/Data-Model

% This is handled in the @scitran.update method
%
% # Set the subject code
% curl -X PUT -H "Content-Type: application/json" -H "Authorization: scitran-user <your_API_key>" -d '{
%     "subject": {
%         "code": "the subject code"
%     }
% }' "https://docker.local.flywheel.io:8443/api/sessions/<session_id>"

%%
% 
% thisSessionLabel = b.subjectFolders{ii};
% fprintf('Uploading for subject %s\n',thisSessionLabel);
% % [status, sessionID] = st.exist(thisSessionLabel,'sessions','parentID',projectID);
% if ~status
%     fprintf('Creating session <%s>\n',thisSessionLabel);
%     sessionID = st.create(thisGroup,thisProject,'session',thisSessionLabel);
% elseif length(status) > 1
%     fprintf('Multiple sessions with the label <%s> found\n',thisSessionLabel);
%     for kk=1:status
%         sessionList = st.search('sessions','session id',sessionID{kk});
%         sessionList{1}.source.project
%     end
% else
%     fprintf('Session <%s> exists\n',thisSessionLabel);
% end
    
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


