%% Examples of how to search analyses 
%
% We search for analyses run by specific gears and with specific
% parameter configurations 
%
% We will add examples here, such as the analyses of a certain type that
% have a parameter set to a particular value
%
% Wandell, Vistasoft, August 25, 2018
%
% See also
%  s_stSearches.m


%% Open up the connection
st = scitran('stanfordlabs');
st.verify;

%% Analyses using the gear named afq-pipeline-3 in the HCP data

afqDemos = st.search('analysis',...
    'gear name','afq-pipeline-3',...
    'project label contains','HCP',...
    'summary',true);

%% Here is the use of analysisGet

N = 7;

% We expect its functionality will grow
c1     = st.analysisGet(afqDemos{N},'all');
fields = st.analysisGet(afqDemos{N},'list');
nStep  = st.analysisGet(afqDemos{N},'nStep');
disp(c1)

%% This works, too.
c2 = st.analysisGet(afqDemos{N}.analysis,'all');
disp(c2)

%% This works, too
id = st.objectParse(afqDemos{N}.analysis);
thisAnalysis  = st.fw.getAnalysis(id);
c3 = st.analysisGet(thisAnalysis,'all');
disp(c3)

%% You can also get the job, which is attached to the analysis

% The job is attached to the analysis and it contains the gear
% configuration information
thisJob = st.analysisGet(afqDemos{N},'job');
disp(thisJob)
disp(thisJob.config.config)

%% A lot of these failed

state = st.analysisGet(afqDemos{N},'state');
disp(state)

%%
