function nRMSE = dtiErrorALDIT(varargin)
% ALDIT data set error analysis (phantom data)
%
%     nRMSE = dtiErrorALDIT('project',...,'session',...'wmPercentile',...,'scatter',...'histogram',...);
%
% We find and download an acquisition containing DWI data. Then we do
% something reasonable with it to assess the noise. The resulting graph can
% be compared with data from phantom measurements on other scanners.
%
% Example:
%    project = 'ALDIT';
%    session = 'Test Site 2';
%    dtiErrorALDIT('project',project,'session',session);
%
%    clear params; params.project = 'ALDIT';
%    params.session = 'Test Site 2';
%    params.wmPercentile = 80; params.nSamples = 500;
%    params.scatter = false; params.histogram = false;
%    dtiErrorALDIT(params);
%
% TODO:  Set destination for downloads.
%
% BW Scitran Team, 2017

%% Start with initialization
p = inputParser;

p.addParameter('project','ALDIT',@ischar);
p.addParameter('session','Test Site 1',@ischar);
p.addParameter('wmPercentile',95,@isnumeric);
p.addParameter('nSamples',250,@isnumeric);
p.addParameter('scatter',false,@islogical);
p.addParameter('histogram',false,@islogical);

p.parse(varargin{:});

project      = p.Results.project;
session      = p.Results.session;
wmPercentile = p.Results.wmPercentile;
nSamples     = p.Results.nSamples;
scatter      = p.Results.scatter;
histogram    = p.Results.histogram;

%% Open the Flywheel object
st = scitran('action', 'create', 'instance', 'scitran');

%% Search for the session and acquisition

% List the Diffusion acquisitions in the first session
acquisitions = st.search('acquisitions', ...
    'project label contains',project, ...
    'session label',session,...
    'acquisition label contains','Diffusion',...
    'summary',true);

%% Pull down the nii.gz, bvec and bval from the first acquisition

nAcquisitions = length(acquisitions);
nRMSE = zeros(1,nAcquisitions);
label = cell(1,nAcquisitions);

for ii=1:nAcquisitions
    
    % We group the diffusion data, bvec and bval into a dwi structure as
    % per vistasoft
    dwi = st.dwiLoad(acquisitions{ii}.id);
    
    % Check the download this way
    %  niftiView(dwi.nifti);
    %  mrvNewGraphWin; hist(double(dwi.nifti.data(:)),100);
    
    %% Write out a white matter mask
    wmProb = wmCreate(dwi.nifti,wmPercentile);
    niftiWrite(wmProb,'wmProb.nii.gz');
    % niftiView(wmProb);
    
    %% dtiError test
    
    [err, ~, ~, predicted, measured] = ...
        dtiError(dwi.files.nifti,'eType','dsig','wmProb','wmProb.nii.gz','ncoords',nSamples);
    
    label{ii} = acquisitions{ii}.source.label;
    
    if histogram
        mrvNewGraphWin; hist(err,50); title(label{ii});
    end
    
    if scatter
        mrvNewGraphWin;
        plot(predicted(:),measured(:),'o');
        axis equal; identityLine(gca); grid on; title(label{ii});
        xlabel('predicted'); ylabel('measured');
    end
    
    % Normalized RMSE
    nRMSE(ii) = sqrt(mean((predicted(:)-measured(:)).^2))/mean(measured(:));
    
end

%% Always plot the bar graph.

% A reasonable bar graph summary of the normalized RMSE
mrvNewGraphWin;
[label,idx] = sort(label);
b = bar3(nRMSE(idx),0.3); zlabel('Normalized RMSE');
set(b,'FaceLighting','gouraud','EdgeColor',[1 1 1])
set(gca,'YTickLabel',label);
view([-64,23]);
title(session)

end




