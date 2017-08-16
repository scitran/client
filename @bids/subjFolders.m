function subjFolders(obj)
% SUBJFOLDERS - Make a list of all the subject folders
%
%   @bids.subjFolders;
%
% The list is placed in obj.subjFolders{}
%
% DH/BW Scitran Team, 2017


%% List folders starting with sub-
folders = dirPlus(obj.directory,...
    'ReturnDirs',true,...
    'DirFilter','sub-*',...
    'PrependPath',false);

obj.subjectFolders = folders;

%% The participants.tsv is optional.

% But if it exists, we check that it matches the subject folders

participantsFile = fullfile(obj.directory,'participants.tsv');
if exist(participantsFile,'file')
    participants = readtable(participantsFile,'filetype','text','delimiter','\t');
    if ~ismember(participants.participant_id,folders)
        error('Mis-match between participant list and subject folders.')
    end
end

end