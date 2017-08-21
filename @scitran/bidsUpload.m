function project = bidsUpload(st,bidsData, groupLabel, varargin)
%
%   @scitran.bidsUpload
% 
% Example:
%    fw = scitran('vistalab');
%    data = bids(fullfile(stRootPath,'local','BIDS-examples','fw_test'));
%    data.projectLabel = 'fw_bids_test';
%    project = fw.bidsUpload(data,'wandell');
%    
%  To delete this project you can use
%
%    fw.deleteProject('fw_bids_test','saveproject',true);
%
%  and then delete the project itself by hand, after checking that the
%  sessions have been removed.  Or, simply use
%
%    fw.deleteProject('fw_bids_test');
%
%  However, we have been having difficulty with elastic search indexing of
%  the deleted project.  Hopefully this will be solved shortly.
%
% BW/DH Scitran Team, 2017

%% input

% Check the bids data structure and determine the project label.
p = inputParser;
p.addRequired('bidsData',@(x)(isa(x,'bids')));
p.addRequired('groupLabel',@ischar);

p.addParameter('projectLabel','',@ischar);

p.parse(bidsData,groupLabel,varargin{:});

% If no project label is sent in, then use the project label in the
% bidsData structure.
projectLabel = p.Results.projectLabel;
if isempty(projectLabel), projectLabel = bidsData.projectLabel; end

%%  Create the project

% Check if it already exists.  If it does, throw an error
% Otherwise, create it.
status = st.exist(projectLabel,'projects');
if ~status
    st.create(groupLabel,projectLabel);
    fprintf('Created project %s\n',projectLabel);
else
    error('Project %s exists.\n');
end

%% Make the sessions, acquisitions and upload the data files

% Make all the sessions.  They will be labeled sub-N_ses-M
nSessions = sum(bidsData.nSessions);   % Total number of sessions
sessionLabels = cell(nSessions,1);

cntr = 1;   % Count the number of sessions we are creating.
for ii=1:length(bidsData.subjectFolders)
    
    % How many sessions for this subject
    nSessions = bidsData.nSessions(ii);
    
    for ss = 1:nSessions
        
        % If there is more than one session label it.  Otherwise, leave ses-XX off
        % the label.  Maybe we should always label with ses, though.
        if nSessions > 1
            thisSessionLabel = sprintf('%s-ses-%d',bidsData.subjectFolders{ii},ss);  % **** save the sessionLabels
        else
            thisSessionLabel = sprintf('%s',bidsData.subjectFolders{ii});  % **** save the sessionLabels
        end
        sessionLabels{cntr} = thisSessionLabel; cntr = cntr+1;
        
        fprintf('Uploading session %s.\n',thisSessionLabel);
        sessionID = st.create(groupLabel,projectLabel,'session',thisSessionLabel);
        pause(2);
        % Until we have the direct database query, we pause to allow
        % elastic search to index.
        session = st.search('sessions','session id',sessionID);
        
        % We can add more subject fields here.  The update method can fill
        % in various database fields. Probably these should be filled in by
        % a separate function.
        data.subject.code = sprintf('%s',bidsData.subjectFolders{ii});
        st.update(data,'container', session{1});
        
        % For each subject folder find the dataFiles fields
        acqNames = fieldnames(bidsData.dataFiles(ii).session(ss));

        for jj=1:length(acqNames)
            thisAcquisitionLabel = acqNames{jj};
            fprintf('Create acquisition %s in session %s\n',thisAcquisitionLabel,thisSessionLabel);
            acquisitionID = st.create(groupLabel,projectLabel,...
                'session',thisSessionLabel,...
                'acquisition',thisAcquisitionLabel);
            pause(2);   % Allow time for elastic search
            
            % Upload the data files
            nFiles = length(bidsData.dataFiles(ii).session(ss).(thisAcquisitionLabel));
            acquisition = st.search('acquisitions','acquisition id',acquisitionID);
            
            if nFiles > 0
                fprintf('Uploading %d files.\n',nFiles);
                for kk=1:nFiles
                    fname = fullfile(bidsData.directory,...
                        bidsData.dataFiles(ii).session(ss).(thisAcquisitionLabel){kk});
                    st.put(fname,acquisition);
                end
            end
        end
        fprintf('Done uploading session %s.\n',session{1}.source.label);
    end
end

%% Upload the PROJECT metadata

project = st.search('projects','project label',projectLabel);

% Put the meta data into the Project tab as an attachment
fprintf('Uploading project metadata\n');
if ~isempty(bidsData.projectMeta)
    for ii=1:length(bidsData.projectMeta)
        localName  = fullfile(bidsData.directory,bidsData.projectMeta{ii});
        st.put(localName,project);
    end
end

%% Upload the SESSION meta data into the anotation tab as an attachment.

fprintf('Uploading session metadata\n');
cntr = 1;
for ii=1:length(bidsData.subjectFolders)
    for ss = 1:bidsData.nSessions(ii)
        session = st.search('sessions','session label',sessionLabels{cntr},'project label',projectLabel);
        theseFiles = bidsData.sessionMeta{ii,ss};
        fprintf('Uploading %d files to %s\n',length(theseFiles),session{1}.source.label);
        for ff = 1:length(theseFiles)
            localName = fullfile(bidsData.directory,theseFiles{ff});
            st.put(localName,session);            
        end
        cntr = cntr+1;
    end
end

%% Upload the subject meta data.  

% For now, we attach these files to the project.  In the future, we will
% attach them with a slightly different name to the subject slot.  That
% will happen when the subject becomes visible in the UI.
fprintf('Uploading subject metadata\n');
for ii=1:length(bidsData.subjectMeta)
    theseFiles = bidsData.subjectMeta{ii};
    for ff = 1:length(theseFiles)
        localName = fullfile(bidsData.directory,theseFiles{ff});
        [~,name,ext] = fileparts(theseFiles{ff});
        remoteName = ['bids@',name,ext];
        copyfile(localName,remoteName)
        st.put(remoteName,project);
    end
end

fprintf('bids upload to %s is complete\n',projectLabel);

end
