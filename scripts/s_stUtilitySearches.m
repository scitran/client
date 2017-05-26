%% Utility searches
%
% These are things we might want to build up into utility functions for
% scitran client.
%
% TO BE CHECKED.  May not be updated for JSONio properly.  Definitely not
% updated for the simpler search syntas.
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

allSessions = st.search('sessions',...
    'project label','ENGAGE');

fprintf('ENGAGE contains %d sessions\n',length(allSessions));

%% How many of these had run fsl-bet?

fslBetSessions = st.search('sessions',...
    'project label','ENGAGE',...
    'session contains analysis','fsl-bet');

fprintf('Found %d sessions out of %d with fsl-bet\n',...
    length(fslBetSessions),length(allSessions));

%% Find the users who ran the fsl-bet analyses

% Could be a function

fprintf('These were run by:\n\n');
for ii=1:length(fslBetSessions)
    analyses = fslBetSessions{ii}.source.analyses;
    fprintf('Session %d - %s\n',ii,fslBetSessions{ii}.id);
    if isstruct(analyses)
        for jj=1:length(analyses)
            fprintf('\tAnalysis %d: %s \tUser:  %s\n',jj,analyses(jj).label,analyses(jj).user);
        end
    elseif iscell(analyses)
        for jj=1:length(analyses)
            fprintf('\tAnalysis %d: %s \tUser:  %s\n',jj,analyses{jj}.label,analyses{jj}.user);
        end
    end
end

%% Look through the whole database for analyses using fsl-bet

fslBetSessions = st.search('sessions',...
    'session contains analysis','fsl-bet',...
    'all_data',true);

fprintf('Found %d sessions with fsl-bet\n',...
    length(fslBetSessions));

%%


%% Find session in ENGAGE that have an Anatomy_t1w acquisition

sessions = st.search('sessions',...
    'file measurement','Anatomy_t1w',...
    'project label','ENGAGE',...
    'file type','nifti');
fprintf('%d sessions in ENGAGE have an anatomical T1w in nifti format\n',length(sessions));

%% Find the collections that contain a certain analyses

collections = st.search('collections',...
    'project label','ENGAGE',...
    'session contains analysis','fsl-bet');
fprintf('%d collections have such an analysis\n',length(collections));
for ii=1:length(collections)
    fprintf('\t%s\n',collections{ii}.source.label);
end

%% 
[analyses,srchS] = st.search('analyses in collection',...
    'collection label','ENGAGE');

%%
clear srch
srch.path = 'collections/analyses';
srch.projects.match.label = projectName;
srch.sessions.match.analyses0x2Elabel = analysisName;
analyzedS = st.search(srch);

fprintf('%d instances of the analysis: %s were found\n',length(analyzedS),analysisName);
fprintf('These were run by:\n\n');
for ii=1:length(analyzedS)
    fprintf('User:  %s in collection: %s\n',analyzedS{ii}.source.user,analyzedS{ii}.source.container.label);
end

%%  Find all the sessions with fsl-bet
sessions = st.search('sessions','session contains analysis label','fsl-bet');
fprintf('Found %d sessions with analysis including the label.\n',length(sessions))

%%
sessions = st.search('sessions','session contains analysis label','AFQ');
fprintf('Found %d sessions with analysis including AFQ in the label\n',length(sessions))

%%
