%% Find all the sessions that contain a particular type of acquisition
%
% This finds all the sessions in a particular project.
%
%
% BW, Vistasoft, 2018
%
% See also
%

%%  Setup

st = scitran('stanfordlabs');
status  = st.verify;

%%  Find acquisitions from SVIP Release with dti 30 direction data

projectname = 'SVIP Released';
acquisitionlabel = 'DTI_30dir';
acq = st.search('acquisitions',...
    'project label contains',projectname,...
    'acquisition label exact',acquisitionlabel,...
    'summary',true);
    
fprintf('Found %d acquisitions in project "%s" with label "%s".\n',...
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
