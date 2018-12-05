%% Lookup and find examples
%
% Most common use is to quickly get an object inside a project.
% Faster than listing the project, then the sessions, and so forth.
% One line call rather than list, search, list, search ...  Mostly
% good when you know what you want.
%
% find - this has filtering and other fields.  we should review how we
% use find to replace the getXXX routines
%
% 

%% Open the object
st = scitran('stanfordlabs');
st.verify;

%% Format for lookup
%  group/project/session/acquisition
% 

%% Looking up subjects

% This returns only the first one, even though there are several
% sessions with that name
session = st.fw.lookup('wandell/VWFA FOV/Whole Brain Anatomy')

%% Looking up session
session = st.fw.lookup('wandell/VWFA FOV/20161001_1151')

%% Looking up subject
subject = st.fw.lookup('wandell/VWFA FOV/20161001_1151')

%
% This has a subject.update method
%

% This would give you all the sessions for this subject
% subject.session

%%