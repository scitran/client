%% s_stFindSession
%
%  Find and describe sessions and acquisitions 
%
% BW, Vistasoft, 2018
%
% See also
%   s_stSearches

%%  Setup

st = scitran('stanfordlabs');
status  = st.verify;

%% Full summary of a large project.  Listing is faster than searching.

%{
 % Equivalent
  label = 'VWFA';
  project = st.search('project','project label exact',label);
  projectID = idGet(project{1},'project')
%}
label = 'VWFA';
projectID = st.projectID(label);

sessions = st.list('session',projectID);

sessions{1}.id
acquisitions = st.list('acquisition',sessions{1}.id);

%%
projectname = 'SVIP Released';
acquisitionlabel = 'DTI_30dir';
file = st.search('file',...
    'project label contains',projectname,...
    'acquisition label exact',acquisitionlabel,...
    'file type','nifti');
 

%%  Find acquisitions from SVIP Release with dti 30 direction data

projectname = 'SVIP Released';
acquisitionlabel = 'DTI_30dir';
acq = st.search('acquisitions',...
    'project label contains',projectname,...
    'acquisition label exact',acquisitionlabel);
    
fprintf('Found %d session and %d acquisitions in project "%s" with label "%s".\n',...
    length(acq),projectname,acquisitionlabel);

%% Find the list of session labels for the DTI 30 acquisitions

% The acquisition struct has a session field, and the field has a label
sessionlabels = cell(length(acq),1);
for ii=1:length(acq)
    sessionlabels{ii} = acq{ii}.session.label;
end

% Find the unique session labels.
% ListB contains an index into the session that contains each of the
% acquisitions. 
[uniqueLabels,ListA,ListB] = unique(sessionlabels);

% These are the acquisitions that are in session idx.  
% We have one session with two acquisitions.  
for jj=1:length(uniqueLabels)  % For each of the unique labels
    idx = find(ListB == jj);   % Find how many acquisitions are in the session
    if length(idx) > 1
        fprintf('Session %s subject code %s has %d DTI_30dir acquistions\n',...
            acq{idx(1)}.session.label,acq{idx(1)}.subject.code,length(idx));
    end
end
