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

%% Run a script on the ALDIT data - Data Set 1

% Default parameters
project = 'Diffusion Noise Analysis';

% Find the function
func = st.search('files',...
    'project label',project,...
    'filename','dtiErrorALDIT.m',...
    'summary',true);

clear params
params.project = 'Diffusion Noise Analysis';
params.session = 'Set 1';

st.runFunction(func{1},'params',params);

%% Data set 2

% Set additional parameters
params.project = 'Diffusion Noise Analysis';
params.session = 'Set 2';
params.wmPercentile = 80; params.nSamples = 500;
params.scatter = false; params.histogram = true;

st.runFunction(func{1},'params',params);

%% A single unit physiology example

% Find the function
func = st.search('files',...
    'project label','EJ Apricot',...
    'filename','fw_Apricot6.m',...
    'summary',true);

%% Set the function parameters

% Find the spikes file as a cell array
fileSpikes = st.search('files',...
    'project label','EJ Apricot',...
    'file name contains','spikes-1',...
    'summary',true);

% Set parameters and run
clear params;
params.fileSpikes = fileSpikes{1};
params.cellNumber = 14;

st.runFunction(func{1},'params',params);

%% Change parameters to another cell

params.cellNumber = 7;
st.runFunction(func{1},'params',params);

%%