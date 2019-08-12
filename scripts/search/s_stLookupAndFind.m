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
%  groupID/projectLabel/subjectLabel/sessionLabel/acquisitionLabel
% 

%% List all the subjects within a project

project = st.fw.lookup('wandell/VWFA FOV');
subjects = project.subjects();
sLabels = stPrint(subjects,'label');
fprintf('Number of subjects: %d\n',numel(unique(sLabels)));


%% Looking up subjects
subjects{37}.label
subjectsFull = st.fw.get(subjects{37}.id);

thisSubject = st.fw.lookup(fullfile('wandell/VWFA FOV',subjects{37}.label));

% Not quite equal because, well, Justin
isequal(subjectsFull,thisSubject)

%% 
thisSession = st.fw.lookup('wandell/VWFA FOV/jc/Whole Brain Anatomy');

%% Looking up session for this subject

session = st.fw.lookup('wandell/VWFA FOV/ex13642/20161001_1151');

%%