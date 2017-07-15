function subjFolders(obj)
% Make a list of all the subject folders

folders = dirPlus(obj.directory,...
    'ReturnDirs',true,...
    'DirFilter','sub-*',...
    'PrependPath',false);

% Read the participants file and check that it matches the
% subject folders
participantsFile = fullfile(obj.directory,'participants.tsv');
participants = readtable(participantsFile,'filetype','text','delimiter','\t');

if ~ismember(participants.participant_id,folders)
    error('Mis-match between participant list and subject folders.')
else
    fprintf('Check ok: participant list matches subject folders. \n')
end

folders = dirPlus(obj.directory,...
    'ReturnDirs',true,...
    'DirFilter','sub-*',...
    'PrependPath',true);

obj.subjectFolders = folders;

end