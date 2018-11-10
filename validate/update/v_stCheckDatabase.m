%% Check that the database is running 
%
% LMP/BW Scitran Team, 2016

%% Check that the database is up

st = scitran('stanfordlabs');

st.browser;

%%  Print the project labels

projects = st.list('projects','all');
stPrint(projects,'label');

%%
