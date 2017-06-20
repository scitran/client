%% s_stRorie2010
%
%  Install the toolbox for the Rorie2010 paper
%  Download the create figures function
%  Set the parameters and run with @scitran.runFunction.
%
%
% TODO:  Add a destination
%        Up to date?  Tag/checksum?
%        Name the destination as a full file path.

%% Open Flywheel and set project information

st = scitran('scitran','action','create');
project = 'Rorie PLoS One 2010';

baseDir = fullfile(stRootPath,'local');
chdir(baseDir);

%% 1. Run the Matlab function, which also gets the toolbox

% This script is written to include the st
params.subject = {'Tex'};
params.fig2 = false;
params.fig3 = true;
params.download = true;
params.scitran = st;
params.tbxFile = st.search('files',...
        'project label',project,...
        'filename','Rorie2010.json');
    
val = st.runFunction('rorie2010Figures.m',...
    'project',project,...
    'params',params);

chdir(baseDir);

%% 2. Alternatively, get the toolbox and run the local version of the function

tbxName = 'Rorie2010.json';
st.toolbox('project',project,'file',tbxName);

params.subject = {'Tex'};
params.fig2 = false;
params.fig3 = true;
params.download = false;
rorie2010Figures(params);

%% Download a zip file of the set of functions needed?




