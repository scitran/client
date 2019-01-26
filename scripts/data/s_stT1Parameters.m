%% Read the T1 parameters
%
%

%%
st = scitran('stanfordlabs');

%%
group  = 'wandell';  % 'adni'
pLabel = 'Weston Havens';
% 'adni/ADNI: DWI (AD)' or 'adni/ADNI: T1'
str = fullfile(group,pLabel);
project = st.lookup(str);

%% How do we find all the T1 nifti files in here?  A search?

%{
fileList =  st.search('file','file type','dicom',...
    'project label exact','Brain Beats',...
    'acquisition label contains','T1w',...
    'summary', true);

id = st.objectParse(fileList{1});
thisFile = st.list('file',fileList{1}.parent.id);
stSelect(thisFile,'type','nifti')
niftiFiles{1}.info
%}

% How do we find all the T1 nifti files in here?  A search?
fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'acquisition label contains','T1w',...
    'summary', true,...
    'fw',true);

%
fa = zeros(length(fileList),1);
ti = zeros(length(fileList),1);
for ii=1:length(fileList)
    fa(ii) = fileList{ii}.info.fslhd.descrip.fa;
    ti(ii) = fileList{ii}.info.fslhd.descrip.fa;
end


%% How do we find all the T1 nifti files in the project?  A search?

% What we would like to do is search for all the files that have a
% classification of Measurement: {'T1'} and Intent: {'Structural'}
% I should add other options, I suppose.

fileList =  st.search('file', ...
    'project label exact',project.label,...
    'measurement','T1',...
    'intent','structural',...
    'summary', true, ...
    'fw',false);

% st.search('file','intent','structural');

% Flip angles - These are for the qMRI methods
fa = zeros(length(fileList),1);
ti = zeros(length(fileList),1);
for ii=1:numel(fileList)
    try
        fa(ii) = fileList{ii}.info.fslhd.descrip.fa;
        ti(ii) = fileList{ii}.info.fslhd.descrip.ti;
    catch
        fa(ii) = NaN;
        ti(ii) = NaN;
    end
end
stNewGraphWin; histogram(fa)
stNewGraphWin; histogram(ti)
stNewGraphWin; plot(ti(:),fa(:),'o');
xlabel('TI'); ylabel('FA'); grid on

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
