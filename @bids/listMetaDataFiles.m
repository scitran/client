function [projectMeta, subjectMeta, sessionMeta] = listMetaDataFiles(obj)
% listMetaDataFiles
%
%  Make a cell array of the meta data files at each of the different levels
%    Project (root directory)     cell is 1
%    Per Subject                  cell is nParticipants
%    Per Subject per Session      cell is nParticipants/Sessions
%
% DH, Scitran Team, 2017


%% get project metadata - this does not have to be preallocated
projectMeta = dirPlus(obj.directory,...
    'Depth',0,...
    'FileFilter','\.(json|tsv)$',...
    'ReturnDirs',false,...
    'PrependPath',false);
obj.projectMeta = projectMeta;

%% get subject metadata

% Each cell array contains a cell array of file names
subjectMeta = cell(obj.nParticipants,1);

for ss = 1:obj.nParticipants
    thisDir = fullfile(obj.directory,obj.subjectFolders{ss});
    % gets metadata in the folder from subject s
    thisSubjectFiles = dirPlus(thisDir,...
        'Depth',0,...
        'FileFilter','\.(json|tsv)$',...
        'ReturnDirs',false,...
        'PrependPath',false);
    
    if ~isempty(thisSubjectFiles)
        % There are metadata files.  Store them.
        
        % Make the cell array of file names for this subject
        fname = cell(length(thisSubjectFiles),1);
        for ii=1:length(thisSubjectFiles)
            fname{ii} = fullfile(obj.subjectFolders{ss},thisSubjectFiles{ii});
        end
        % Store it
        subjectMeta{ss} = fname;
    end
end
% Attach the cell array of cell arrays 
obj.subjectMeta = subjectMeta;

%% get session metadata
sessionMeta = cell(obj.nParticipants,max(obj.nSessions(:)));

for ss = 1:obj.nParticipants
    if obj.nSessions(ss)>1 % if sessions exist for this participant
        % Find the session folders
        thisDir = fullfile(obj.directory,obj.subjectFolders{ss});
        sessionFolders = dirPlus(thisDir,...
            'ReturnDirs',true,...
            'PrependPath',false,...
            'DirFilter','ses');
        
        % Find the metadata files in session folder
        for ff=1:length(sessionFolders)
            thisSessionFiles = dirPlus(fullfile(thisDir,sessionFolders{ff}),...
                'Depth',0,...
                'FileFilter','\.(json|tsv)$',...
                'ReturnDirs',false,...
                'PrependPath',false);
            
            % Make the relative path
            fname = cell(length(thisSessionFiles),1);
            for ii=1:length(thisSessionFiles)
                fname{ii} = fullfile(obj.subjectFolders{ss},sessionFolders{ff},thisSessionFiles{ii});
            end
            sessionMeta{ss,ff} = fname;
        end
    end
end
obj.sessionMeta = sessionMeta;        

end
