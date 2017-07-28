%% Developing bids Matlab interface
%
% DH/BW Scitran Team, 2017

% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds001');
% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds009');   % Warning

% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds003');

bidsDir = fullfile(stRootPath,'local','BIDS-Examples','7t_trt');

% Create the bids object
b = bids(bidsDir);

% Run through the directory loading the participans
% b.participants;
% 
% % Add folder for each participant
% b.subjFolders;
% 
% b.checkSessions([]);
% 
% % Add data directories and files for each subject
% b.subjData;
% 
% % To see the allowable data types
% % b.dataTypes
% 
% % Auxiliary files in the root directory
% % JSON and TSV files
% b.metaDataFiles;
% 
% whichSubject = 2;
% b.subjectData(whichSubject).session(1).anat
