%% s_stDownloadAnalysis
%
%
%
% See also
%  s_stDownloadContainer

%%
st = scitran('stanfordlabs');
st.verify

%% This is a big freesurfer analysis

analysis = st.search('analysis',...
    'project label exact', 'Brain Beats',...
    'session label exact','20180319_1232', ...
    'summary',true);
id = idGet(analysis{1});

tarFileName2 = st.downloadContainer('analysis',id);
