%% v_stSearch
%
%  Searches on the projects
%

%%
st = scitran('stanfordlabs');

% In this example, we use the structure 'srch' to store the search parameters.
% When we are satisfied with the parameters, we attach srch to the mean search
% structure, s, and then run the search command.

clear srch
srch.path = 'projects';
projects = st.search(srch);
fprintf('Found %d projects\n',length(projects))

%% 