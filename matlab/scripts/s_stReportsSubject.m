%% Scitran project searches
%
%

%%
close all

%% Authorization

% The auth returns a token and the url of the flywheel instance.  These are
% fixed as part of 's' throughout the examples, below.
st = scitran('action', 'create', 'instance', 'scitran');

%%  List all the projects

clear srch
srch.path = 'projects';
projects = st.search(srch);

nProjects = length(projects);
Project = (1:nProjects)';
Name = cell(nProjects,1);
for ii = 1:nProjects
    Name{ii} = projects{ii}.source.label;
end
T = table(Project,Name);
disp(T)

%% Characterize the subject ages

pp = 4;  % Pick project

clear srch
srch.path = 'sessions';
srch.projects.match.exact_label = Name{pp};
sessions = st.search(srch);
length(sessions)

subjects = stSubjectInfo(sessions);
ages = stSubjectGet(subjects,'age');

fprintf('Subjects with unknown ages %d\n',sum(ages==0));

figure; hist(ages,20); xlabel('Age in years'); ylabel('N subjects');
set(gca,'xlim',[0 100]);
title(sprintf('Project: %s',Name{pp}));

%% Characterize the sex distribution

sex = stSubjectGet(subjects,'sex');

fprintf('\n---------\n');
fprintf('Sessions with unknown subject sex:  %d\n',find(sex == 'u'));
fprintf('---------\n');

nMale    = sum(sex=='m');
nFemale  = sum(sex =='f');
nUnknown = sum(sex == 'u');
fprintf('%d Males\n%d Females\n%d Unknown\n',nMale,nFemale,nUnknown);

%%  Pick all the projects with an SVIP in the title

clear srch
srch.path = 'sessions';
srch.projects.match.label = 'SVIP';
sessions = st.search(srch);
length(sessions)

subjects = stSubjectInfo(sessions);
ages = stSubjectGet(subjects,'age');

fprintf('Subjects with unknown ages %d\n',sum(ages==0));

figure; hist(ages,20); xlabel('Age in years'); ylabel('N subjects');
set(gca,'xlim',[0 100]);
title(sprintf('Project: All SVIP data'));

sex = stSubjectGet(subjects,'sex');

fprintf('\n---------\n');
fprintf('Sessions with unknown subject sex:  %d\n',find(sex == 'u'));
fprintf('---------\n');

nMale    = sum(sex=='m');
nFemale  = sum(sex =='f');
nUnknown = sum(sex == 'u');
fprintf('%d Males\n%d Females\n%d Unknown\n',nMale,nFemale,nUnknown);

%%

