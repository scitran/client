%% Script to save JSON toolbox files
%
% The examples below make individual toolbox JSON files.
% 
% To make a JSON file defining multiple toolboxes do this:
%
%   tbx = toolboxes();             % Empty object
%   tbx.read('isetbio.json');      % Load the individual toolboxes
%   tbx.read('jsonio.json');
%   tbx.saveinfo('filename','toolboxes');  % Save with desired filename
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
tbx.names{1}        = 'isetbio';
tbx.testcmd{1}      = 'isetbioRootPath';
tbx.getcmd{1}       = 'git clone https://github.com/isetbio/isetbio';
tbx.tbxdirectory{1} = 'isetbio';
tbx.saveinfo;

%%
tbx.names{1}        = 'Rorie2010';
tbx.testcmd{1}      = 'Rorie2010RootPath';
tbx.getcmd{1}       = 'git clone https://github.com/vistalab/Newsome--Rorie-2010-PLoSone';
tbx.tbxdirectory{1} = 'Rorie2010';
tbx.saveinfo;

%%
tbx.names{1}        = 'Kiani2014';
tbx.testcmd{1}      = 'Kiani2014RootPath';
tbx.getcmd{1}       = 'git clone https://github.com/vistalab/Newsome--Kiani-2014-CurrentBiology';
tbx.tbxdirectory{1} = 'Kiani2014';
tbx.saveinfo;

%%  ALDIT

tbx = toolboxes();             % Empty object
tbx.read('vistasoft.json');      % Load the individual toolboxes
tbx.read('dtiError.json');
tbx.saveinfo('filename','aldit-toolboxes');  % Save with desired filename



