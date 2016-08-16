%% Utility searches
%
% Search for all the sessions in project Simons for which an AFQ has NOT
% been run 
%
% RF/BW Vistasoft Team 2016

% Get authorization to read from the database
st = scitran('action', 'create', 'instance', 'scitran');

% A place for temporary files.
chdir(fullfile(stRootPath,'local'));

%% Find analyses

clear srch
srch.path = 'sessions';
srch.projects.match.label = 'svip';
srch.sessions.match.analyses_0x2E_label = 'fsl-bet';

[s,~,cmd] = st.search(srch);

%%
st.browser(s{1})

%%  Find all the sessions with fsl-bet

clear srch
srch.path = 'sessions';
srch.sessions.match.analyses_0x2E_label = 'fsl-bet';

[s,~,cmd] = st.search(srch);


%%

clear srch
srch.path = 'sessions';
srch.sessions.match.analyses_0x2E_label = 'FSL';

[s,~,cmd] = st.search(srch);

%%
clear srch
srch.path = 'collections';
srch.collections.match.analyses_0x2E_label = 'FSL bet2 analysis';

[s,~,cmd] = st.search(srch);
