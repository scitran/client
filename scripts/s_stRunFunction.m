%% Illustrate st.runFunction
%
% This script uses the scitran.runFunction() with data in a Flywheel site.
% It illustrates how we use toolboxes to interact with the github
% repository containing Matlab toolboxes.
%
% These are all designed to run on the vistalab site for wandell.  They may
% serve as a model for future developments by Flywheel.
%
% BW, Vistasoft Team, 2017

% TODO - Fix these comments and modernize the scripts.
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


%% Open scitran
st = scitran('vistalab');

%% ECoG from DH

mFile = 'ecog_RenderElectrodes.m';
[s,id] = st.exist('project','SOC ECoG (Hermes)');
if s, st.runFunction(mFile,'container type','project','container ID',id);
else, error('Could not find project');
end
 
%% ALDIT example including toolbox testing and sending params

tbx = st.getToolbox('aldit-toolboxes.json','project name','ALDIT');
st.toolboxValidate(tbx,'verbose',true);

mFile = 'dtiErrorALDIT.m';
[s,id] = st.exist('project','ALDIT');

if s
    clear params
    params.project = 'ALDIT';
    params.session = 'Set 1';
    [~,RMSE1] = st.runFunction(mFile,...
        'container type','project',...
        'container ID',id,...
        'params',params);
else
    error('Could not find project ALDIT');
end
disp(RMSE1)

%% Run the function on Data Set 1

params.session = 'Set 2';

[~,RMSE2] = st.runFunction(mFile,...
    'container type','project',...
    'container ID',id,...
    'params',params);
disp(RMSE2)

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