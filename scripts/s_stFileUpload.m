%% Unit tests for fileUpload (and fileDelete)
%
%   put - puts a single file  (maybe this should be putFile).
%   deleteFile - deletes a single file
%
% LMP/BW Scitran Team, 2017

%%
st = scitran('stanfordlabs');

chdir(fullfile(stRootPath,'data'));
test.name = 'Test';
test.date = date;
jsonwrite('test.json',test);
%% Simple way to put a file onto a project

containerType = 'project';
containerID = st.projectID('VWFA');
st.fileUpload('test.json',containerType,containerID);

files = st.list('file',containerID, 'container type','project');
stPrint(files,'name','');

%% Delete the file from the project

file = fw.search('files',...
    'project label contains','SOC',...
    'file name','WLVernierAcuity.json');
% This should run
fw.deleteFile(file{1});

%% This should work when there is only one cell
fw.put(fullFilename,project);
pause(1);  % Needed to allow elastic search to index the new file

fw.deleteFile(file);

%% This alternative delete method should run, too.

fw.put(fullFilename,project);
pause(1);  % Needed to allow elastic search to index the new file

fw.deleteFile('WLVernierAcuity.json','containerType','projects','containerID',project{1}.id);

%% Now, try this with sessions and acquisitions

