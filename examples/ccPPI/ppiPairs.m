%% Run a PPI analysis on a good subject
% Get a good subject from the Williams/Flywheel database Pull down the 'Connect
% Preprocessing for PanLab pipeline data Pull out two sets of time series from
% two ROIs Implement/run the PPI calculation
%
% CC,BW Scitran Team, 2017


% This is how we made the list.
% Ultimately, we will get the list from the fw site.

% roiList = dir(fullfile(workDir,'pl_masks/*.nii'));
% roiNames = cell(length(roiList),1);
% roiShortNames = cell(length(roiList),1);
% for ii =1:length(roiList)
%     roiNames{ii} = roiList(ii).name;
%     splitName = regexp(roiNames(ii), '_', 'split');
%     roiShortNames{ii} = strcat(splitName{1}{1}, '_', splitName{1}{3});
% end
% idx = find(ismember(roiNames,roiName{2}));
%
% for ii = 1:length(roiNames)
%     fprintf('%d  %s\n',ii,roiNames{ii});
% end

% 1  Left_10mm_AG_DMN_FI_-46_-70_32_cluster.nii
% 2  Left_10mm_DLPFC_CogCon_FI_-44_22_24_cluster.nii
% 3  Left_10mm_aIPL_Attention_FI_-34_-42_48_cluster.nii
% 4  Left_10mm_amPFC_DMN_FI_-2_50_-6_cluster.nii
% 5  Left_10mm_antInsula_Attention_FI_-32_22_-2_cluster.nii
% 6  Left_10mm_antInsula_Salience_FI_-38_14_-6_cluster.nii
% 7  Left_10mm_antInsula_Threat_FI_-36_20_-4_cluster.nii
% 8  Left_10mm_dParietal_CogCon_FI_-32_-54_44_cluster.nii
% 9  Left_10mm_dmPFC_Threat_FI_-2_20_50_cluster.nii
% 10  Left_10mm_pACC_Threat_FI_-6_42_-4_cluster.nii
% 11  Left_10mm_precentral_CogCon_FI_-44_6_32_cluster.nii
% 12  Left_10mm_precuneus_Attention_FI_-14_-66_52_cluster.nii
% 13  Left_10mm_rACC_Reward_FI_-2_56_-8_cluster.nii
% 14  Left_10mm_vmPFC_Threat_FI_-2_42_-18_cluster.nii
% 15  Left_CMA_Anatomy_MNI_Salience_FI_cluster.nii
% 16  Left_FSL_vStriatum_Reward_FI_cluster.nii
% 17  Left_aal_Amygdala_Threat_FI_cluster.nii
% 18  Right_10mm_AG_DMN_FI_50_-62_26_cluster.nii
% 19  Right_10mm_DLPFC_CogCon_FI_44_34_22_cluster.nii
% 20  Right_10mm_aIPL_Attention_FI_44_-44_48_cluster.nii
% 21  Right_10mm_antInsula_Attention_FI_34_22_-2_cluster.nii
% 22  Right_10mm_antInsula_Salience_FI_38_18_2_cluster.nii
% 23  Right_10mm_antInsula_Threat_FI_38_22_-4_cluster.nii
% 24  Right_10mm_brainstem_Threat_FI_2_-26_-8_cluster.nii
% 25  Right_10mm_dACC_Reward_FI_6_34_18_cluster.nii
% 26  Right_10mm_dACC_Salience_FI_6_26_28_cluster.nii
% 27  Right_10mm_dACC_Threat_FI_2_28_24_cluster.nii
% 28  Right_10mm_dParietal_CogCon_FI_48_-46_44_cluster.nii
% 29  Right_10mm_msPFC_Attention_FI_6_16_48_cluster.nii
% 30  Right_10mm_precentral_CogCon_FI_46_10_32_cluster.nii
% 31  Right_10mm_precuneus_Attention_FI_12_-70_52_cluster.nii
% 32  Right_10mm_rACC_Reward_FI_2_46_-2_cluster.nii
% 33  Right_10mm_sgACC_Threat_FI_4_26_-10_cluster.nii
% 34  Right_10mm_vmPFC_Reward_FI_2_46_-16_cluster.nii
% 35  Right_CMA_Anatomy_MNI_Salience_FI_cluster.nii
% 36  Right_FSL_vStriatum_Reward_FI_cluster.nii
% 37  Right_aal_Amygdala_Threat_FI_cluster.nii
% 38  biLat_10mm_PCC_DMN_FI_0_-50_28_cluster.nii
% 39  biLat_10mm_dACC_CogCon_FI_0_18_46_cluster.nii

