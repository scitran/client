%% s_stDownloadAnalysis
%
%  IN PROGRESS.  Not sure what the correct SDK calls are.
%
% See also
%  s_stDownloadContainer

%%
st = scitran('stanfordlabs');
st.verify

%% This is a freesurfer analysis

analysis = st.search('analysis',...
    'project label exact', 'Brain Beats',...
    'session label exact','20180319_1232', ...
    'summary',true);

id = idGet(analysis{1},'data type','analysis');
analysisInfo = st.analysisInfoGet(id);

% We need to get this sort of thing into stPrint.

fNames = cellfun(@(f) {f.name}, analysisInfo.files);
% Evaluates f.name to each of the cells in analysisInfo.files
disp(fNames)

% This is how we find the the name that matches rh.white.obj
ismatch = cellfun( @(s) contains('rh.white.obj', s), fNames);
if sum(ismatch) == 1
    thisFile = fNames(ismatch);
else
    error('No match found');
end


destination = fullfile(stRootPath,'local',thisFile);
localFile = st.fw.downloadOutputFromAnalysis(id, thisFile, destination);


%%