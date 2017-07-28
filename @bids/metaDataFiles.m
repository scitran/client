function [projectMeta, subjectMeta, sessionMeta] = metaDataFiles(obj)
% METADATAFILE
%
%  Make a cell array of the meta data files at each of the different levels
%    Project (root directory)     cell is 1
%    Per Subject                  cell is nParticipants
%    Per Subject per Session      cell is nParticipants/Sessions
%
% DH, Scitran Team, 2017


% get project metadata - this does not have to be preallocated
projectMeta = dirPlus(obj.directory,...
    'Depth',0,...
    'FileFilter','\.(json|tsv)$',...
    'ReturnDirs',false,...
    'PrependPath',true);
obj.projectMeta = projectMeta;

% get subject metadata
subjectMeta = cell(obj.nParticipants,1);
for ss = 1:obj.nParticipants
            
    % gets metadata in the folder from subject s
    thisSubjectFiles = dirPlus(obj.subjectFolders{ss},...
        'Depth',0,...
        'FileFilter','\.(json|tsv)$',...
        'ReturnDirs',false,...
        'PrependPath',true);
    subjectMeta{ss} = thisSubjectFiles;

end
obj.subjectMeta = subjectMeta;

% get session metadata
sessionMeta = cell(obj.nParticipants,max(obj.nSessions));

for ss = 1:obj.nParticipants
    if obj.nSessions(ss)>0 % if sessions exist for this participant
        % Find the session folders
        sessionFolders = dirPlus(obj.subjectFolders{ss},...
            'ReturnDirs',true,...
            'PrependPath',true,...
            'DirFilter','ses');
        
        % Find the metadata files in session folder
        for ff=1:length(sessionFolders)
            thisSessionFiles = dirPlus(sessionFolders{ff},...
                'Depth',0,...
                'FileFilter','\.(json|tsv)$',...
                'ReturnDirs',false,...
                'PrependPath',true);
            sessionMeta{ss,ff} = thisSessionFiles;
            
        end
    end
end
obj.sessionMeta = sessionMeta;        


end
