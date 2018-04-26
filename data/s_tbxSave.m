%% Write out JSON toolbox files and upload to Flywheel
%
% The examples below make individual toolboxes, combine them, save the
% combined information, and then upload to Flywheel.
% 
% To read a JSON file defining one or more toolboxes use:
%
%   tbx = stToolbox('test.json');
%
% BW Vistasoft team, 2017
%
% See also: stToolbox, scitran.toolbox, scitran.toolboxGet

%%
tbx = toolboxes('');
chdir(fullfile(stRootPath,'data'));

%%
tbx.testcmd     = 'dtiError';
tbx.gitrepo.user    = 'scitran-apps'; 
tbx.gitrepo.project = 'dti-error'; 
tbxWrite('dti-error.json',tbx);

%%
tbx.testcmd     = 'vistaRootPath';
tbx.gitrepo.user    = 'vistalab'; % https://github.com/vistalab/vistasoft
tbx.gitrepo.project = 'vistasoft'; % https://github.com/vistalab/vistasoft
tbx.saveinfo;

%%
tbx.testcmd      = 'jsonread';
tbx.gitrepo.user    = 'gllmflndn'; 
tbx.gitrepo.project = 'JSONio'; 
tbx.saveinfo;

%%
tbx.testcmd      = 'stRootPath';
tbx.gitrepo.user    = 'scitran'; 
tbx.gitrepo.project = 'client';
tbx.saveinfo;

%%
tbx.testcmd      = 'isetbioRootPath';
tbx.gitrepo.user    = 'isetbio'; 
tbx.gitrepo.project = 'isetbio';
tbx.saveinfo;

%%
tbx.testcmd         = 'wlvRootPath';
tbx.gitrepo.user    = 'isetbio';
tbx.gitrepo.project = 'WLVernierAcuity';
tbx.saveinfo;

%%
tbx.testcmd      = 'Rorie2010RootPath';
tbx.gitrepo.user    = 'vistalab'; 
tbx.gitrepo.project = 'pof_Rorie2010';
tbx.saveinfo;

%%
tbx.testcmd      = 'Kiani2014RootPath';
tbx.gitrepo.user    = 'vistalab'; 
tbx.gitrepo.project = 'pof_Kiani2014';
tbx.saveinfo;

%% ECoG From DH
tbx.testcmd      = 'ecogRootPath';
tbx.gitrepo.user    = 'dorahermes'; 
tbx.gitrepo.project = 'ecogBasicCode';
tbx.gitrepo.commit  = 'master';
tbx.saveinfo;

%%
st = scitran('stanfordlabs');
chdir(fullfile(stRootPath,'data'));

%% These cases all create a couple of toolboxes and uploads to Flywheel

%  The example saves multiple toolboxes in a single toolboxes.json file and
%  then puts that file in the projects slot on a Flywheel instance.
%
clear tbx
tbx(1) = stToolbox('ecogBasicCode.json');
tbx(2) = stToolbox('vistasoft.json');
tbxWrite('SOC-ECoG-toolboxes.json',tbx);
tbx = stToolbox('SOC-ECoG-toolboxes.json');

% Put the toolboxes file into the project as an attachment
project = st.search('projects','project label exact','SOC ECoG (Hermes)');
st.upload('SOC-ECoG-toolboxes.json','project',idGet(project));

%% Now, save and put the paper of the future example (Rorie, 2010)
%  This saves multiple toolboxes in a single toolboxes.json file and
%  then puts that file in the projects slot on a Flywheel instance.
%
clear tbx
tbx(1) = stToolbox('pof_Rorie2010.json');
tbxWrite('rorie2010Figures.json',tbx);
tbx = stToolbox('rorie2010Figures.json');

% Put the toolboxes file into the project as an attachment
project = st.search('projects','project label contains','Rorie PLoS One 2010');
st.upload('rorie2010Figures.json','project',idGet(project));

%% fw_Apricot6
clear tbx
tbx(1) = stToolbox('isetbio.json');
tbxWrite('fw_Apricot6.json',tbx);
tbx = stToolbox('fw_Apricot6.json');

% Put the toolboxes file into the project as an attachment
project = st.search('projects','project label contains','EJ Apricot');
st.upload('fw_Apricot6.json','project',idGet(project));

%% ALDIT

clear tbx
tbx(1) = stToolbox('dtiError.json');
tbx(2) = stToolbox('vistasoft.json');
tbxWrite('aldit-toolboxes.json',tbx);
tbx = stToolbox('aldit-toolboxes.json');

% Now upload it
project = st.search('project','project label exact','ALDIT');
st.upload('aldit-toolboxes.json','project',project{1}.project.x_id);

%%
