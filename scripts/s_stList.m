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
fprintf('There are %d projects in total\n',length(projects));

%% List the projects in one group

group = 'wandell';
projects = st.list('projects',group);
fprintf('%d of these projects are from group "%s"\n',length(projects),group);

%% List the project labels 

% projectLabels = cellfun(@(x)(x.label),projects,'UniformOutput',false);
projectLabels = stPrint(projects,'label','');

%% List the groups

st.list('groups')
