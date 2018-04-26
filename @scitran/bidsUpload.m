function projectID = bidsUpload(st,bidsData, groupLabel, varargin)
%Upload a BIDS compliant directory to a Flywheel site
%
% Syntax
%   projectID = st.bidsUpload
% 
% Description
%  Transfer a bids compliant directory on your local site to a Flywheel
%  project.  The metadata files for the project and session are transferred
%  as attachments to the project or relevant session.
%
%  At this time, the subject data are added to the project file.  In the
%  future, the subject data will be placed in a subject page that will be
%  visible in the UI.  Not done yet.
%
% Inputs (required)
%   bidsData   - an @bids object
%   groupLabel - Your group label so that you have permission to create the
%                project
%
% Inputs (optional)
%   projectLabel - a string to name the project.  Default is
%                  bidsData.projectLabel
%
% See also: s_bidsPut.m
%
% Example in code
%
% BW/DH Scitran Team, 2017

% Example
%{
 % Works for wandell arrangement.
 st = scitran('stanfordlabs');
 data = bids(fullfile(stRootPath,'local','BIDS-examples','fw_test'));
 groupLabel = 'Wandell Lab'; 

 % One way to name the project
 data.projectLabel = 'BIDSUp';  
 project = st.bidsUpload(data,groupLabel);

 % Delete upload when done testing
 [s,id] = st.exist('project',data.projectLabel);
 if s, st.deleteContainer('project',id); end
%}
%{
 % Another way to name the project
 project = st.bidsUpload(data,groupLabel,'project label','BIDS-Test');

 % Delete upload when done testing
 [s,id] = st.exist('project','BIDS-Test');
 if s, st.deleteContainer('project',id); end
%}

%% Parse inputs

% Check the bids data structure and determine the project label.
p = inputParser;
p.addRequired('bidsData',@(x)(isa(x,'bids')));
p.addRequired('groupLabel',@ischar);

varargin = stParamFormat(varargin);
p.addParameter('projectlabel','',@ischar);

p.parse(bidsData,groupLabel,varargin{:});

%% Handle project label

% If no project label is sent in, then use the project label in the
% bidsData structure.
projectLabel = p.Results.projectlabel;
if isempty(projectLabel)
    if isfield(bidsData,'projectLabel')
        projectLabel = bidsData.projectLabel;
    else
        error('Project label field required');
    end
end

%% Check that the specified group exists

if ~(st.exist('group',groupLabel))
    error('No group label %s\n',groupLabel);
end

%%  Create the project

% Check if the project already exists.  If it does, throw an error
% Otherwise, create it.
[status, projectID] = st.exist('project',projectLabel);
if ~status
    id = st.create(groupLabel,projectLabel);
    projectID = id.project;
    fprintf('Created project %s (id %s).\n',projectLabel,projectID);
else
    error('Project %s exists (id %s).\n',projectLabel,projectID);
end

%% Make the sessions and acquisitions. Upload the data files.

% The sessions will be labeled sub-N_ses-M
nSessions = sum(bidsData.nSessions);   % Total number of sessions
sessionLabels = cell(nSessions,1);

