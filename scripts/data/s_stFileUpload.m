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

%% Delete the file

% QUESTION SENT TO JUSTIN.  I want to avoid having to
% send in the container type along with the container id all the time.
s = st.fileDelete(files{1}.name,'project',containerID);

%% Now, try this with sessions and acquisitions

