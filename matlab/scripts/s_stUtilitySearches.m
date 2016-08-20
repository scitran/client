%% Utility searches
%
% Search for all the sessions in project Simons for which an AFQ has NOT
% been run 
%
% RF/BW Vistasoft Team 2016

%% Get authorization to read from the database
st = scitran('action', 'create', 'instance', 'scitran');

% A place for temporary files.
chdir(fullfile(stRootPath,'local'));

%% How many total sessions in a project?

projectName = 'ENGAGE';

clear srch
srch.path = 'sessions';
srch.projects.match.label = projectName;
allSessions = st.search(srch);

% Which ones ran fsl-bet and which did not?
analysisName = 'fsl-bet';
srch.sessions.match.analyses_0x2E_label = analysisName;

analyzedSessions = st.search(srch);
fprintf('Found %d sessions out of %d with analysis: %s (project: %s)\n',...
    length(analyzedSessions),length(allSessions), analysisName,projectName);

%% Find the users who ran this analysis
fprintf('These were run by:\n\n');
for ii=1:length(analyzedS)
    analyses = analyzedSessions{ii}.source.analyses;
    for jj=1:length(analyses)
        fprintf('Analysis: %s \tUser:  %s\n',analyses{jj}.label,analyses{jj}.user);
    end
end

%% Look through the whole database for analyses using fsl-bet

clear srch
srch.path = 'sessions';
analysisName = 'fsl-bet';
srch.sessions.match.analyses_0x2E_label = analysisName;
analyzedSessions = st.search(srch,'all_data',true);

fprintf('Found %d sessions  analysis: %s (all data)\n',...
    length(analyzedSessions), analysisName);

fprintf('These sessions include an fsl-bet:\n\n');
for ii=1:length(analyzedSessions)
    fprintf('Session: %s\n----\n',analyzedSessions{ii}.source.label);
    analyses = analyzedSessions{ii}.source.analyses;
    for jj=1:length(analyses)
        fprintf('Analysis: %s \tUser:  %s\n',analyses{jj}.label,analyses{jj}.user);
    end
    fprintf('\n\n');
end

%% Find session in ENGAGE that have an Anatomy acquisition

projectName = 'ENGAGE';

clear srch
srch.path = 'sessions';
srch.projects.match.label = projectName;
% Which ones ran fsl-bet and which did not?
% analysisName = 'fsl-bet';
% srch.sessions.match.analyses_0x2E_label = analysisName;
measurement = 'Anatomy';
srch.acquisitions.match.measurement = measurement;

analyzedSessions = st.search(srch);

for ii=1:length(analyzedSessions)
    clear srch
    srch.path = 'analyses';
    srch.sessions.match.label = analyzedSessions{ii}.source.label;
    analyses = st.search(srch);
    if isempty(analyses)
        disp('Run fsl-bet')
    else
        disp('Checking if fsl-bet is an analysis')
    end
end


%% Find the collections that contain a certain analyses

clear srch
srch.path = 'collections/analyses';
srch.projects.match.label = projectName;
srch.sessions.match.analyses_0x2E_label = analysisName;
analyzedS = st.search(srch);

fprintf('%d instances of the analysis: %s were found\n',length(analyzedS),analysisName);
fprintf('These were run by:\n\n');
for ii=1:length(analyzedS)
    fprintf('User:  %s in collection: %s\n',analyzedS{ii}.source.user,analyzedS{ii}.source.container.label);
end

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
