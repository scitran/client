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
tbx.saveinfo;

%%

