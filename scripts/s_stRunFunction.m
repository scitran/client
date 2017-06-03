%% Illustrate st.runFunction
%
% Two examples are included.
%
% We perform a dtiErrorALDIT analysis on the diffusion data.
%
% A second example is shown, but commented out.  That one is for EJ
% Apricate retinal data and requires the ISETBIO toolbox.  It runs, but is
% not a good demo because ISETBIO is large.
%
% The functions are in the scitran/examples directory and stored up on the
% Wandell lab Flywheel site.
%
% BW, Scitran Team, 2017

%% Open scitran
st = scitran('action', 'create', 'instance', 'scitran');

%% Set up the toolboxes

project = 'ALDIT';
st.toolbox('project',project,'file','aldit-toolboxes.json');

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
% % st = scitran('action', 'create', 'instance', 'scitran');
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