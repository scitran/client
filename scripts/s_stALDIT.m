%% Download the diffusion data for dtiError
%
% ALDIT Stanford data shared

st = scitran('action', 'create', 'instance', 'scitran');

%%
project = 'ALDIT: Stanford CNI';
subjectCode = '11671';

sessions = st.search('sessions',...
    'project label contains','ALDIT',...
    'file type','nifti',...
    'subject code','11671');
