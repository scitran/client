function localFiles = dr_fwDownloadFileFromZip(st, collectionName, ...
                                               zipNameContains, varargin)
%
% Add information to find and download from a zip. 
% If there are more than one analysis with the same name or
% 
% Syntax:
%     [check] = dr_fwDownloadFileFromZip(st, collectionName, zipNameContains)
%
% Description:
%  Input an scitran object, collectionName and but the zipName contains to
%  download them all. 
%
% Inputs: (required)
%  st: scitran object
%  collectionName: scitran object
%  zipNameContains: string to match with filenames
%
% Optional key/val pairs:
% downloadWholeZip     :  
% unzipAll             :
% sessionLabelContains :
% filesContain         :
% listFileNames        :
% addSubjNameToDownPath:
%
% Examples:
%{
clear all; close all; clc;
st                    = scitran('stanfordlabs'); st.verify
colecName             = 'HCPTEST';
% analysisLabelContains = 'AllV03:v3.0.6:10LiFE:min20max250:0.1cutoff:Analysis afq-pipeline bVal: 3000';
analysisLabelContains = 'MS7';
zipNameContains       = 'AFQ_Output_';
% listOfFilesContain    = {'MoriGroups_clean','_wmMask.mif','_wmMask_dilated.mif', ...
%                              '_fa.mif', 'b0.nii.gz','_L.mat','_R.mat'};
% listOfFilesContain    = {'MoriGroups_clean', 'b0.nii.gz', '_L.mat','_R.mat'};    
% listOfFilesContain    = {'_fa.mif', '_CLIPPED_'};
listOfFilesContain    = {'_autolmax.mif'};
downloadDir           = '/Users/glerma/Downloads/v3.0.6';
downFiles             = dr_fwDownloadFileFromZip(st, colecName, zipNameContains, ...
                         'analysisLabelContains', analysisLabelContains, ...
                         'filesContain'         , listOfFilesContain, ...
                         'downloadTo'           , downloadDir, ...
                         'showListSession'      , false);
%}
% 
% GLU Vistalab, 2018


%% 0.- Parse inputs
p = inputParser;

addRequired(p, 'st'             );
addRequired(p, 'collectionName' );
addRequired(p, 'zipNameContains');

addOptional(p, 'downloadWholeZip'     , false            , @islogical);
addOptional(p, 'unzipAll'             , false            , @islogical);
addOptional(p, 'analysisLabelContains', 'Analysis'       , @ischar);
addOptional(p, 'filesContain'         , {'afq'}          , @iscell);
addOptional(p, 'downloadTo'           , '/Users/glerma/Downloads', @ischar);
addOptional(p, 'showListSession'      , false            , @islogical);
parse(p,st,collectionName,zipNameContains,varargin{:});

downloadWholeZip     = p.Results.downloadWholeZip;
unzipAll             = p.Results.unzipAll;
analysisLabelContains= p.Results.analysisLabelContains;
filesContain         = p.Results.filesContain;
downloadTo           = p.Results.downloadTo;
showListSession      = p.Results.showListSession;

%% 1.- Obtain the collection

% Connect to the collection, verify it and show the number of sessions for verification
% FC: obtain collection ID from the collection name

cc            = st.search('collection','collection label contains',collectionName);
collectionID  = cc{1}.collection.id;
if isempty(collectionID)
    error('Collection %s could not be found on the server %s (verify permissions or the collection name).', collectionName, st.instance)
else
    thisCollection        = st.fw.getCollection(collectionID);
    sessionsInCollection  = st.fw.getCollectionSessions(idGet(thisCollection));
    fprintf('There are %i sessions in the collection %s (server %s).\n', length(sessionsInCollection), collectionName, st.instance)
    if showListSession
        for ns=1:length(sessionsInCollection)
            thisSession = st.fw.getSession(idGet(sessionsInCollection{ns}));
            % Get info for the project the session belong to
            thisProject = st.fw.getProject(thisSession.project);
            fprintf('(%d) %s >> %s (%s)\n', ns, thisProject.label, thisSession.subject.code, thisSession.label)
        end
    end
end

%% 2.- Download the files
for ns=1:length(sessionsInCollection)
    % Get info for the session
    thisSession = st.fw.getSession(idGet(sessionsInCollection{ns}));
    % Get info for the project the session belong to
    thisProject = st.fw.getProject(thisSession.project);
    fprintf('(%d) %s >> %s (%s)\n', ns, thisProject.label, thisSession.subject.code, thisSession.label)
    analysesInSession  = st.fw.getSessionAnalyses(thisSession.id);
    % If there are no in this session, continue to the following one
    if isempty(analysesInSession)
        fprintf('No analysis found in this session, adding session to the tmpCollection...\n') 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    % Obtain the values per every analysis that interests us
    containerType = 'analysis'; pattern = analysisLabelContains;
    myAnalyses = dr_fwSearchAcquAnalysis(st, thisSession, containerType, pattern, 'all');
    if isempty(myAnalyses)
        fprintf('There are analyses, but not the one you are looking for, adding session to the tmpCollection...\n') 
        dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
        continue
    end
    % Do the work for all the analysis that follow the criteria
    for na = 1:length(myAnalyses)
        myAnalysis = myAnalyses{na};
        % Search for the file in the results of the analysis
        zipName  = dr_fwFileName(myAnalysis, zipNameContains);
        if isempty(zipName)
            fprintf('The file you are looking for is not part of this analysis (%s), adding session to the tmpCollection...\n', myAnalysis.label) 
            dr_fwAddSession2tmpCollection(st, thisSession, 'tmpCollection')
            continue
        end
        % Get information about a zip file
        zipInfo   = myAnalysis.getFileZipInfo(zipName);
        % Obtain all the members we want to obtain
        fileNames = {};
        for nf = 1:length(filesContain)
            tmpNames  = dr_fwFileName(zipInfo, filesContain{nf});
            fileNames = [fileNames, tmpNames];
        end
        % Download the files to local
        if isempty(filesContain)
            warning('No file members for this zip. Check options.\n')
        else
            % Create the download dir with the analysis name
            downloadDir = fullfile(downloadTo, thisSession.subject.code, myAnalysis.label);
            if ~exist(downloadDir,'dir'); mkdir(downloadDir); end
            for fn=1:length(fileNames)
                fileName = fileNames{fn};
                outPath  = fullfile(downloadDir, fileName);
                % Check if outPath exists otherwise create
                if ~exist(fileparts(outPath),'dir');mkdir(fileparts(outPath));end
                myAnalysis.downloadFileZipMember(zipName, fileName, outPath);
                localFiles{fn} = outPath;
            end
        end
    end
end

