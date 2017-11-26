%% Illustrate st.runFunction
%
% This script illustrates how to use the scitran.runFunction() with data in
% a Flywheel site.  To use this script, the toolbox.json file and the
% script should be uploaded to the project (Annotation).
%
% The active part of this script performs a dtiErrorALDIT analysis on the
% remote diffusion data.
%
% A second example is included in the comments at the end. That example is
% for EJ Apricot retinal data and requires the ISETBIO toolbox.  It runs,
% but is not a good demo because ISETBIO is large.
%
% The functions (dtiErrorALDIT and fw_Apricot6) are in the scitran/examples
% directory and stored up on the Wandell lab Flywheel site.
%
% BW, Scitran Team, 2017

%% Open scitran
st = scitran('vistalab');

%% Set up the toolboxes

project = 'ALDIT';
st.toolbox('aldit-toolboxes.json','project',project);

%% Run the function on Data Set 1

clear params
params.project = 'ALDIT';
params.session = 'Test Site 1';

[~,RMSE1] = st.runFunction('dtiErrorALDIT.m','project',project,'params',params);

%% Data set 2

% Set additional parameters
params.session = 'Test Site 2';
params.wmPercentile = 80; params.nSamples = 500;
params.scatter = false; params.histogram = true;

[~,RMSE2] = st.runFunction('dtiErrorALDIT.m','project',project,'params',params);

%%


%% Another potential example - A single unit physiology example
% %
% % st = scitran('scitran', 'action', 'create');
% % 
% % project = 'EJ Apricot';
% % st.toolbox('project',project);  % toolboxes.json is the default file
% % 
% % %% Set the function parameters
% % 
% % % Set parameters and run
% clear params;
% params.fileSpikes = fileSpikes{1};
% params.cellNumber = 14;
% 
% st.runFunction('fw_Apricot6.m','project','EJ Apricot','params',params);
% 
% %% Change parameters to another cell
% 
% params.cellNumber = 7;
% st.runFunction('fw_Apricot6.m','project','EJ Apricot','params',params);

%%