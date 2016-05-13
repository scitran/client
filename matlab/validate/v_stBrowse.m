%% Check that the database is running 
%
% LMP/BW Scitran Team, 2016

%% Check that the database is up

% It is possible to create, refresh, or revoke
st = scitran('action','create','instance','scitran');

%%
clear srch
srch.path = 'projects';
srch.projects.match.label = 'Public Data';
projects = st.search(srch);

%
st.browser(projects{1});

%%