%% Two channels are better than one

fwVista = scitran('vistalab');   % Where I tucked the ROIs
fwCNI   = scitran('cni');        % Where ENGAGE lives

% Local space
workDir = fullfile(stRootPath,'local','ppi');
chdir(workDir);
%% Download data from one GoNoGO task at the CNI site

% The files we need are a go-no data files that are CSV
% The BOLD time series nifti
% We can make this a function with the key variables.

% Here is a good data set.  Why are there three sessions?
% [sessions, srch] = fwCNI.search('sessions',...
%     'project label','ENGAGE', ...
%     'subject code','MV09305');
%
% % Get pre-processed files from the first session with these names
% anCPGNG2 = fwCNI.search('analyses in session',...
%     'project label','ENGAGE', ...
%     'subject code','MV09305', ...
%     'session id',sessions{1}.id,...
%     'analysis label contains','connectivity-preprocessing (go-no-go 2)');
%
% anFLMGNG2 = fwCNI.search('analyses in session',...
%     'project label','ENGAGE', ...
%     'subject code','MV09305', ...
%     'session id',sessions{1}.id,...
%     'analysis label contains','first-level-models (go-no-go 2)');
%
% GoFile = fwCNI.search('files in analysis',...
%     'analysis id',anFLMGNG2{1}.id,...
%     'file name','Go_Onsets.csv');
% fw.get(GoFile{1},'destination',fullfile(workDir,'Go.csv'));
%
% NoGoFile = fwCNI.search('files in analysis', ...
%     'analysis id',anFLMGNG2{1}.id,...
%     'file name','NoGo_Onsets.csv');
% fw.get(NoGoFile{1},'destination',fullfile(workDir,'NoGo.csv'));
%
% warpedImage = fwCNI.search('files in analysis',...
%     'session id',sessions{1}.id,...
%     'analysis id',anCPGNG2{1}.id,...
%     'filename','warped_files@@wa01_normalized_func_data.nii.gz');
% fw.get(warpedImage{1},'destination',fullfile(workDir,'warpedImage.nii.gz'));

%% Download all the cogcon ROIs 

%  Cognitive controls ROIs are
cogcon = [2, 4, 8, 11, 19, 28, 30, 38, 39];
nROIs = length(cogcon);

for ii=1:nROIs
    file = fwVista.search('files',...
        'project label contains','Templates Adult',...
        'session label','PANLAB',...
        'filename',roiNames{cogcon(ii)});
    fwVista.get(file{1},'destination',fullfile(workDir,roiNames{cogcon(ii)}));
end

%% Get the data loaded

% This subject's pre-processed image
nii = niftiRead(fullfile(workDir,'warpedImage.nii.gz'));

TR = 2; % TR of the acquisition

% Fills in the HRF from the parameters
clear xBF;
% The hemodynamic response function types
xBF.name   = 'hrf'; % (with time derivative)';
xBF.dt     = TR;         % The TR of the acquisition
xBF.order  = 1;
xBF = spm_get_bf(xBF);
% newGraphWin; plot(xBF.bf); grid on

% Timing of the warped image data
nTime = size(nii.data,4);
TRTimes = 0:TR:(TR*(nTime-1));

%% Do all pairs of ROIs and make ppiScore


% Do 'em all
% nROIs = length(roiNames);
% cogcon = 1:length(roiNames);

