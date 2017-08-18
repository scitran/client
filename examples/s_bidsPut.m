%% s_bidsPut
%
% In which we take a bids data structure (e.g., s_bids.m) and start to
% create the Flywheel Project/Session/Acquisition structure and where we
% put the files
%
% The next case to check
%
%   bidsDir = fullfile(stRootPath,'local','BIDS-Examples','7t_trt');
%   b = bids(bidsDir);
%   st.bidsUpload(@bids,'project label',projectLabel);
%
%
% Wandell, Scitran Team, 2017

%% Here is an example bids data set

thisProject = 'BIDS-Test';

bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds001');
% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','7t_trt');

% Create the bids object
b = bids(bidsDir);
b.projectLabel = thisProject;

%%
st = scitran('vistalab');

% This works.  id is a cell and id{1} is an id string
% [~, id] = st.exist('VWFA FOV','projects')
%
% % And this works
% [status, gid] = st.exist('wandell', 'groups')
% [status, pid] = st.exist('VWFA FOV', 'projects', 'parentID', gid{1})

%% Create the project
%
%   b.createProject(projectName, groupName);
%

thisGroup   = 'wandell';
% [~, groupID] = st.exist(thisGroup, 'groups');
%
% if ~status, fprintf('Group not found %s\n',thisGroup);
% else,       fprintf('Group %s found\n',thisGroup);
% end

% Try running this against 'dev-flywheel.io' and see if the default group
% permissions are set correctly.
sessions = st.search('sessions','project label',thisProject);
if ~isempty(sessions)
    error('Project %s exists with sessions.',thisProject);
end

% [status, projectID] = st.exist(thisProject,'projects');
fprintf('Create the project %s\n',thisProject);
projectID = st.create(thisGroup,thisProject);
% p = st.search('projects','project id',projectID)

%% Make the sessions, acquisitions and upload the data files
%
%  b.uploadData;

% We think, for now, that we will make the sessionLabels a 1-d cell array
% that marches through the subject1.session1, subject1.session2,
% subject2.session1, ...
%
nSessions = sum(b.nSessions);   % Total number of sessions
sessionLabels = cell(nSessions,1);

% If we have no sessions, we could just do this
cntr = 1;
for ii=1:length(b.subjectFolders)
    
    nSessions = b.nSessions(ii);
    
    for ss = 1:nSessions
        
        % This is how we name a session.  We should probably save all the
        % session names in a cell array for this.
        if nSessions > 1
            thisSessionLabel = sprintf('%s-ses-%d',b.subjectFolders{ii},ss);  % **** save the sessionLabels
        else
            thisSessionLabel = sprintf('%s',b.subjectFolders{ii});  % **** save the sessionLabels
        end
        sessionLabels{cntr} = thisSessionLabel; cntr = cntr+1;
        
        fprintf('Uploading for session %s\n',thisSessionLabel);
        sessionID = st.create(thisGroup,thisProject,'session',thisSessionLabel);
        pause(2);
        session = st.search('sessions','session id',sessionID);
        
        % We can add more subject fields here
        data.subject.code = sprintf('%s',b.subjectFolders{ii});
        st.update(data,'container', session{1});
        
        % We need a counter for the sessions
        % For each subject folder find the dataFiles fields
        acqNames = fieldnames(b.dataFiles(ii).session(ss));

        for jj=1:length(acqNames)
            thisAcquisitionLabel = acqNames{jj};
            fprintf('Create acquisition %s in session %s\n',thisAcquisitionLabel,thisSessionLabel);
            acquisitionID = st.create(thisGroup,thisProject,...
                'session',thisSessionLabel,...
                'acquisition',thisAcquisitionLabel);
            pause(2);
            
            % Upload the data files
            nFiles = length(b.dataFiles(ii).session(ss).(thisAcquisitionLabel));
            acquisition = st.search('acquisitions','acquisition id',acquisitionID);
            
            fprintf('Subject %d. Session %d.  Uploading %d files',ii,ss,nFiles);
            for kk=1:nFiles
                fname = fullfile(b.directory,b.dataFiles(ii).session(ss).(thisAcquisitionLabel){kk});
                st.put(fname,acquisition);
            end
        end
        fprintf('Done uploading session %s.\n',session{1}.source.label);
    end
end

%% Upload the PROJECT metadata
%
% b.uploadMetadata(varargin)
%

% Put the meta data into the Project tab as an attachment
if ~isempty(b.projectMeta)
    project = st.search('projects','project label',thisProject);
    for ii=1:length(b.projectMeta)
        localName  = fullfile(b.directory,b.projectMeta{ii});
        st.put(localName,project);
    end
end

%% Upload the SESSION meta data into the anotation tab as an attachment.

cntr = 1;
project = st.search('projects','project label',thisProject);
for ii=1:length(b.subjectFolders)
    for ss = 1:b.nSessions(ii)
        session = st.search('sessions','session label',sessionLabels{cntr},'project label',thisProject);
        theseFiles = b.sessionMeta{ii,ss};
        fprintf('Uploading %d files to %s\n',length(theseFiles),session{1}.source.label);
        for ff = 1:length(theseFiles)
            localName = fullfile(b.directory,theseFiles{ff});
            st.put(localName,session);            
        end
        cntr = cntr+1;
    end
end

%% Upload the subject meta data
% project = st.search('projects','project label',thisProject);

for ii=1:length(b.subjectMeta)
    theseFiles = b.subjectMeta{ii};
    for ff = 1:length(theseFiles)
        localName = fullfile(b.directory,theseFiles{ff});
        [~,name,ext] = fileparts(theseFiles{ff});
        remoteName = ['bids@',name,ext];
        copyfile(localName,remoteName)
        st.put(remoteName,project);
    end
end

% Put the bids object up on the site to help us when we download


%%
% [p,s,a] = st.projectHierarchy(thisProject);

%
% st.deleteProject(thisProject);

%%

