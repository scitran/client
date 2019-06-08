%% Scitran project reporting
%
%  Illustrates searching the Flywheel database from Matlab for subject
%  information in a particular project.  This code works for scitran
%  generally, though I prefer working with the Flywheel instance.
%
% BW/Scitran Team 2016

%% Authorization

% Open the scitran object
st = scitran('stanfordlabs');

%% Search for the subject information
myGroup      = st.lookup('simons');
projectLabel = 'SVIP Released Data (SIEMENS)';
SVIP = st.lookup(fullfile(myGroup.id,projectLabel)); 

% Find the sessions in the project
sessions = SVIP.sessions();
numel(sessions)

%% Get the subject information

subjects = stSubjectInfo(st,sessions);
sex = stPrint(subjects,'sex');
ages = stPrint(subjects,'age');

%% Print out the sex distribution
unknownSexSessions = find(sex == 'u');
if isempty(unknownSexSessions)
    fprintf('\n---------\n');
    fprintf('Sex coded in all sessions\n');
    fprintf('---------\n');
else
    fprintf('\n---------\n');
    fprintf('Sessions with unknown subject sex:  %d\n',unknownSexSessions);
    fprintf('---------\n');
end

nMale    = sum(cellfun( @(x)(isequal(x,'male')),sex));
nFemale  = sum(cellfun( @(x)(isequal(x,'female')),sex));
nUnknown = sum(cellfun( @(x)(isequal(x,'unknown')),sex));
fprintf('%d Males\n%d Females\n%d   Unknown\n',nMale,nFemale,nUnknown);

%% Summarize ages in a graph

% Ages don't seem to be coded here.  Check with LMP.
figure; hist(ages,20); 
xlabel('Age in years'); ylabel('N subjects');
set(gca,'xlim',[0 100]);
title(sprintf('Project: %s','SVIP'));

%%

