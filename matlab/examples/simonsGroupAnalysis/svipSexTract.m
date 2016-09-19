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

%% Initialize for tracts

% Download the files with the FA for the tracts
% Accumulate them and and save in a single file for analysis

tractNames = ...
    {'Left Thalamic Radiation','Right Thalamic Radiation','Left Corticospinal',...
    'Right Corticospinal','Left Cingulum Cingulate','Right Cingulum Cingulate',...
    'Left Cingulum Hippocampus','Right Cingulum Hippocampus','Callosum Forceps Major',...
    'Callosum Forceps Minor','Left IFOF','Right IFOF','Left ILF','Right ILF',...
    'Left SLF','Right SLF','Left Uncinate','Right Uncinate','Left Arcuate','Right Arcuate'};

nTracts = length(tractNames);

%% Run the Flywheel searches

% We are looking for files that 
%   * File:  is part of the AFQ analysis output
%   * File:  string ends in csv
%   * Project: part of the Simons VIP project
%   * Subject: is male

clear srch
srch.path = 'analyses/files';                  % Files within an analysis
srch.files.match.name = 'fa.csv';              % Result file
srch.projects.match.label = 'SVIP';            % Any of the Simons VIP data

% Male
srch.sessions.match.subject_0x2E_sex = 'male'; % Males
maleFiles = st.search(srch);
nMales = length(maleFiles);
fprintf('Found %d files\n',nMales);

% Female
srch.sessions.match.subject_0x2E_sex = 'female'; % Females
femaleFiles = st.search(srch);
nFemales = length(femaleFiles);
fprintf('Found %d files\n',nFemales);

%%  Accumulate the tract profiles in a single, position x tract x subject

femaleTracts = zeros(100,nTracts,nFemales);
wbar = waitbar(0,'Downloading');
for ii=1:nFemales
    wbar = waitbar(ii/nFemales,wbar,'Downloading');
    st.get(femaleFiles{ii},'destination','female.csv');
    d = csvread('female.csv',1,0);
    femaleTracts(:,:,ii) = d;
end
delete(wbar);

save femaleTracts

%%
% stNewGraphWin; imagesc(nanmean(femaleTracts,3)); colorbar;

%%  Now for the males

maleTracts = zeros(100,nTracts,nMales);

wbar = waitbar(0,'Downloading');
for ii=1:nMales
    wbar = waitbar(ii/nMales,wbar,'Downloading');
    st.get(maleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    maleTracts(:,:,ii) = d;
end
delete(wbar);

save maleTracts

%%
% stNewGraphWin; 
% imagesc(nanmean(maleTracts,3)); colorbar;

%%  Graphs

stNewGraphWin('format','upper left big');
for tt=1:nTracts
    subplot(4,5,tt)
    X = [1:100]'; Y = nanmean(maleTracts,3);
    flag = 0; E = nanstd(maleTracts,flag,3);
    errorbar(X,Y(:,tt)',E(:,tt)'/sqrt(nMales));
    
    Y = nanmean(femaleTracts,3);
    flag = 0; E = nanstd(femaleTracts,flag,3);
    hold on
    errorbar(X,Y(:,tt)',E(:,tt)'/sqrt(nFemales));
    set(gca,'xlim',[0 100],'ylim',[0.2 0.8],'fontsize',12);
    title(sprintf('%s\n',tractNames{tt}),'fontsize',9);
    
    if ~mod(tt-1,5), ylabel('FA'); end
end
xlabel('Tract position')
legend({'Male','Female'})

%%