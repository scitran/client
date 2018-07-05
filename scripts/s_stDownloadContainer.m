%% s_stDownloadContainer
%
% Flywheel has a hierarchy of data containers.  The information about the
% container is retrieved with a 'getXXX' type SDK command.
%
% The container files can be downloaded using
% scitran.downloadContainer().  This script illustrates how to make
% such a call.
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

%% Download a session

session = st.search('session',...
    'project label exact', 'Brain Beats',...
    'session label exact','20180319_1232', ...
    'summary',true);

stPrint(session,'session','label');

% Readable way to get the analysis is
id = idGet(session{1},'data type','session');

tarFileName1 = st.downloadContainer('session',id);
  
%% Download an acquisition

acquisition = st.search('acquisition',...
    'project label contains','SOC',...
    'session label exact','stimuli');
id = idGet(acquisition{1});
tarFileName2 = st.downloadContainer('acquisition',id);

% delete(fName);

%% This is a big freesurfer analysis

analysis = st.search('analysis',...
    'project label exact', 'Brain Beats',...
    'session label exact','20180319_1232', ...
    'summary',true);
id = idGet(analysis{1});

tarFileName2 = st.downloadContainer('analysis',id);

