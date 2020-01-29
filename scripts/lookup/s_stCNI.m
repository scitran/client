%% Examples at the CNI with Hua
%

%% Open up the connection

st = scitran('cni');
st.verify

%% Find the project owned by the cni group

project = st.lookup('cni/scanner_comparison');

%% Show me the subjects in this project

subjects = project.subjects();
stPrint(subjects,'label');

thisSubject = stSelect(subjects,'label','phantomOrig','nocell',true);


%%  Find the sessions for UHP_phantom_3
sessions = thisSubject.sessions();
stPrint(sessions,'label')

acquisitions = sessions{5}.acquisitions();

destinationSession = sessions{4};
for ii=1:numel(acquisitions)
    stContainerMove(acquisitions{ii},destinationSession);
end


%%

