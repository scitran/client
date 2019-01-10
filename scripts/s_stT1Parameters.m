st = scitran('stanfordlabs');
projects = st.list('project','wandell');
stPrint(projects,'label')

project = st.fw.lookup('adni/ADNI: DWI (AD)');
project = st.fw.lookup('adni/ADNI: T1');

% How do we find all the T1 nifti files in here?  A search?
fileList =  st.search('file','file type','nifti',...
    'project label contains','T1',...
    'acquisition label contains','T1',...
    'summary', true);

st.fw.lookup(
id = st.objectParse(fileList{1});
thisFile = st.list('file',fileList{1}.parent.id)
stSelect(thisFile,'type','nifti')
niftiFiles{1}.info
