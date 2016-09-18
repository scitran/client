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
srch.path = 'analyses/files';                  % Files within an analysis
srch.files.match.name = 'fa.csv';              % Result file
srch.projects.match.label = 'SVIP';            % Any of the Simons VIP data
srch.sessions.match.subject_0x2E_sex = 'male'; % Males

maleFiles = st.search(srch);
nMales = length(maleFiles);
fprintf('Found %d files\n',nMales);

%% Now switch to female subjects

srch.sessions.match.subject_0x2E_sex = 'female'; % Females

femaleFiles = st.search(srch);
nFemales = length(femaleFiles);
fprintf('Found %d files\n',nFemales);

%%  Download the files with the FA for the tracts

% Accumulate them and and save in a single file for analysis

tractNames = ...
    {'Left Thalamic Radiation','Right Thalamic Radiation','Left Corticospinal',...
    'Right Corticospinal','Left Cingulum Cingulate','Right Cingulum Cingulate',...
    'Left Cingulum Hippocampus','Right Cingulum Hippocampus','Callosum Forceps Major',...
    'Callosum Forceps Minor','Left IFOF','Right IFOF','Left ILF','Right ILF',...
    'Left SLF','Right SLF','Left Uncinate','Right Uncinate','Left Arcuate','Right Arcuate'};

nTracts = length(tractNames);

%%  Accumulate the tract profiles in a single, position x tract x subject

femaleTracts = zeros(100,nTracts,nFemales);

tic
for ii=1:nFemales
    st.get(femaleFiles{ii},'destination','female.csv');
    d = csvread('female.csv',1,0);
    femaleTracts(:,:,ii) = d;
end
toc

save femaleTracts

%%
stNewGraphWin; imagesc(nanmean(femaleTracts,3));

%%  Now for the males

maleTracts = zeros(100,nTracts,nMales);

tic
for ii=1:nMales
    st.get(maleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    maleTracts(:,:,ii) = d;
end
toc

save maleTracts

%%
stNewGraphWin; 
imagesc(nanmean(maleTracts,3));

%%
stNewGraphWin('format','upperleftbig');
for tt=1:nTracts
    subplot(4,5,tt)
    X = [1:100]'; Y = nanmean(maleTracts,3);
    flag = 0; E = nanstd(maleTracts,flag,3);
    errorbar(X,Y(:,tt)',E(:,tt)'/sqrt(nMales));
    
    Y = nanmean(femaleTracts,3);
    flag = 0; E = nanstd(femaleTracts,flag,3);
    hold on
    errorbar(X,Y(:,tt)',E(:,tt)'/sqrt(nFemales));
    pause(1);
    set(gca,'xlim',[0 100],'ylim',[0.2 0.8],'fontsize',12);
    title(sprintf('%s\n',tractNames{tt}),'fontsize',9);
end
legend({'Male','Female'})

%% Search restricted to age 

clear srch
srch.path = 'analyses/files';                  % Files within an analysis
srch.files.match.name = 'fa.csv';              % Result file
srch.projects.match.label = 'SVIP';            % Any of the Simons VIP data
srch.sessions.bool.must{1}.match.subject_0x2E_sex = 'male'; % Males
 
srch.sessions.bool.must{2}.range.subject_0x2E_age.gt = year2sec(10);
srch.sessions.bool.must{2}.range.subject_0x2E_age.lt = year2sec(25);
 
youngMaleFiles = st.search(srch);
fprintf('Younger males %d\n',length(youngMaleFiles));

srch.sessions.bool.must{2}.range.subject_0x2E_age.gt = year2sec(25);
srch.sessions.bool.must{2}.range.subject_0x2E_age.lt = year2sec(50);
 
oldMaleFiles = st.search(srch);
fprintf('Older males %d\n',length(oldMaleFiles));

%% Older and Younger males

oldMaleTracts = zeros(100,nTracts,length(oldMaleFiles));

tic
for ii=1:length(oldMaleFiles)
    st.get(oldMaleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    oldMaleTracts(:,:,ii) = d;
end
toc

save oldMaleTracts
%%
stNewGraphWin; 
imagesc(nanmean(oldMaleTracts,3));
%%
youngMaleTracts = zeros(100,nTracts,length(youngMaleFiles));

tic
for ii=1:length(youngMaleFiles)
    st.get(youngMaleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    youngMaleTracts(:,:,ii) = d;
end
toc

save youngMaleTracts

%%
stNewGraphWin; 
imagesc(nanmean(youngMaleTracts,3));
%%
%%
stNewGraphWin('format','upperleftbig');
for tt=1:nTracts
    subplot(4,5,tt)
    X = [1:100]'; Y = nanmean(youngMaleTracts,3);
    flag = 0; E = nanstd(youngMaleTracts,flag,3);
    errorbar(X,Y(:,tt)',E(:,tt)'/sqrt(length(youngMaleFiles)));
    
    Y = nanmean(oldMaleTracts,3);
    flag = 0; E = nanstd(oldMaleTracts,flag,3);
    hold on
    errorbar(X,Y(:,tt)',E(:,tt)'/sqrt(length(oldMaleFiles)));
    
    pause(1);
    set(gca,'xlim',[0 100],'ylim',[0.2 0.8],'fontsize',12);
    title(sprintf('%s\n',tractNames{tt}),'fontsize',9);
end
legend({'Young','Old'})

%%