ppiScores = zeros(nROIs,nROIs);

for r1 = 1:nROIs
    for r2 = 1:nROIs
        [r1,r2]
        
        roiName{1} = roiNames{cogcon(r1)}; 
        roiName{2} = roiNames{cogcon(r2)};
                
        % Read the brain responses
        clear roi
        roi{1} = niftiRead(fullfile(pwd,'pl_masks',roiName{1}));
        roi{2} = niftiRead(fullfile(pwd,'pl_masks',roiName{2}));
                
        roiTS = cell(1,2);
        for rr=1:2
            [i,j,k] = ind2sub(size(roi{rr}.data),find(roi{rr}.data == 1));
            nPts = length(i);
            roiTS{rr} = zeros(nTime,nPts);
            for ii=1:nPts
                roiTS{rr}(:,ii) = squeeze(nii.data(i(ii),j(ii),k(ii),:));
            end
        end
        
        %% Convert time series to percent modulation
        
        meanTSeries = zeros(nTime,nROIs);
        for rr = 1:2
            mn = mean(roiTS{rr},1);
            tSeries2 = bsxfun(@minus, roiTS{rr}, mn);
            tSeries2 = tSeries2*diag(1./mn);
            
            % Multiply by 100 to get percent
            tSeries2 = 100*tSeries2;
            meanTSeries(:,rr) = mean(tSeries2,2);
            
            % newGraphWin; plot(tSeries2); ylabel('Percent modulation'); xlabel('TR points')
        end
        
        %% Calculate the PPI between these two time series
        
        % Psychological vector
        
        
        % onset files are lists of stimulus onsets from beginning of nifti
        goOnsets = csvread(fullfile(workDir, 'Go.csv'), 1, 3);
        noGoOnsets = csvread(fullfile(workDir, 'NoGo.csv'), 1, 3);
        [tvals,idx] = sort([goOnsets; noGoOnsets]);
        val = [ones(size(goOnsets)); -1*ones(size(noGoOnsets))];
        val = val(idx);
        % plot(tvals,val,'-')
        
        % Interpolate to the TR sample spacing
        
        psych = interp1(tvals,val,TRTimes,'linear','extrap');
        psych(psych < 0) = -1; psych(psych > 0) = 1;
        % newGraphWin; plot(TRTimes,psych); grid on;
        
        % Convolution form
        
        psychConv = conv2(xBF.bf(:),psych(:));
        psychConv = psychConv(1:nTime);
        psychConv = psychConv - mean(psychConv(:));
        % newGraphWin; plot(psychConv); hold on; plot(psych);
        
        %% Create the matrix for the regression Beta values for predicting from roi1 to roi2
        
        
        reg = [meanTSeries(:,1) , psychConv,  psychConv .* meanTSeries(:,1) ];
        beta = reg\meanTSeries(:,2);
        
        ppiScores(r1,r2) = beta(3)/sum(beta);
        
        % newGraphWin;
        % prediction = reg*beta;
        % plot([meanTSeries(:,2), prediction])
        % set(gca,'ylim',[-3 3]);
        
        % If you want to see the regression terms, plot tis
        
        % plot(reg);
        % legend({'TS','Psych','Product'});
        % grid on
        
        %% Beta values from roi2 to roi1
        
        %         reg = [meanTSeries(:,2) , psychConv,  psychConv .* meanTSeries(:,2) ];
        %         beta = reg\meanTSeries(:,1)
        %         ppiScores(r1,r2) = beta(3)/sum(abs(beta));
        %         % newGraphWin;
        % prediction = reg*beta;
        % plot([meanTSeries(:,2), prediction])
        % set(gca,'ylim',[-3 3]);
    end
end

%%
newGraphWin;
hist(ppiScores(:),50);

newGraphWin;

imagesc(ppiScores); 
set(gca, 'YTick', 1:nROIs);
set(gca, 'YTickLabel', roiShortNames(cogcon));

%%
