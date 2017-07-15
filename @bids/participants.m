function participants(obj)
% Check for the participants.tsv file and do other stuff

chdir(obj.directory);

% Check for the file and load it
if exist('participants.tsv','file')
    participants = readtable('participants.tsv','filetype','text','delimiter','\t');
    obj.nParticipants = length(participants.participant_id);
else
    error('Missing participants.tsv file');
end

% fw.putBids will need to put the participants file on the
% project
%
% fw.put('participants.tsv','container is the project');
end