cntr = 1;   % Count the number of sessions we are creating.
for ii=1:length(bidsData.subjectFolders)
    
    % How many sessions for this subject
    nSessions = bidsData.nSessions(ii);
    
    for ss = 1:nSessions
        
        % Even if there is only one session for the subject, label it.
        thisSessionLabel = sprintf('%s-ses-%d',bidsData.subjectFolders{ii},ss);  % **** save the sessionLabels
        
        sessionLabels{cntr} = thisSessionLabel; cntr = cntr+1;
        
        fprintf('Uploading session %s.\n',thisSessionLabel);
        id = st.create(groupLabel,projectLabel,'session',thisSessionLabel);
        
        % We can add more subject fields here.  The update method can fill
        % in various database fields. Probably these should be filled in by
        % a separate function.
        data.subject.code = sprintf('%s',bidsData.subjectFolders{ii});
        st.setContainerInfo('session',id.session,data);
        
        % For each subject folder find the dataFiles fields
        acqNames = fieldnames(bidsData.dataFiles(ii).session(ss));

        for jj=1:length(acqNames)
            thisAcquisitionLabel = acqNames{jj};
            fprintf('Create acquisition %s in session %s\n',thisAcquisitionLabel,thisSessionLabel);
            id = st.create(groupLabel,projectLabel,...
                'session',thisSessionLabel,...
                'acquisition',thisAcquisitionLabel);
            
            % Upload the data files
            nFiles = length(bidsData.dataFiles(ii).session(ss).(thisAcquisitionLabel));
            acquisitionID = idGet(st.getContainerInfo('acquisition',id.acquisition));
            
            if nFiles > 0
                fprintf('Uploading %d files.\n',nFiles);
                for kk=1:nFiles
                    fname = fullfile(bidsData.directory,...
                        bidsData.dataFiles(ii).session(ss).(thisAcquisitionLabel){kk});
                    st.upload(fname,'acquisition',acquisitionID);
                end
            end
        end
        fprintf('Done uploading session %s.\n',thisSessionLabel);
    end
end

%% Upload the PROJECT metadata - prepending bids@

% Put the meta data into the Project tab as an attachment
fprintf('Uploading project metadata\n');
if ~isempty(bidsData.projectMeta)
    for ii=1:length(bidsData.projectMeta)
        localName  = fullfile(bidsData.directory,bidsData.projectMeta{ii});
        [~,name,ext] = fileparts(bidsData.projectMeta{ii});
        remoteName   = ['bids@',name,ext];
        st.upload(localName,'project',projectID,...
            'remote name',remoteName);
    end
end

%% Upload the SESSION meta data - prepending bids@

fprintf('Uploading session metadata\n');

% Find the sessions in this project
sessions = st.list('session',projectID);
nSessions = numel(sessions);

% For each session
for ii=1:nSessions
    for jj=1:length(sessionLabels)
        % Find the bids sessionLabel that matches
        if strcmp(sessions{ii}.label,sessionLabels{jj})
            labels = split(sessionLabels{jj},'-');
            whichSubject = uint8(str2double(labels{2}));  % Skip sub-
            whichSession = uint8(str2double(labels{4}));  % Skip ses-
            
            % Upload these files.  sessionMeta is participant x session.
            % So, we have to figure out the subject from the session label.
            theseFiles = bidsData.sessionMeta{whichSubject,whichSession};
            fprintf('Uploading %d file(s) to %s\n',length(theseFiles),sessions{ii}.label);
            for ff = 1:length(theseFiles)
                localName    = fullfile(bidsData.directory,theseFiles{ff});
                [~,name,ext] = fileparts(theseFiles{ff});
                remoteName   = ['bids@',name,ext];
                st.upload(localName,'session',sessions{ii}.id,...
                    'remote name',remoteName);
            end
            break;  % On to the next session.
        end
    end
end

%% Upload the subject meta data - prepending bids@  

% We attach the subject metadata files to the project.  
%
% In the future, we will attach them with a slightly different name to the
% subject slot.  That will happen when the subject becomes visible in the
% UI.
fprintf('Uploading subject metadata\n');
for ii=1:length(bidsData.subjectMeta)
    theseFiles = bidsData.subjectMeta{ii};
    for ff = 1:length(theseFiles)
        % Build the remote name for the file
        localName = fullfile(bidsData.directory,theseFiles{ff});
        [~,name,ext] = fileparts(theseFiles{ff});
        remoteName = ['bids@',name,ext];
        
        % Upload
        st.upload(localName,'project',projectID,...
            'remote name',remoteName);
    end
end

fprintf('Upload of %s to %s is complete\n',bidsData.directory,projectLabel);

end
