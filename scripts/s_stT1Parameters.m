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
