function nWarnings = validate(obj)
% Validate the bids directory tree structure
%
%     nWarnings = @bids.validate
%
%  1) Tests whether the data files in a BIDS structure exist
%  2) Tests whether all files found in the directory are included in the
%     BIDS structure 
%
% Returns
%   nWarnings is number of warnings about missing files
%
% DH/BW Scitran 2017

%%  
nWarnings = 0;

%%
%% %%% First check whether the data files in the BIDS structure exist
%%

%% Do project metadata exist?
for kk = 1:length(obj.projectMeta) % run through files for this project
    currentFile = fullfile(obj.directory,obj.projectMeta{kk});
    if ~exist(currentFile,'file')
        nWarnings = nWarnings + 1;
        
        warning('file does not exist: %s',currentFile)
    end
end

%% Do subject metadata exist?
for kk = 1:length(obj.subjectMeta) % run through subjects
    for ii = 1:length(obj.subjectMeta{kk}) % run through files for this subject
        currentFile = fullfile(obj.directory,obj.subjectMeta{kk}{ii});
        if ~exist(currentFile,'file')
            nWarnings = nWarnings + 1;
            
            warning('file does not exist: %s',currentFile)
        end
    end
end

%% Do session metadata exist?
for kk = 1:size(obj.sessionMeta,1) % run through subjects
    for mm = 1:size(obj.sessionMeta,2) % run through sessions
        for ii = 1:length(obj.sessionMeta{kk,mm}) % run through files for this subject,session
            currentFile = fullfile(obj.directory,obj.sessionMeta{kk,mm}{ii});
            if ~exist(currentFile,'file')
                nWarnings = nWarnings + 1;
                
                warning('file does not exist: %s',currentFile)
            end
        end
    end
end

%% Do the subjectData exist?
for kk = 1:length(obj.dataFiles) % run through subjects
    for mm = 1:length(obj.dataFiles(kk).session) % run through sessions
        thisDataTypes = fieldnames(obj.dataFiles(kk).session(mm));
        % run trough these data types
        for ll = 1:length(thisDataTypes)
            currentFileList = obj.dataFiles(kk).session(mm).(thisDataTypes{ll});
            for ii = 1:length(currentFileList)
                currentFile = fullfile(obj.directory,currentFileList{ii});
                if ~exist(currentFile,'file')
                    nWarnings = nWarnings + 1;
                    warning('file does not exist: %s',currentFile)
                end
            end
        end
        
    end
end

%%
%% %%% Second check whether all files in the directory are included in the BIDS structure
%%

% Get a list of all the files:
bidsFiles = dirPlus(obj.directory);

%% Check whether a file is in the subject data:

% Make a list all files in the bids object subject data (obj.dataFiles):
subjectDataList = [];
fileCounter = 0;
for kk = 1:length(obj.dataFiles) % run through subjects
    for mm = 1:length(obj.dataFiles(kk).session) % run through sessions
        thisDataTypes = fieldnames(obj.dataFiles(kk).session(mm));
        % run trough these data types
        for ll = 1:length(thisDataTypes)
            currentFileList = obj.dataFiles(kk).session(mm).(thisDataTypes{ll});
            for ii = 1:length(currentFileList)
                currentFile = fullfile(obj.directory,currentFileList{ii});
                fileCounter = fileCounter+1;
                subjectDataList{fileCounter} = currentFile;
            end
        end
    end
end

% Check whether the bidsFiles are in the obj.dataFiles:
filesNotFound = [];
filenrNotFound = []; % file number in bidsFiles list
fileCounter = 0;
for kk = 1:length(bidsFiles) % run through the files in the bids structure
    idx_subjectDataList = [];
    for mm = 1:length(subjectDataList)
        if isequal(bidsFiles{kk},subjectDataList{mm}) % the bids file is found in the subject data
            idx_subjectDataList = mm;
            break % we found the file - no need to run further
        end
    end
    if ~isempty(idx_subjectDataList) % we found a file
    else % we did not find bidsFiles{kk}
        fileCounter = fileCounter+1;
        filesNotFound{fileCounter} = bidsFiles{kk};
        filenrNotFound(fileCounter) = kk;
    end
end

%% check whether the files not found in the subject data are in the metadata

% make a list of all metadata files in the bids structure
metaDataList = [];
fileCounter = 0;
% add project metadata to list
for kk = 1:length(obj.projectMeta) % run through files for this project
    currentFile = fullfile(obj.directory,obj.projectMeta{kk});
    fileCounter = fileCounter+1;
    metaDataList{fileCounter} = currentFile;
end
% add subject metadata to list
for kk = 1:length(obj.subjectMeta) % run through subjects
    for ii = 1:length(obj.subjectMeta{kk}) % run through files for this subject
        currentFile = fullfile(obj.directory,obj.subjectMeta{kk}{ii});
        fileCounter = fileCounter+1;
        metaDataList{fileCounter} = currentFile;
    end
end
% add session metadata to list
for kk = 1:size(obj.sessionMeta,1) % run through subjects
    for mm = 1:size(obj.sessionMeta,2) % run through sessions
        for ii = 1:length(obj.sessionMeta{kk,mm}) % run through files for this subject,session
            currentFile = fullfile(obj.directory,obj.sessionMeta{kk,mm}{ii});
            fileCounter = fileCounter+1;
            metaDataList{fileCounter} = currentFile;
        end
    end    
end

% Are files found in metadata?
fileCounter = 0;
missingFiles = [];
missingFilenr = []; % file nr in bidsFiles
for kk = 1:length(filesNotFound) % run through the files in the bids structure
    idx_metaDataList = [];
    for mm = 1:length(metaDataList)
        if isequal(filesNotFound{kk},metaDataList{mm}) % the bids file is found in the metadata
            idx_metaDataList = mm;
            break % we found the file - no need to run further
        end
    end
    if ~isempty(idx_metaDataList) % we found a file
    else % we did not find filesNotFound{kk}
        fileCounter = fileCounter+1;
        missingFiles{fileCounter} = filesNotFound{kk};
        missingFilenr(fileCounter) = filenrNotFound(kk);
    end
end

% display missing files 
for ii = 1:length(missingFiles)
    currentFile = missingFiles{ii};
    nWarnings = nWarnings + 1;
    warning('file not in bids structure: %s',currentFile)   
end

%%
if nWarnings == 0, fprintf('Found all the files\n'); 
else,              fprintf('%d warnings\n',nWarnings);
end

end