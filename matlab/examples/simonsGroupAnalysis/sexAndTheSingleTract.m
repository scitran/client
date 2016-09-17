%%  Compare the FA on an individual tract of different SVIP groups
%
%    1.  Search to find all the CSV files of AFQ for male subjects
%    2.  Pull out the FA tract profile of a particular tract
%    3.  Do the same for all female subjects in the SVIP data set
%    4.  Plot and compare the two distributions
%
% RF/BW PoST Team 2016

%% Open up the scitran client

% This has a permission that is hidden.  The user obtains this permission
% by logging in to the site and using the UI
st = scitran('action', 'create', 'instance', 'scitran');

%% Set up the search structure

% We are looking for files that 
%   * File:  is part of the AFQ analysis output
%   * File:  string ends in csv
%   * Project: part of the Simons VIP project
%   * Subject: is male

clear srch
srch.path = 'analyses/files';                % Files within an analysis
srch.files.match.name = 'fa.csv';            % Result file
srch.projects.match.label = 'SVIP';          % Any of the Simons VIP data
srch.sessions.match.subject_0x2E_sex = 'male'; % Males
maleFiles = st.search(srch);
fprintf('Found %d files\n',length(maleFiles));

%%
clear srch
srch.path = 'analyses/files';                % Files within an analysis
srch.files.match.name = 'fa.csv';            % Result file
srch.projects.match.label = 'SVIP';          % Any of the Simons VIP data
srch.sessions.match.subject_0x2E_sex = 'female'; % Males
femaleFiles = st.search(srch);
fprintf('Found %d files\n',length(femaleFiles));

%%  Download a tract and save it
% Replace the _ with spaces ...

tractNames = {'Left_Thalamic_Radiation','Right_Thalamic_Radiation','Left_Corticospinal',...
    'Right_Corticospinal','Left_Cingulum_Cingulate','Right_Cingulum_Cingulate',...
    'Left_Cingulum_Hippocampus','Right_Cingulum_Hippocampus','Callosum_Forceps_Major',...
    'Callosum_Forceps_Minor','Left_IFOF','Right_IFOF','Left_ILF','Right_ILF',...
    'Left_SLF','Right_SLF','Left_Uncinate','Right_Uncinate','Left_Arcuate','Right_Arcuate'};

%%

tt = 19;
nFemales = length(femaleFiles);
femaleLeftArcuate = zeros(100,nFemales);

tic
for ii=1:nFemales
    st.get(femaleFiles{ii},'destination','female.csv');
    d = csvread('female.csv',1,0);
    femaleLeftArcuate(:,ii) = d(:,tt);
end
toc

%
figure; 
plot(femaleLeftArcuate);
xlabel('Tract position'); ylabel('FA');

%%  Now for the males

tt = 19;
nMales = length(maleFiles);
maleLeftArcuate = zeros(100,nMales);

tic
for ii=1:nMales
    st.get(maleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    maleLeftArcuate(:,ii) = d(:,tt);
end
toc

figure; 
plot(maleLeftArcuate);
xlabel('Tract position'); ylabel('FA');

%%
figure;
plot(1:100,mean(maleLeftArcuate,2),'r-');
hold on
plot(1:100,mean(femaleLeftArcuate,2),'b-');
hold off







