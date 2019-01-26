%% Read the T1 parameters
%
%

%%
st = scitran('stanfordlabs');

%%
%{
group  = 'wandell';  % 'adni'
pLabel = 'Weston Havens';
%}
%{
group = 'adni';
pLabel = 'ADNI: T1';
%}
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

% How do we find all the T1 nifti files with T1W in the label?  A search?
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

%% How do we find all the T1 nifti files in the project?  
% This list includes all the qMRI data when Weson Havens
% There are about 1072 files in the ADNI T1
% 
fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'measurement','T1',...
    'intent','structural',...
    'summary', true, ...
    'fw',false);

% st.search('file','intent','structural');

% Parameters 
% For Weston Havens we have a series of flip angles because of the qMRI
% data.
% For ADNI T1 ... there
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


%% How do we find all the T1 nifti files in the project?  
% This list includes all the qMRI data when Weson Havens
% There are about 1072 files in the ADNI T1
% 
fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'measurement','T1',...
    'summary', true, ...
    'fw',true);

% Parameters 
% For Weston Havens we have a series of flip angles because of the qMRI
% data.
% For ADNI T1 ... there
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

%%  Here are examples of DICOM files with a T1 measurement
%
% There appear to be a lot in the stanfordlabs instance. THere are 5484
% on January 28, 2019.
fileList =  st.search('file','file type','dicom',...
    'measurement','T1',...
    'fw',false, ...
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
