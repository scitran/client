%% Find diffusion nifti, bvec and bval for M. Descoteaux
%

%%
st = scitran('stanfordlabs');
st.verify

%%

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

%%  
nFiles = numel(f);
fprintf('Returned %d files\n',nFiles);

outDir = fullfile(stRootPath,'local','descoteaux');
chdir(outDir);

