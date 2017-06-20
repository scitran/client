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
st = scitran('scitran','action', 'create');


%% Initialize tract names

tractNames = ...
    {'Left Thalamic Radiation','Right Thalamic Radiation','Left Corticospinal',...
    'Right Corticospinal','Left Cingulum Cingulate','Right Cingulum Cingulate',...
    'Left Cingulum Hippocampus','Right Cingulum Hippocampus','Callosum Forceps Major',...
    'Callosum Forceps Minor','Left IFOF','Right IFOF','Left ILF','Right ILF',...
    'Left SLF','Right SLF','Left Uncinate','Right Uncinate','Left Arcuate','Right Arcuate'};

nTracts = length(tractNames);

%% Set up the search by age

clear srch
srch.path = 'analyses/files';                  % Files within an analysis
srch.files.match.name = 'fa.csv';              % Result file
srch.projects.match.label = 'SVIP';            % Any of the Simons VIP data

% Young males
srch.sessions.bool.must{1}.match.subject_0x2E_sex = 'male'; % Males
srch.sessions.bool.must{2}.range.subject_0x2E_age.gt = year2sec(5);
srch.sessions.bool.must{2}.range.subject_0x2E_age.lt = year2sec(15);
youngMaleFiles = st.search(srch);
fprintf('Younger males %d\n',length(youngMaleFiles));

% Older males
srch.sessions.bool.must{2}.range.subject_0x2E_age.gt = year2sec(35);
srch.sessions.bool.must{2}.range.subject_0x2E_age.lt = year2sec(70);
oldMaleFiles = st.search(srch);
fprintf('Older males %d\n',length(oldMaleFiles));

%% Older and Younger males

oldMaleTracts = zeros(100,nTracts,length(oldMaleFiles));

wbar = waitbar(0,'Downloading');
for ii=1:length(oldMaleFiles)
    wbar = waitbar(ii/length(oldMaleFiles),wbar,'Downloading');
    st.get(oldMaleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    oldMaleTracts(:,:,ii) = d;
end
delete(wbar)

save oldMaleTracts
%%
% stNewGraphWin;
% imagesc(nanmean(oldMaleTracts,3));
%%
youngMaleTracts = zeros(100,nTracts,length(youngMaleFiles));

wbar = waitbar(0,'Downloading');

for ii=1:length(youngMaleFiles)
    wbar = waitbar(ii/length(youngMaleFiles),wbar,'Downloading');
    st.get(youngMaleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    youngMaleTracts(:,:,ii) = d;
end
delete(wbar)

save youngMaleTracts

%%
% stNewGraphWin;
% imagesc(nanmean(youngMaleTracts,3));

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
    
    set(gca,'xlim',[0 100],'ylim',[0.2 0.8],'fontsize',12);
    title(sprintf('%s\n',tractNames{tt}),'fontsize',9);
    if ~mod(tt-1,5), ylabel('FA'); end
    
end
xlabel('Tract position')
legend({'Young','Old'})

%%