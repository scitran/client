%% bidsTesting
%
% Using dirPlus to get stuff we want, and some exploratory code for setting
% up the bids.m classdef
%
% DH/BW ScitranTeam 2017

%%

chdir(fullfile(stRootPath,'local','BIDS-examples'));

%% Directories one deep in the first data set

dsList = dirPlus(pwd,'Depth',0,'ReturnDirs',true,'DirFilter','ds*');
dsList

%% Go into one and see what we have

% We read as a table, but we could have used importdata and we would get a
% struct.  The table displays nicely.  The struct is good for computing.
% You can use 
%    p = table2struct(participants) 
% if you want the table in a struct.

chdir(dsList{1});
if exist('participants.tsv','file')
    participants = readtable('participants.tsv','filetype','text','delimiter','\t');
    nSubjects = length(participants.participant_id);
    fprintf('Number of participants %d\n',nSubjects);
else
    disp('Missing participants.tsv file');
end

%% Check whether the folders in a subject's BIDS directory are in a qualified list

subjectFolders = dirPlus(dsList{1},'ReturnDirs',true,...
    'DirFilter','sub-*',...
    'PrependPath',false);
if ~ismember(participants.participant_id,subjectFolders) % problem
    warning('Mis-match between participant list and subject folders.')
else % this check is ok
    fprintf('Check ok: participant list matches subject folders. \n')
end


%%

