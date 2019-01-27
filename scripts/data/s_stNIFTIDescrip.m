%% Read NIfTI file parameters from the descrip field
%
%

%%
st = scitran('stanfordlabs');
%%
%{
group  = 'wandell';  
pLabel = 'Weston Havens';

group = 'adni';
pLabel = 'ADNI: DWI (AD)'; 

group = 'adni';
pLabel = 'ADNI: T1';
%}
str = fullfile(group,pLabel);
project = st.lookup(str);

%% How do we find all the T1 nifti files in the project?  
% This list includes all the qMRI data when Wetson Havens
% There are about 1072 files in the ADNI T1
% There are about 442 in the Weston Havens data
fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'measurement','T1',...
    'intent','structural',...
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
stNewGraphWin; plot(ti(:),fa(:),'bo');
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
