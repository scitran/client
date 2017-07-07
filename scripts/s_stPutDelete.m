%% Unit tests for put and deleteFile
%
% put - puts a single file  (maybe this should be putFile).
% deleteFile - deletes a single file
% 
% We plan to write putFiles and deleteFiles
%
% LMP/BW Scitran Team, 2017

%%
fw = scitran('vistalab');
chdir(fullfile(stRootPath,'data'));

%% Simple way to put a file into a project

project = fw.search('projects','project label contains','SOC');
fullFilename = fullfile(pwd,'WLVernierAcuity.json');
fw.put(fullFilename,project);

%% Delete the file from the project

file = fw.search('files',...
    'project label contains','SOC',...
    'file name','WLVernierAcuity.json');
% This should run
fw.deleteFile(file{1});

%% This alternative delete method should run, too.

fw.put(fullFilename,project);

fw.deleteFile('WLVernierAcuity.json','containerType','projects','containerID',project{1}.id);

%% Now, try this with sessions and acquisitions

