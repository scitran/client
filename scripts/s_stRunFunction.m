%% Illustrate st.runFunction
%
% Two examples are included.
%
% First, we perform a dtiErrorALDIT analysis on the diffusion data.
% Second, we plot some retinal spiking PSTH from EJ (Apricot).
%
% Both examples shopw how to set the parameters to a function.
%
% The functions themselves are in the scitran/examples directory.
%
% BW, Scitran Team, 2017

%% Open scitran
st = scitran('action', 'create', 'instance', 'scitran');

%% Set up the toolboxes

project = 'Diffusion Noise Analysis';
st.toolbox('project',project,'file','toolboxes.json');

%% Run the function on Data Set 1

clear params
params.project = 'Diffusion Noise Analysis';
params.session = 'Set 1';

st.runFunction('dtiErrorALDIT.m','project',project,'params',params);

%% Data set 2

% Set additional parameters
params.session = 'Set 2';
params.wmPercentile = 80; params.nSamples = 500;
params.scatter = false; params.histogram = true;

st.runFunction('dtiErrorALDIT.m','project',project,'params',params);

%% A single unit physiology example
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