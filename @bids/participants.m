function participants(obj)
% PARTICIPANTS
%
%   @bids.participants
%
% Check for the participants.tsv file and do other stuff
%
% DH Scitran, 2017

curDir = pwd;

chdir(obj.directory);

% Check for the file and load it
if exist('participants.tsv','file')
    participants = readtable('participants.tsv','filetype','text','delimiter','\t');
    obj.nParticipants = length(participants.participant_id);
else
    error('Missing participants.tsv file');
end

chdir(curDir);

% fw.putBids will need to put the participants file on the
% project
%
% fw.put('participants.tsv','container is the project');
end