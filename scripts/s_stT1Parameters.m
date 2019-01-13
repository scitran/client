%% Read the T1 parameters
%
%

st = scitran('stanfordlabs');
projects = st.list('project','wandell');
stPrint(projects,'label')

project = st.fw.lookup('adni/ADNI: DWI (AD)');
project = st.fw.lookup('adni/ADNI: T1');
project = st.lookup('wandell/Weston Havens');

% How do we find all the T1 nifti files in here?  A search?
fileList =  st.search('file','file type','dicom',...
    'project label exact','Brain Beats',...
    'acquisition label contains','T1w',...
    'summary', true);

% What we would like to do is search for all the files that have a
% classification of Measurement: {'T1'} and Intent: {'Structural'}

id = st.objectParse(fileList{1});
thisFile = st.list('file',fileList{1}.parent.id);
stSelect(thisFile,'type','nifti')
niftiFiles{1}.info


%% Experiments with the CNI site

cni = scitran('cni');

%%
