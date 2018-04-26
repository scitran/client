%% bidsTesting
%
% Using dirPlus to get a qualified local BIDS directory tree and put it up
% on a Flywheel project.
%
% We are writing this as exploratory code for setting up the bids.m
% classdef
%
% The goal is to be able to run
%
%   fw = scitran('stanfordlabs');
%   thisBids = bids('bids directory');  % Reads and validates.
%   fw.putBids(thisBids);
%  
% DH/BW ScitranTeam 2017

%% Directories one deep in the first data set

chdir(fullfile(stRootPath,'local','BIDS-examples'));

%Go into one and see what we have
dsList = dirPlus(pwd,'Depth',0,'ReturnDirs',true,'DirFilter','ds*');

% We will practice on data set 1
chdir(dsList{1});

% We read as a table, but we could have used importdata and we would get a
% struct.  The table displays nicely.  The struct is good for computing.
% You can use 
%    p = table2struct(participants) 
% if you want the table in a struct.

%% Logic begins here

% bids.participants;
% Find the file and note it in the bids object
% Also count the number of subjects and store that

% bids.participants;
% Check for the file and load it
if exist('participants.tsv','file')
    participants = readtable('participants.tsv','filetype','text','delimiter','\t');
    nSubjects = length(participants.participant_id);
    fprintf('Number of participants %d\n',nSubjects);
else
    error('Missing participants.tsv file');
end

% fw.putBids
% Put the participants file on the project
fw.put('participants.tsv','container is the project');

%% Check whether the folders in a subject's BIDS directory are in a qualified list


subjectFolders = dirPlus(dsList{1},'ReturnDirs',true,...
    'DirFilter','sub-*',...
    'PrependPath',false);
if ~ismember(participants.participant_id,subjectFolders) % problem
    warning('Mis-match between participant list and subject folders.')
else % this check is ok
    fprintf('Check ok: participant list matches subject folders. \n')
end

%% Check for a stimulus folder

stimDir = dirPlus(pwd,'ReturnDirs',true,'DirFilter','stimuli');
if ~isempty(stimDir)
    disp('Uploading the stimuli as a zip file and attach to the projects')
end

%% Let's change into the first subject folder and check what we have

% This will be a loop across subjects

% Do we have multiple sessions for this subject?
chdir(subjectFolders{1})

sessions = dir('ses-*');
if isempty(nSessions),     nSessions = 1;
else,                      nSessions = length(sessions);
end

% Maybe we will do something like this ... or loop on sessions
% switch nSessions
%     case 1
%       Make the one session
%     otherwise
% end

%% On flywheel we need to build the corresponding session

% This is the logic when there is only 1 session

session = fw.createSession('in the project','Figure out a session name (e.g., subjCode-ses-01)');
fw.writeSubjectid('into the session container')

%% Find the legitimate acquisitions for this session

acqTypes = {'anat','func','ieeg','meg','eeg','dwi','derivatives'};
acqs = dirPlus(pwd,'ReturnDirs',true,'PrependPath',false);

% Test whether acqs are legitimate directory names (acqTypes)
for ii=1:length(acqs)
    if ~ismember(acqs(ii),acqTypes)
        error('One of the directories is not a legitimate acq type: %s',acqs(ii));
    end
end

%% We now have a qualified list of acqs in the subject (and possibly ses-) folder

% Loop for each acquisition create it in the session
fwAcq = fw.createAcquisition('acquisition name is in acqs(ii)','container is the session id')

chdir(acqs{1});

% Get the full file paths because fw.put wants that
files = dirPlus(pwd);
for ii=1:length(files)
    fw.put(files{ii},fwAcq.id);
end

%%



