%% Check that the database is running 
%
% LMP/BW Scitran Team, 2016

%% Check that the database is up

% It is possible to create, refresh, or revoke
st = scitran('action','create','instance','scitran');

%% Search for a project
%
clear srch
srch.path = 'projects';
srch.projects.match.label = 'Public Data';
projects = st.search(srch);

%% Open the browser to that project

st.browser(projects{1});

%%
