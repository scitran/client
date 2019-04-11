%% s_stLookupAndFind
%
% Lookup and find examples
%
% Most common use is to quickly get an object inside a project. Faster than
% stepping through by listing the project, then the sessions, and so forth.
% Mostly good when you know what you want.
%
% Wandell, SCITRAN
%
% See also
%  

%% Open the object
st = scitran('stanfordlabs');
st.verify;

%% Format for lookup
%  group/project/session/acquisition
% 

%% List all the subjects within a project

project = st.fw.lookup('wandell/VWFA FOV');
subjects = project.subjects();
sLabels = stPrint(subjects,'label');
fprintf('Number of subjects: %d\n',numel(unique(sLabels)));
subjects{37}.label

%% Looking up subjects

thisSubject = st.fw.lookup('wandell/VWFA FOV/ex13414');

% This returns only the first one, even though there are several
% sessions with that name
thisSession = st.fw.lookup('wandell/VWFA FOV/jc/Whole Brain Anatomy');

%% Looking up session
session = st.fw.lookup('wandell/VWFA FOV/20161001_1151')

%% Looking up subject
subject = st.fw.lookup('wandell/VWFA FOV/20161001_1151')

%%