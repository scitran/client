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

project = st.fw.lookup('wandell/VWFA');
subjects = project.subjects();

sLabels = stPrint(subjects,'label');
fprintf('Number of subjects: %d\n',numel(unique(sLabels)));

%% Looking up subjects

% This returns only the first one, even though there are several
% sessions with that name
thisSession = st.fw.lookup('wandell/VWFA FOV/jc/Whole Brain Anatomy');

%% Looking up session
session = st.fw.lookup('wandell/VWFA FOV/20161001_1151')

%% Looking up subject
subject = st.fw.lookup('wandell/VWFA FOV/20161001_1151')

%
% Version SDK 2.0 will have a subject.update method and many related
% methods that extend Version 1.0
%
% This would give you all the sessions for this subject
% subject.session

%%