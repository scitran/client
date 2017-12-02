%% Developing bids Matlab interface
%
% DH/BW Scitran Team, 2017

%% Create the bids object

% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds001');
% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds009');   % Warning
% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds003');

bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds001');

b = bids(bidsDir);

%{
 % Have a look at the data
 whichSubject = 2;
 b.subjectData(whichSubject).session(1).anat
%}