function participants(obj)
% DEPRECATED
%
%  PARTICIPANTS
%
%   @bids.participants
%
% Check for the participants.tsv file and do other stuff
%
% DH Scitran, 2017


%% List the number of subject folders 

folders = dirPlus(obj.directory,...
    'ReturnDirs',true,...
    'DirFilter','sub-*',...
    'PrependPath',false);

obj.nParticipants = length(folders);



end