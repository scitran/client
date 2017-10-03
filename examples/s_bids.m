%% Developing bids Matlab interface
%
% DH/BW Scitran Team, 2017

% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds001');
% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds009');   % Warning

% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds003');

bidsDir = fullfile(stRootPath,'local','BIDS-Examples','7t_trt');

% Create the bids object
b = bids(bidsDir);

% Run trough all metadata and subject data and test whether they
% exist  Maybe dataValidate?
b.doDataExist;

%% These are the routines that run when we initiate the bids object

% The file paths stored are all relative to the root directory, which is
% stored in @bids.directory

% Run through the directory loading the participans
% b.participants;
% 
% % Add folder for each participant
% b.subjFolders;
%
% % Just a check. Not used.
% b.checkSessions([]);
% 
% % Add data directories and files for each subject
% b.subjData;
% 
% % To see the allowable data types, not used.
% % b.dataTypes
% 
% % Find the auxiliary files at each level of the hierarchy
% % These are JSON and TSV files
% b.metaDataFiles;
%
% % Have a look at an example file
% whichSubject = 2;
% b.subjectData(whichSubject).session(1).anat
