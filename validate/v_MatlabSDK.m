%% Matlab SDK - validation tests based on testDrive
%
% These are for vistalab site
%
% BW, Scitran Team, 2017


%%
fw = scitran('vistalab');
fw.verify

%% List projects

projects = fw.search('project');
stPrint(projects,'project','label');

% stPrint(projects,'group','label');

%% Read data from a file
%
files = fw.search('file','project label exact','ADNI: T1',...
    'acquisition label contains','T1_MR_MPRAGE',...
    'subject code',4256, ...
    'filetype','nifti',...
    'summary',true);

nii = fw.read(files{1});

%%