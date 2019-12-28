function dr_fwDownloadFileFromAnalysis(varargin)

%{
serverName = 'stanfordlabs';
% collectionName = 'CompRepCheck';
collectionName = 'BCBL_BERTSO';
gearName = 'afq-pipeline'; 
gearVersion    = '3.0.7';
analysisLabelContains = 'v02b:v3.0.7:10LiFE:min20max250:0.1cutoff:X flipped Allv02b: Analysis afq-pipeline';
fileNameContains = 'afq_';
% downloadBase = '/sni-storage/kalanit/biac2/kgs/projects/NFA_tasks/data_mrAuto';
downloadBase = '/Users/glerma/Documents/BCBL_PROJECTS/BERTSOLARI/ANALYSIS'

    dr_fwDownloadFileFromAnalysis('serverName',serverName, ...
                                  'collectionName',collectionName, ...
                                  'gearName', gearName, ...
                                  'gearVersion', gearVersion, ...
                                  'analysisLabelContains', analysisLabelContains, ...
                                  'fileNameContains', fileNameContains, ...
                                  'downloadBase', downloadBase, ...
                                  'unzipFile', false, ...
                                  'showSessions', false)
%}

%% Read parameters/create defaults            
p = inputParser;
p.addParameter('serverName'           , 'stanfordlabs' , @ischar);
p.addParameter('collectionName'       , 'tmpCollection', @ischar);
p.addParameter('gearName'             , 'afq-pipeline' , @ischar);
p.addParameter('gearVersion'          , '3.0.7'        , @ischar);
p.addParameter('analysisLabelContains', 'v01'          , @ischar);
p.addParameter('fileNameContains'     , 'afq_'         , @ischar);
p.addParameter('downloadBase'         , '/tmp'         , @ischar);
p.addParameter('unzipFile'            , false          , @islogical);
p.addParameter('showSessions'         , false          , @islogical);
p.parse(varargin{:});
            
serverName            = p.Results.serverName;
collectionName        = p.Results.collectionName;
gearName              = p.Results.gearName;
gearVersion           = p.Results.gearVersion;
analysisLabelContains = p.Results.analysisLabelContains;
fileNameContains      = p.Results.fileNameContains;
downloadBase          = p.Results.downloadBase;
unzipFile             = p.Results.unzipFile;
showSessions          = p.Results.showSessions;


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
    if showSessions
        for ns=1:length(sessionsInCollection)
        thisSession = st.fw.getSession(idGet(sessionsInCollection{ns}));
        % Get info for the project the session belong to
        thisProject = st.fw.getProject(thisSession.project);
        fprintf('(%d) %s >> %s (%s)\n', ns, thisProject.label, thisSession.subject.code, thisSession.label)
    end
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
    downloadDir = fullfile(downloadBase, thisSession.subject.code);
    if ~exist(downloadDir,'dir') 
        mkdir(downloadDir)
        % fprintf('The download folder does not exist, adding session to the tmpCollection...\n') 
        % dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        % continue
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
    myAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, containerType, pattern,'last');
    if isempty(myAnalysis)
        fprintf('There are analyses, but not the one you are looking for, adding session to the tmpCollection...\n') 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    % Use this for debugging or manual mode
    %{
    % Check for the date because I used the same analysos label...
    if ~(myAnalysis.created > '20-Jan-2019 13:28:32')
        fprintf('This must be the old one, look for the new one, adding session to the tmpCollection...\n') 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    %}
    
    % Search for the file in the results of the analysis
    fileName  = dr_fwFileName(myAnalysis, fileNameContains);
    if isempty(fileName)
        fprintf('The file you are looking for is not part of this analysis (%s), adding session to the tmpCollection...\n', myAnalysis.label) 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    % Download (and unzip) the file 
    st.fw.downloadOutputFromAnalysis(myAnalysis.id, fileName, ...
                                     fullfile(downloadDir,fileName))
    if ~exist(fullfile(downloadDir,fileName),'file')
        fprintf('The file could not be downloaded, adding session to the tmpCollection...\n') 
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

