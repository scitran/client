%% Script to save JSON toolbox files
%
% The examples below make individual toolbox JSON files.
% 
% To make a JSON file defining multiple toolboxes do this:
%
%   tbx = toolboxes();             % Empty object
%   tbx.read('isetbio.json');      % Load the individual toolboxes
%   tbx.read('jsonio.json');
%
%   tbx = toolboxes('file','jsonio.json');
%
% BW Scitran team, 2017

%%
tbx = toolboxes;
chdir(fullfile(stRootPath,'data'));

%%
tbx.testcmd      = 'dtiError';
tbx.gitrepo.user    = 'scitran-apps'; 
tbx.gitrepo.project = 'dtiError'; 
tbx.saveinfo;

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

%% Now, save and put an example toolbox for a project.
%  The example saves multiple toolboxes in a single toolboxes.json file and
%  then puts that file in the projects slot on a Flywheel instance.
%
chdir(fullfile(stRootPath,'data'));
tbx(1) = toolboxes('file','ecogBasicCode.json');
tbx(2) = toolboxes('file','vistasoft.json');
tbxWrite('toolboxes.json',tbx);

% Put the toolboxes file into the project as an attachment
fw = scitran('vistalab');
project = fw.search('projects','project label contains','SOC ECoG');
fw.put('toolboxes.json',project);

%% Now, save and put the paper of the future example (Rorie, 2010)
%  This saves multiple toolboxes in a single toolboxes.json file and
%  then puts that file in the projects slot on a Flywheel instance.
%
chdir(fullfile(stRootPath,'data'));
tbx(1) = toolboxes('file','pof_Rorie2010.json');
tbxWrite('rorie2010Figures.json',tbx);

% Put the toolboxes file into the project as an attachment
fw = scitran('vistalab');
project = fw.search('projects','project label contains','Rorie PLoS One 2010');
fw.put('rorie2010Figures.json',project);

%% fw_Apricot6
chdir(fullfile(stRootPath,'data'));
tbx(1) = toolboxes('file','isetbio.json');
tbxWrite('fw_Apricot6.json',tbx);

% Put the toolboxes file into the project as an attachment
fw = scitran('vistalab');
project = fw.search('projects','project label contains','EJ Apricot');
fw.put('fw_Apricot6.json',project);

