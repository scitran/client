%% s_bidsPut
%
% In which we take a bids data structure and upload it to create the
% Flywheel Project 
%
%

%%
st = scitran('vistalab');

% data = bids(fullfile(stRootPath,'local','BIDS-examples','ds003'));
data = bids(fullfile(stRootPath,'local','BIDS-examples','fw_test'));
data.projectLabel = 'BIDSUp';
groupLabel = 'Wandell Lab'; project = st.bidsUpload(data,groupLabel);

[s,id] = st.exist('project',data.projectLabel);
if s, st.deleteContainer('project',id); end

%% The next case to check
%
%   bidsDir = fullfile(stRootPath,'local','BIDS-Examples','7t_trt');
%   b = bids(bidsDir);
%   st.bidsUpload(@bids,'project label',projectLabel);
%   st.bidsDownload(projectLabel)
%
% Wandell, Scitran Team, 2017

%%

