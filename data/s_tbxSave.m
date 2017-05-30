%% Script to save json files for toolboxes
% 
% s_tbxSave
%
% To make one json file describing multiple toolboxes do this
%   tbx = toolboxes({'dtiError','jsonio','vistasoft'});
%   tbx.saveinfo;
%
% BW Scitran team, 2017

%%
tbx = toolboxes;
chdir(fullfile(stRootPath,'data'));

%%
tbx.names{1}        = 'dtiError';
tbx.testcmd{1}      = 'dtiError';
tbx.getcmd{1}       = 'git clone https://github.com/scitran-apps/dtiError.git';
tbx.tbxdirectory{1} = 'dtiError';
tbx.saveinfo;

%%
tbx.names{1}        = 'vistasoft';
tbx.testcmd{1}      = 'vistaRootPath';
tbx.getcmd{1}       = 'git clone https://github.com/vistalab/vistasoft';
tbx.tbxdirectory{1} = 'vistasoft';
tbx.saveinfo;

%%
tbx.names{1}        = 'jsonio';
tbx.testcmd{1}      = 'jsonread';
tbx.getcmd{1}       = 'git clone https://github.com/gllmflndn/JSONio';
tbx.tbxdirectory{1} = 'jsonio';
tbx.saveinfo;

%%
tbx.names{1}        = 'scitranClient';
tbx.testcmd{1}      = 'stRootPath';
tbx.getcmd{1}       = 'git clone https://github.com/scitran/client';
tbx.tbxdirectory{1} = 'scitranClient';
tbx.saveinfo;

%%
