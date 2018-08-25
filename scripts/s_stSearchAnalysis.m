%% Examples of how to search analyses 
%
% We are looking for analyses run by specific gears and with specific
% parameter configurations 
%
% We will add examples here, such as the analyses of a certain type that
% have a parameter set to a particular value
%
% Wandell, Vistasoft, August 25, 2018

%%
st = scitran('stanfordlabs');
st.verify;

%% Analyses using the gear named afq-pipeline-3 in the HCP data

afqDemos = st.search('analysis',...
    'gear name','afq-pipeline-3',...
    'project label contains','HCP',...
    'summary',true);

c1      = st.analysisGet(afqDemos{1},'all');
fields = st.analysisGet(afqDemos{1},'list');
nStep  = st.analysisGet(afqDemos{1},'nStep');
disp(c1)

%% This works, too.
c2      = st.analysisGet(afqDemos{1}.analysis,'all');
disp(c2)

%% This works, too
id = st.objectParse(afqDemos{1}.analysis);
thisAnalysis  = st.fw.getAnalysis(id);
c3      = st.analysisGet(thisAnalysis,'all');
disp(c3)

%% You can also get the job

thisJob = st.analysisGet(thisAnalysis,'job');
disp(thisJob)

%%
