%% Find diffusion nifti, bvec and bval for M. Descoteaux
%
% These files were placed in a collection.  We find the files as flywheel
% objects and then download each of them into a scratch directory.
%
% LMP?  BW?

%% Initialize Flywheel
st = scitran('stanfordlabs');
st.verify

%% Find the files in the Descoteaux collection

f = st.search('files',...
    'collection label exact','Descoteaux',...
    'filetype','nifti',...
    'fw',true);

bvec = st.search('files',...
    'collection label exact','Descoteaux',...
    'filetype','bvec',...
    'fw',true);

bval = st.search('files',...
    'collection label exact','Descoteaux',...
    'filetype','bval',...
    'fw',true);

%%  How many files?  Where do they go?

nFiles = numel(f);
fprintf('Returned %d files\n',nFiles);

outDir = fullfile('/scratch','descoteaux');
if ~exist(outDir,'dir'), mkdir(outDir); end

chdir(outDir);

%%  Now, run the file download for all the files

for ii=1:nFiles
    
    % Create a subdirectory labeled by session name
    chdir(outDir)
    thisFile = f{ii}.name;
    s = strsplit(thisFile,'.'); thisSession = fullfile(outDir,s{1});
    if ~exist(thisSession,'dir'), mkdir(thisSession); end
    chdir(thisSession);
    
    dest = fullfile(pwd,thisFile);
    f{ii}.download(dest);
    
    thisBvec = bvec{ii}.name;
    dest = fullfile(pwd,thisBvec);
    bvec{ii}.download(dest);
    
    thisBval = bval{ii}.name;
    dest = fullfile(pwd,thisBval);
    bval{ii}.download(dest);
    
    fprintf('File %d\n',ii)

end

%% Then we zip each directory.

chdir(outDir)
dataDir = dir('*_1');
for ii=1:length(dataDir)
    zip([dataDir(ii).name,'.zip'],dataDir(ii).name);
end

%% Then on the computer we drag all the zip files up to Stanford Box

%%  We had to remove session 5327_14_1 because it is missing the bval.

bvecNames = stPrint(bvec,'name');
bvalNames = stPrint(bval,'name');
for ii=1:length(bvecNames), [~,bvecNames{ii}] = fileparts(bvecNames{ii}); end 
for ii=1:length(bvalNames), [~,bvalNames{ii}] = fileparts(bvalNames{ii}); end

out = cellfun(@(x)(~contains(x,bvalNames)),bvecNames);
bvecNames(out)

%%