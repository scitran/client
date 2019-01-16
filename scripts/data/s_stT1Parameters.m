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


%%
project = st.lookup('wandell/Weston Havens');

% How do we find all the T1 nifti files in here?  A search?
fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'acquisition label contains','T1w',...
    'summary', true,'fw',false);

thisFile = fileList{1};
thisFile.info.fslhd.descrip



%% How do we find all the T1 nifti files in here?  A search?
fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'measurement','T1',...
    'summary', true);
fa = zeros(length(fileList),1);
for ii=1:numel(fileList)
    try
        fa(ii) = fileList{ii}.info.fslhd.descrip.fa;
    catch
        fa(ii) = NaN;
    end
    
end
stNewGraphWin; histogram(fa)

%%  These are localizers
fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'measurement','T2',...
    'fw',true, ...
    'summary', true);

te = zeros(length(fileList),1);
for ii=1:numel(fileList)
    try
        te(ii) = fileList{ii}.info.fslhd.descrip.te;
    catch
        te(ii) = NaN;
    end
end
stNewGraphWin; histogram(te)

%%  Find all the scans that are intended to be structural
fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'intent','structural',...
    'fw',false, ...
    'summary', true);
%%

fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'intent','structural',...
    'measurement','T1',...
    'fw',false, ...
    'summary', true);

%%
project = st.lookup('wandell/VWFA FOV');

fileList =  st.search('file','file type','dicom',...
    'project label exact',project.label,...
    'intent','structural',...
    'measurement','T1',...
    'fw',true, ...
    'summary', true);

for ii=1:numel(fileList)
    try
        te(ii) = fileList{ii}.info.EchoTime;
    catch
        te(ii) = NaN;
    end
end
stNewGraphWin; histogram(te,100); xlabel('Echo Time (ms)');

%%

session  = project.sessions.findFirst();
session.acquisitions.findFirst();

%% Experiments with the CNI site

cni = scitran('cni');

%%
