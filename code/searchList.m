%% Examples from wiki page for testing
%
% Examples of using list and search

%% Create scitran object
st = scitran('stanfordlabs');
st.verify;

%% Examples of list
projects     = st.list('project','wandell');
sessions     = st.list('session',idGet(projects{5}));     % Pick one ....
acquisitions = st.list('acquisition',idGet(sessions{1})); 
files        = st.list('file',idGet(acquisitions{1})); 

%% Examples of search

projects = st.search('project');

vwfaProject = st.search('project',...
    'project label exact','VWFA');

vwfaSessions = st.search('session',...
    'project label exact','VWFA');

project = st.search('project',...
    'project label contains','vwfa');

projects = st.search('project','allData',true,'summary',true);

%%