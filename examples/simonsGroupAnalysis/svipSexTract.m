%% Compare the tissue properties (FA) on 20 tracts
%
% We executed the AFQ Docker container on the Simons VIP data.  Here, we
% perform the following analysis.
%
%  1.  Search to find all the CSV files of AFQ
%  2.  Download these file and build a matrix of position x tract x subject 
%  3.  Do this for male and female subjects separately
%  4.  Plot and compare the male and female distributions on a single graph
%
% RF/BW PoST Team 2016

%% Open up the scitran client

% This has a permission that is hidden.  The user obtains this permission
% by logging in to the site and using the UI
st = scitran('scitran','action', 'create', 'instance');

%% Initialize tract names

tractNames = ...
    {'Left Thalamic Radiation','Right Thalamic Radiation','Left Corticospinal',...
    'Right Corticospinal','Left Cingulum Cingulate','Right Cingulum Cingulate',...
    'Left Cingulum Hippocampus','Right Cingulum Hippocampus','Callosum Forceps Major',...
    'Callosum Forceps Minor','Left IFOF','Right IFOF','Left ILF','Right ILF',...
    'Left SLF','Right SLF','Left Uncinate','Right Uncinate','Left Arcuate','Right Arcuate'};

nTracts = length(tractNames);

%% Run the Flywheel searches

% We are looking to return files that are part of the AFQ analysis output
% Conditions:
%   * File:  string ends in csv
%   * Project: part of the Simons VIP project

clear srch
srch.path = 'analyses/files';                  % Files within an analysis
srch.files.match.name = 'fa.csv';              % Result file
srch.projects.match.label = 'SVIP';            % Any of the Simons VIP data

% Male subjects
srch.sessions.match.subject_0x2E_sex = 'male'; % Males
maleFiles = st.search(srch);
nMales = length(maleFiles);
fprintf('Found %d files\n',nMales);

%% Female subjects
srch.sessions.match.subject_0x2E_sex = 'female'; % Females
femaleFiles = st.search(srch);
nFemales = length(femaleFiles);
fprintf('Found %d files\n',nFemales);

%% Accumulate the tract profiles in a single, position x tract x subject

% Males
maleTracts = zeros(100,nTracts,nMales);
str = sprintf('Downloading %d tracts',nTracts*nMales);
wbar = waitbar(0,str);
for ii=1:nMales
    wbar = waitbar(ii/nMales,wbar,str);
    st.get(maleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    maleTracts(:,:,ii) = d;
end
delete(wbar);
save maleTracts

% Females
femaleTracts = zeros(100,nTracts,nFemales);
str = sprintf('Downloading %d tracts',nTracts*nFemales);
wbar = waitbar(0,str);
for ii=1:nFemales
    wbar = waitbar(ii/nFemales,wbar,str);
    st.get(femaleFiles{ii},'destination','female.csv');
    d = csvread('female.csv',1,0);
    femaleTracts(:,:,ii) = d;
end
delete(wbar);
save femaleTracts

%%  Compare plots of tract profiles 

stNewGraphWin('format','upper left big');
for tt=1:nTracts
    subplot(4,5,tt)
    X = (1:100)'; Y = nanmean(maleTracts,3);
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