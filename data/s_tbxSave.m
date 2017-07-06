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
% BW Scitran team, 2017

%%
tbx = toolboxes;
chdir(fullfile(stRootPath,'data'));

%%
tbx.name         = 'dtiError';
tbx.testcmd      = 'dtiError';
tbx.getcmd       = 'clone';       %  https://github.com/scitran-apps/dtiError.git';
tbx.gitrepo.user    = 'scitran-apps'; 
tbx.gitrepo.project = 'dtiError'; 
tbx.saveinfo;

%%
tbx.name        = 'vistasoft';
tbx.testcmd     = 'vistaRootPath';
tbx.getcmd      = 'clone';
tbx.gitrepo.user    = 'vistalab'; % https://github.com/vistalab/vistasoft
tbx.gitrepo.project = 'vistasoft'; % https://github.com/vistalab/vistasoft

tbx.saveinfo;

%%
tbx.name         = 'jsonio';
tbx.testcmd      = 'jsonread';
tbx.getcmd       = 'clone'; %  https://github.com/gllmflndn/JSONio';
tbx.gitrepo.user    = 'gllmflndn'; 
tbx.gitrepo.project = 'JSONio'; 
tbx.saveinfo;

%%
tbx.name         = 'scitranClient';
tbx.testcmd      = 'stRootPath';
tbx.getcmd       = 'clone'; % git clone https://github.com/scitran/client';
tbx.gitrepo.user    = 'scitran'; 
tbx.gitrepo.project = 'client';
tbx.saveinfo;

%%
tbx.name         = 'isetbio';
tbx.testcmd      = 'isetbioRootPath';
tbx.getcmd       = 'clone';   % https://github.com/isetbio/isetbio';
tbx.gitrepo.user    = 'isetbio'; 
tbx.gitrepo.project = 'isetbio';

tbx.saveinfo;

%%
tbx.name         = 'Rorie2010';
tbx.testcmd      = 'Rorie2010RootPath';
tbx.getcmd       = 'clone'; % https://github.com/vistalab/pof_Rorie2010.git';
tbx.gitrepo.user    = 'vistalab'; 
tbx.gitrepo.project = 'pof_Rorie2010';
tbx.saveinfo;

%%
tbx.name         = 'Kiani2014';
tbx.testcmd      = 'Kiani2014RootPath';
tbx.getcmd       = 'clone'; % https://github.com/vistalab/pof_Kiani2014.git';
tbx.gitrepo.user    = 'vistalab'; 
tbx.gitrepo.project = 'pof_Kiani2014';
tbx.saveinfo;

%% ECoG From DH
tbx.name         = 'ecogHermes';
tbx.testcmd      = 'ecogRootPath';
tbx.getcmd       = 'clone'; % https://github.com/dorahermes/ecogBasicCode.git';
tbx.gitrepo.user    = 'dorahermes'; 
tbx.gitrepo.project = 'ecogBasicCode';
tbx.saveinfo;

%%

