%% Download and read
% Wiki page examples
%

st = scitran('stanfordlabs');

%%
file = st.search('file','project label exact','DEMO','filename','dtiError.json');
fName = st.fileDownload(file{1});

d = jsonread(fName);
delete(fName);

%%
project = st.search('file','project label exact','DEMO');
idGet(project{1},'data type','project')
fName = st.fileDownload('dtiError.json',...
    'containerType','project','containerID',id, ...
    'destination',fullfile(pwd,'deleteme.json'));
d = jsonread(fName);
delete(fName);

%%
