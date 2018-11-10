%% Check that the database is running 
%
%  Opens up a browser to the site.
%  Prints to the screen a list of all the projects on the site
%
% LMP/BW Scitran Team, 2016

%% Check that the database is up

st = scitran('stanfordlabs');

st.browser;

%%  Print the project labels

projects = st.list('projects','all');
stPrint(projects,'label');

%%
