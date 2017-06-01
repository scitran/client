function dtiErrorALDIT(varargin)
% ALDIT data set error analysis (phantom data)
%
% We find and download an acquisition containing DWI data. Then we do
% something reasonable with it to assess the noise. The resulting graph can
% be compared with data from phantom measurements on other scanners.
%
% BW Scitran Team, 2017

%% Start with initialization
p = inputParser;
p.addParameter('project','Diffusion Noise Analysis',@ischar);

%% Open the Flywheel object
st = scitran('action', 'create', 'instance', 'scitran');

%% Search for the session and acquisition

project = 'Diffusion Noise Analysis';
sessions = st.search('sessions',...
    'project label contains',project);

% List the acquisitions in the first session
acquisitions = st.search('acquisitions', ...
    'session label',sessions{1}.source.label,...
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
    wmProb = wmCreate(dwi.nifti,95);
    niftiWrite(wmProb,'wmProb.nii.gz');
    % niftiView(wmProb);
    
    %% dtiError test
    
    [err, ~, ~, predicted, measured] = ...
        dtiError(dwi.files.nifti,'eType','dsig','wmProb','wmProb.nii.gz','ncoords',500);
    
    label{ii} = acquisitions{ii}.source.label;
    
    mrvNewGraphWin; hist(err,50); title(label{ii});
    
    mrvNewGraphWin; 
    plot(predicted(:),measured(:),'o');
    axis equal; identityLine(gca); grid on; title(label{ii});
    xlabel('predicted'); ylabel('measured');
    
    % Normalized RMSE
    nRMSE(ii) = sqrt(mean((predicted(:)-measured(:)).^2))/mean(measured(:));
    
end

%% Could have sorted by b value.  Just lazy, I guess.

% A reasonable bar graph summary of the normalized RMSE
mrvNewGraphWin;
b = bar3(nRMSE,0.3); zlabel('Normalized RMSE');
set(b,'FaceLighting','gouraud','EdgeColor',[1 1 1])
set(gca,'YTickLabel',label);
view([-64,23]);

%%




