%%  Compare the FA on an individual tract of different age groups
%
% Search for the AFQ fractional anisotropy files in male and female subjects
% Download the files and build a m atrix of position x tract x subject
% Plot and compare the male and female tract curves
%
% RF/BW PoST Team 2016

%% Open up the scitran client

st = scitran('vistalab');
chdir(fullfile(vistaRootPath,'local'));

%% Initialize tract names

% Longer versions.  Don't plot well.
% tractNames = ...
%     {'Left Thalamic Radiation','Right Thalamic Radiation','Left Corticospinal',...
%     'Right Corticospinal','Left Cingulum Cingulate','Right Cingulum Cingulate',...
%     'Left Cingulum Hippocampus','Right Cingulum Hippocampus','Callosum Forceps Major',...
%     'Callosum Forceps Minor','Left IFOF','Right IFOF','Left ILF','Right ILF',...
%     'Left SLF','Right SLF','Left Uncinate','Right Uncinate','Left Arcuate','Right Arcuate'};

tractNames = ...
    {'Left ThalRad','Right ThalRad','Left CST',...
    'Right CST','Left CC','Right CC',...
    'Left Cing Hipp','Right Cing Hipp','Forceps Major',...
    'Forceps Minor','Left IFOF','Right IFOF','Left ILF','Right ILF',...
    'Left SLF','Right SLF','Left Unc','Right Unc','Left Arc','Right Arc'};

%% Set up the search by age

youngMaleFiles = st.search('files in analysis',...
    'project label contains','SVIP Released Data',...
    'file name contains','fa.csv',...
    'subject sex','male', ...
    'subject age gt',year2sec(5),...
    'subject age lt',year2sec(15));
fprintf('Younger males %d\n',length(youngMaleFiles));

oldMaleFiles = st.search('files in analysis',...
    'project label contains','SVIP Released Data',...
    'file name contains','fa.csv',...
    'subject sex','male', ...
    'subject age gt',year2sec(35),...
    'subject age lt',year2sec(70));
fprintf('Older males %d\n',length(oldMaleFiles));

%% Download Older and Younger male data

oldMaleTracts = zeros(100,nTracts,length(oldMaleFiles));
wbar = waitbar(0,'Downloading');
for ii=1:length(oldMaleFiles)
    wbar = waitbar(ii/length(oldMaleFiles),wbar,'Downloading');
    st.get(oldMaleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    oldMaleTracts(:,:,ii) = d;
end
delete(wbar)

youngMaleTracts = zeros(100,nTracts,length(youngMaleFiles));
wbar = waitbar(0,'Downloading');
for ii=1:length(youngMaleFiles)
    wbar = waitbar(ii/length(youngMaleFiles),wbar,'Downloading');
    st.get(youngMaleFiles{ii},'destination','male.csv');
    d = csvread('male.csv',1,0);
    youngMaleTracts(:,:,ii) = d;
end
delete(wbar)

%% Optional save

save('oldMaleTracts',oldMaleTracts);
save('youngMaleTracts',youngMaleTracts);

%% Compare young and old in a plot

figure;
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