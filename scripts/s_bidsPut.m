%% s_bidsPut
%
% Illustration of how to use bidsUpload in the scitran object.
%
% Wandell, Scitran Team, 2017

%% Open up the scitran client

st = scitran('stanfordlabs');

%% Here are example bids data sets.  Pick one.

% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','ds001');
% bidsDir = fullfile(stRootPath,'local','BIDS-Examples','7t_trt');
% bidsDir = fullfile(stRootPath,'local','BIDS-examples','ds003');
% bidsDir = fullfile(stRootPath,'local','BIDS-examples','fw_test');

% Create the bids object
thisBids = bids(bidsDir);

% Set the label for the project
thisBids.projectLabel = 'BIDSUp';

% Set the group label where you have permission
groupLabel = 'Wandell Lab';

% Do the upload
project = st.bidsUpload(thisBids,groupLabel);

%%  After you have finished testing, delete this way

%{
[s,id] = st.exist('project',data.projectLabel);
if s, st.deleteContainer('project',id); end
%}

%{
[s,id] = st.exist('project','BIDSUp');
if s, st.deleteContainer('project',id); end
%}

%{
[s,id] = st.exist('project','BIDS-HELP');
if s, st.deleteContainer('project',id); end
%}

