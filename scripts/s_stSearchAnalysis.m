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
    'project label contains','HCP',...
    'analysis label contains','afq',...
    'summary',true);
% stPrint(afqDemos,'analysis','label')

%% Here is the use of analysisGet

N = 7;

% We expect its functionality will grow
parameters     = st.analysisGet(afqDemos{N},'parameters');
disp(parameters)

fields = st.analysisGet(afqDemos{N},'parameter names')
clip2roi  = st.analysisGet(afqDemos{N},'clip2rois')

%% This works, too
thisAnalysis  = st.analysisGet(afqDemos{N},'all');


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
