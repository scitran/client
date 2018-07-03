%% s_stDownloadObject
%
% Test downloading projects, sessions, acquisitions, analyses, and
% collections
%
% See also - s_stDownloadFile

%%
st = scitran('stanfordlabs');
% st.verify

%% Download a small JSON file

file = st.search('file','project label exact','DEMO','filename','dtiError.json');
fName = st.downloadFile(file{1});

edit(fName)
delete(fName);

%% Download a set of files from the FreeSurfer reconall case
analysis = st.search('analysis',...
    'project label exact', 'Brain Beats', ...
    'session label exact','20180319_1232');
disp(analysis{1}.analysis.label)


disp(analysis{1}.analysis.id)
id = idGet(analysis{1},'data type','analysis');

% This contains a list of the files in the analysis.
thisAnalysis = st.fw.getAnalysis(id);
for ii=1:numel(thisAnalysis.files)
    fprintf('%d:  %s\n',ii,thisAnalysis.files{ii}.name);
end


st.fw.downloadOutputFromAnalysis(id,'lh.pial.obj');
