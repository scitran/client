%% Illustrate st.runFunction
%
% Uses the EJ Apricot data to plot PSTH
% Illustrates setting the parameters to a function.
%
% BW, Scitran Team, 2017

%% Open scitran
st = scitran('action', 'create', 'instance', 'scitran');

% Could add toolboxes specification for the project
%
% toolboxFile = st.search('files',...
%     'project label','EJ Apricot',...
%     'file name','toolboxes.json',...
%     'summary',true);
% tbx = toolboxes(toolboxFile);
% tbx.install;

% Find the function
func = st.search('files','project label','EJ Apricot','filename','fw_Apricot6.m','summary',true);

%% Initialize the parameters
clear params;

% Find the spikes file
fileSpikes = st.search('files','project label','EJ Apricot','file name contains','spikes-1','summary',true);
params.fileSpikes  = fileSpikes{1};

% Pick a cell
params.cellNumber = 10;

%% Find and run the function, sending in the parameters
st.runFunction(func{1},'params',params);

%% Change to another cell
params.cellNumber = 7;
st.runFunction(func{1},'params',params);

%%