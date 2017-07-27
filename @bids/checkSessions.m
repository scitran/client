function nSessions = checkSessions(obj,participantList)
% checkSessions - How many session folders are there for these participants
%
%    obj.checkSessions(participantList)
%
% When there is only one session, there are 0 session folders
%
% DH

curDir = pwd;

% If empty, report on all of them
if isempty(participantList), participantList = 1:obj.nParticipants; end
nSessions = zeros(1,obj.nParticipants);

for ii=1:length(participantList)
    
    chdir(obj.subjectFolders{ii})
    
    sessionFolders = dirPlus(obj.subjectFolders{ii},...
        'ReturnDirs',true,...
        'PrependPath',false, ...
        'DirFilter','ses');
    
    if ~isempty(sessionFolders)
        nSessions(ii) = length(sessionFolders);
    end

end

obj.nSessions = nSessions;

chdir(curDir);

end
