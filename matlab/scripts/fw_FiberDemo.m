%% Illustrate fiber MNI_OBJ creation and viewing
%
%  1) Download an AFQ data set
%  2) Convert the fiber data in Matlab format to MNI_OBJ
%  3) Put the images somewhere back on Flywheel
%  4) Click and view
%

%% Path
% Vistasoft
% scitran/client 

%% Get an AFQ output with all the stuff in it

st = scitran('action','create','instance','scitran');

% This searches for the file named cortex in the project, subject, session
clear srch
srch.path = 'analyses/files';
srch.projects.match.label = 'Engage';
srch.sessions.match.label = '2016-02-28 17:24';
srch.files.bool.must(1).match.type = 'archive';
srch.files.bool.must(2).match.name = 'afq';
fileAFQ = st.search(srch);

dataPath = fullfile(stRootPath,'local',fileAFQ{1}.source.name);
afqPath  = fullfile(stRootPath,'local','afq');

st.get(fileAFQ{1},'destination',dataPath);

%% Unizip and load the fibers
system(sprintf('unzip %s -d %s',dataPath,afqPath))
chdir(afqPath);
d = dir('afq*'); chdir(d.name);
d = dir('dti*'); chdir(d.name);
cd('fibers');

d = dir('*_clean_*'); 
load(d.name);

%% Subsample the fibers
nGroups = length(fg);
subSample = 8;
for ii=1:nGroups
    keep = 1:subSample:length(fg(ii).fibers);
    fg(ii) = fgExtract(fg(ii),keep,'keep');
    fg(ii).colorRgb = colorSamples(ii);
end

%% Change the fiber colors

name = strrep(fg(1).name,' ','_');
name = fullfile(stRootPath,'local',[name,'.mni.obj']);
fg2MNIObj(fg(1),'fname',name,'overwrite',true);

%%
name = fullfile(stRootPath,'local','severalGroups.mni.obj');
fg2MNIObj(fg(1:3:end),'fname',name,'overwrite',true);

%%
name = fullfile(stRootPath,'local','allGroups.mni.obj');
fg2MNIObj(fg,'fname',name,'overwrite',true);

%%




