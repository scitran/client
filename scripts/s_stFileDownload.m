%% s_stFileDownload
%
% Download examples:
%    JSON file from a projects
%    Analysis output file
%
% See also
%  

%% Open up the scitran object

st = scitran('stanfordlabs');
st.verify;

%% Download and read a small JSON file

file  = st.search('file',...
    'project label exact','DEMO',...
    'filename','dtiError.json');
fName = st.fileDownload(file{1});
s = jsonread(fName);
disp(s)

% Clean up
delete(fName);

%% Download an obj file from the FreeSurfer recon -all analysis

analysis = st.search('analysis',...
    'project label exact', 'Brain Beats',...
    'session label exact','20180319_1232', ...
    'summary',true);

fprintf('** Analysis:\nlabel: %s\nid: %s\n', ...
    analysis{1}.analysis.label,analysis{1}.analysis.id);

% Readable way to get the analysis is
[parentID, containerType] = st.objectParse(analysis{1}.session);

%% This gets the information container of the analysis 

analysis = st.list('sessionanalyses',analysis{1}.analysis.id);

%%
thisAnalysis = st.list('analyses',analysis{1}.analysis.id);

%
stPrint(thisAnalysis,'label','');

%% Apparently, we need to have a destination for the file.
fName = fullfile(stRootPath,'local','lh.pial.obj');
st.fileDownload('lh.pial.obj',...
    'container id',id,...
    'container type','analysis', ...
    'destination',fName);

if exist(fName,'file'), fprintf('File downloaded to %s\n',fName); end

%%
fprintf('Deleting %s\n',fName)
delete(fName);

%%
