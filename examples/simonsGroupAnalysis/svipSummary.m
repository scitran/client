%% Summarize the sex and ages of the SVIP Released data set
%
% Subject age histogram
%
% BW/RF PoST Team, 2016

%% Open up the scitran client

st = scitran('scitran','action', 'create', 'instance');

%%  Find the sessions in the SVIP Released project

clear srch
srch.path = 'sessions';
srch.projects.match.label = 'SVIP Released';
sessions = st.search(srch);
fprintf('Number of sessions:  %d\n',length(sessions))

% Get the subject information from those sessions
subjects = stSubjectInfo(sessions);

% Specifically the ages
ages = stSubjectGet(subjects,'age');

% Summarize
fprintf('Total subjects %d  (unknown ages %d)\n',length(subjects),sum(ages==0));

%% Plot
stNewGraphWin('color',[0.8 0.8 0.8]); 
hist(ages,20); xlabel('Age in years'); ylabel('N subjects');
set(gca,'xlim',[0 100]);
title(sprintf('Project: %s',srch.projects.match.label));

sex = stSubjectGet(subjects,'sex');

fprintf('\n---------\n');
nMale    = sum(sex=='m');
nFemale  = sum(sex =='f');
nUnknown = sum(sex == 'u');
fprintf('%d Males\n%d Females\n%d Unknown\n',nMale,nFemale,nUnknown);
fprintf('---------\n');

%%