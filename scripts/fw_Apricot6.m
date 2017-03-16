function fw_Apricot6(st,varargin)
% Flywheel analyzes EJ data from Apricot 6
%
% Example:
%  st = scitran('action', 'create', 'instance', 'scitran');
%
%  clear dataSrch
%  dataSrch{1}.path = 'files';
%  dataSrch{1}.files.match.name = 'spikes-1';
%
%  dataSrch{2}.path = 'files';
%  dataSrch{2}.acquisitions.match.timestamp = '2013-08-19T22:31:00';
%  dataSrch{2}.files.match.name = 'stimulusMovie';
%  
%  params.dataSrch = dataSrch;
%  params.cellNumber = 10;
%  fw_Apricot6(st,params)
%
% JRG/BW/RF ISETBIO Team, 2017

%%

p = inputParser;
p.addRequired('st');
p.addParameter('dataSrch',[]);
p.addParameter('cellNumber',10,@isscalar);

p.parse(st,varargin{:});

dataSrch   = p.Results.dataSrch;
cellNumber = p.Results.cellNumber;

%% Get the data files

files = st.search(dataSrch{1});
fnameSpikes = st.get(files{1});

files = st.search(dataSrch{2});
fnameMovie = st.get(files{1});

%%

spikes = load(fnameSpikes);
[~,nTrials] = size(spikes.spikes);
timeStep = spikes.timeStep;

%%
figure;
% Set sampling rate - 121 Hz, with ten steps for each sample to simulate
% spikes


% Plot the recorded spiking data for 57 trials
for tr = 1:nTrials
    spikeTimes = (spikes.spikes{cellNumber,tr});
    hold on;
    % Draw raster plots
    scatter(spikeTimes.*timeStep,(tr*ones(length(spikeTimes),1)),8,'o','k','filled');
end

title(sprintf('Recorded spikes, cell %d', cellNumber));
xlabel('Time (sec)'); ylabel('Trial');
set(gca,'fontsize',14);

%%  Make a PSTH from the spikes

lastSpikeBin = max(horzcat(spikes.spikes{:}));

spikesCell = zeros(nTrials,lastSpikeBin);

% Bin the spikes
for tr = 1:nTrials
    % Spikes on this trial for this cell
    spikeTimesTr = (spikes.spikes{cellNumber,tr});
    
    % The times when there is a spike for this cell
    spikesCell(tr,ceil(spikeTimesTr)) = 1;    
end

% We run a convolution over the spike times
% Each sample is 1 timeStep; blur window is nSamples*timeStep
support = 100;  %  timeStep*support is the window size in sec
sigma    = support/5;   % Std. dev. in samples sigma*timeStep
fprintf('Conv window std dev %.1f ms\n',timeStep*sigma*1e3);

% Gaussian with unit area
gaussW = fspecial('gaussian',[support,1],sigma);
        
% The PSTH is the convolved spikes.  We adjusted the window
% to be sensitive to the selection of dt. Also, we wonder
% whether the sigma is small enough.  The end points are
% still noticeably above zero.  We also wonder whether we
% should normalize, we kind of think not.  BW/HJ.

% Not very many spikes
% vcNewGraphWin; plot(mean(spikesCell))

% The mean is over the trials.
psth = conv(mean(spikesCell),gaussW,'same');

% Convert to spikes per second from spikes per sample
psth = psth/timeStep;

%% Plot the PSTH

figure;
plot((1:length(psth)).*timeStep,psth,'k','linewidth',3);
title(sprintf('Recorded PSTH, cell %d', cellNumber));
xlabel('Time (sec)'); ylabel('Spikes/second');
set(gca,'fontsize',14); grid on;

%%

load(fnameMovie);
try
    figure;
    ieMovie(stimulusMovie);
catch
    disp('No ieMovie found')
end

%%
