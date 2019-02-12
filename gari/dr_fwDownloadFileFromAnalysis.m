function [outputArg1,outputArg2] = dr_fwDownloadFileFromAnalysis(serverName, projectID)

%{
serverName = 'stanfordlabs';
collectionName = 'CompRepCheck';
gearName = 'afq-pipeline'; 
gearVersion    = '3.0.2';
analysisLabelContains = 'AllV02';
fileNameContains = 'AFQ_Output_';
unzipFile = true;
downloadBase = '/sni-storage/kalanit/biac2/kgs/projects/NFA_tasks/data_mrAuto';
%}

%% 1.- CONNECT (server & collection)
st = scitran(serverName);
st.verify

% Connect to the collection, verify it and show the number of sessions for verification
% FC: obtain collection ID from the collection name
collectionID = '';
collections  = st.fw.getAllCollections();
for nc=1:length(collections)
    if strcmp(collections{nc}.label, collectionName)
        collectionID = collections{nc}.id;
    end
end

if isempty(collectionID)
    error(sprintf('Collection %s could not be found on the server %s (verify permissions or the collection name).', collectionName, serverName))
else
    thisCollection        = st.fw.getCollection(collectionID);
    sessionsInCollection  = st.fw.getCollectionSessions(idGet(thisCollection));
    fprintf('There are %i sessions in the collection %s (server %s).\n', length(sessionsInCollection), collectionName, serverName)
    for ns=1:length(sessionsInCollection)
        thisSession = st.fw.getSession(idGet(sessionsInCollection{ns}));
        % Get info for the project the session belong to
        thisProject = st.fw.getProject(thisSession.project);
        fprintf('(%d) %s >> %s (%s)\n', ns, thisProject.label, thisSession.subject.code, thisSession.label)
    end
end

%% Download the files


% This is in stanfordlabs.flywheel.io
% If sthg is not going right for a subject, it will add it here
for ns=1:length(sessionsInCollection)
    % Get info for the session
    thisSession = st.fw.getSession(idGet(sessionsInCollection{ns}));
    % Get info for the project the session belong to
    thisProject = st.fw.getProject(thisSession.project);
    fprintf('(%d) Gear %s in session: %s >> %s (Session: %s)\n', ns, gearName, thisProject.label, thisSession.subject.code, thisSession.label)
    downloadDir = fullfile(downloadBase, thisSession.subject.code, '96dir_run1');
    if ~exist(downloadDir,'dir') 
        fprintf('The download folder does not exist, adding session to the tmpCollection...\n') 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    analysesInSession  = st.fw.getSessionAnalyses(thisSession.id);
    % If there are no in this session, continue to the following one
    if isempty(analysesInSession)
        fprintf('No analysis found in this session, adding session to the tmpCollection...\n') 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    % Obtain the values per every analysis that interests us
    containerType = 'analysis'; pattern = analysisLabelContains;
    myAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, containerType, pattern);
    if isempty(myAnalysis)
        fprintf('There are analyses, but not the one you are looking for, adding session to the tmpCollection...\n') 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    % Check for the date because I used the same analysos label...
    if ~(myAnalysis.created > '20-Jan-2019 13:28:32')
        fprintf('This must be the old one, look for the new one, adding session to the tmpCollection...\n') 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end

    % Search for the file in the results of the analysis
    fileName  = dr_fwFileName(myAnalysis, fileNameContains);
    if isempty(fileName)
        fprintf('The file you are looking for is not part of this analysis (%s), adding session to the tmpCollection...\n', myAnalysis.label) 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    % Download (and unzip) the file 
    st.fw.downloadOutputFromAnalysis(myAnalysis.id,fileName,fullfile(downloadDir,fileName))
    if ~exist(fullfile(downloadDir,fileName),'file')
        fprintf('The zip could not be downloaded, adding session to the tmpCollection...\n') 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    % Unzip it
    if unzipFile
        unzip(fullfile(downloadDir,fileName), downloadDir)
        % Rename the unziped folder
        % labelKey       = strrep(analysisLabelContains,' ','_');
        % labelKey       = strrep(labelKey,':','_');
        [path,name,ext]= fileparts(fullfile(downloadDir,fileName)); 
        % name           = strrep(name,fileNameContains,'');
        name           = strrep(name, 'AFQ_Output_','');
        oldFolderName  = fullfile(path,name);
        newFolderName  = fullfile(path,['fw_afq_ET_noACT_LiFE_3.0.2_lmax8']);
        movefile(oldFolderName, newFolderName)
    end
end  % for
end  % function

