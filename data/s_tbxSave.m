%% Script that saves json files for toolboxes
% 
% s_tbxSave
%
% BW Scitran team, 2017

%%
tbx = toolboxes;
chdir(fullfile(stRootPath,'data'));

%%
tbx.saveinfo('vistasoft',...
  'vistaRootPath', ...
  'git clone https://github.com/vistalab/vistasoft',...
  '/user/wandell/github');


tbx.saveinfo('jsonio',...
  'jsonread', ...
  'git clone https://github.com/gllmflndn/JSONio',...
  '/user/wandell/github');


tbx.saveinfo('scitran',...
  'stRootPath', ...
  'git clone https://github.com/scitran/client',...
  '/user/wandell/github');

%%

