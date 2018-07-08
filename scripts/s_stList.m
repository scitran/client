%% s_stList
%
% Illustrate the use of scitran.list
%
% Wandell, Vistasoft 2018
%
% See also
%   s_stSearches

%% Create the object

st = scitran('stanfordlabs');
st.verify;

%% List all the projects

projects = st.list('projects','all');
fprintf('There are %d projects in total\n\n',length(projects));
fprintf('On this site\n');
config = st.siteConfig;
disp(config.site);

%% List the projects in one group

group = 'wandell';
projects = st.list('projects',group);
fprintf('\n\n%d of these projects are from group "%s"\n',length(projects),group);
projectLabels = stPrint(projects,'label','');

%% Display the groups

groupLabels = st.list('groups',''); % There is no parent for the group
cellfun(@(x)(disp(x)),groupLabels);

%% List the sessions in a project
projects = st.list('projects','all');
sessions = st.list('sessions', idGet(projects{1}));
fprintf('There are %d sessions in the project %s\n',length(sessions),projects{1}.label);

%% Keep going

acquisitions = st.list('acquisitions',idGet(sessions{1}));
fprintf('There are %d acquisitions in the first session.\n',length(acquisitions));

%%