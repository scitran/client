function nWarnings = validate(obj)
% validate - Test whether the data files in a BIDS structure exist
%
%     nWarnings = @bids.validate
%
% Returns
%   nWarnings is number of warnings about missing files
%
% DH/BW Scitran 2017

%%  
nWarnings = 0;

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
    for mm = size(obj.sessionMeta,2) % run through sessions
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
if nWarnings == 0, fprintf('Found all the files\n'); 
else,              fprintf('%d warnings\n',nWarnings);
end

end