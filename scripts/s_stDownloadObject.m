%% s_stDownloadObject
%
% What does it mean to download an object?  The information about the
% object, or all the contents of the object?
%
% Download examples:
%   Acquisition
%   Session
%   Project
%   BIDS????s
% 
% See also
%   s_stDownloadFile

%% Open up the scitran object

st = scitran('stanfordlabs');
% st.verify

%% Download an session

session = st.search('session',...
    'project label exact', 'Brain Beats',...
    'session label exact','20180319_1232', ...
    'summary',true);

stPrint(session,'session','label');

% Readable way to get the analysis is
id = idGet(session{1},'data type','session');

tarFileName = st.downloadContainer('session',id);

%%
