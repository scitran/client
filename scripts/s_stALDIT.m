%% ALDIT data set error analysis (phantom data)
%
% This is an example. We find an acquisition, download the DWI data, and do
% something reasonable with it.  This graph can be compared with graphs
% from other phantom measurements on other scanenrs.
%
% TODO
%  @LMP - We could add info to the plots about the data, project label and
%  subject, but perhaps other things.  Also, we could standardize a bit
%  more on the look of the graphs.
%
%  This code assumes vistasoft and scitranClient are installed.  We should
%  write a wrapper at the front to make sure this is true.  Good use of
%  stbuse, but that is too damn complicated right now.
%
%  Deal with the github ISSUE about the acquisition labels and number of
%  bvec files.
%
% BW Scitran Team, 2017

%% Open the Flywheel object

st = scitran('action', 'create', 'instance', 'scitran');

%% Local working directory

workingDir = fullfile(stRootPath,'local','aldit');
if ~exist(workingDir,'dir')
    mkdir(workingDir);
end
chdir(workingDir);

%% Find a session to work on.

% I would like to see the session in the browser and get a session id that
% I could use in this search.
% Typically these have several acquisitions

project = 'Diffusion Noise Analysis';
sessions = st.search('sessions',...
    'project label contains',project);

%  List the acquisitions in the first session
acquisitions = st.search('acquisitions', ...
    'session label',sessions{1}.source.label,...
    'acquisition label contains','Diffusion',...
    'summary',true);

%% Pull down the nii.gz, bvec and bval from the first acquisition
nAcquisitions = length(acquisitions);
nRMSE = zeros(1,nAcquisitions);
label = cell(1,nAcquisitions);

for ii=1:nAcquisitions
    
    dwi = st.dwiLoad(acquisitions{ii}.id);
    
    % Check this way
    %  niftiView(dwi.nifti);
    %  mrvNewGraphWin; hist(double(dwi.nifti.data(:)),100);
    
    %% Write out a white matter mask
    
    % Pick the brightest pixels as the white matter.  The percentile number was
    % picked visually for these data.
    v = prctile(dwi.nifti.data(:),95);
    wmProb = dwi.nifti;
    
    % This is a hack based on the fact that we use 180 somewhere in the
    % dtiError calculation.  We need to have a wmProb function that is more
    % general.
    wmProb.data = mean(single(dwi.nifti.data > v)*200,4);
    niftiWrite(wmProb,'wmProb.nii.gz');
    % niftiView(wmProb);
    
    %% dtiError test
    
    [err, dwi, coords, predicted, measured] = ...
        dtiError(dwi.files.nifti,'eType','dsig','wmProb','wmProb.nii.gz','ncoords',500);
    
    label{ii} = acquisitions{ii}.source.label;
    
    mrvNewGraphWin; hist(err,50); title(label{ii});
    
    mrvNewGraphWin; plot(predicted(:),measured(:),'o');
    axis equal; identityLine(gca); grid on; title(label{ii});
    xlabel('predicted'); ylabel('measured');
    
    % Normalized RMSE
    nRMSE(ii) = sqrt(mean((predicted(:)-measured(:)).^2))/mean(measured(:));
    
end

%% Could sort by diffusion b value

mrvNewGraphWin;
b = bar3(nRMSE,0.3); zlabel('Normalized RMSE');
set(b,'FaceLighting','gouraud','EdgeColor',[1 1 1])
set(gca,'YTickLabel',label);
view([-64,23]);

%% Scratch below here

%% For these older CNI data, I did something different.

% It was instructive for me.  And I picked up some minor problems.  I have
% commented this out by the if 0.  I think it runs, though.
if 0
    project = 'ALDIT: Stanford CNI';
    subjectCode = '11671';
    sessions = st.search('sessions',...
        'project label contains',project,...
        'subject code',subjectCode,...
        'summary',true);
    
    %  List the acquisitions in the first session
    acquisitions = st.search('acquisitions', ...
        'session id',sessions{1}.id,...
        'summary',true);
    
    dwi = st.dwiLoad(acquisitions{2}.id);
    % The data have negative numbers.  Sigh.
    dwi.nifti.data = abs(dwi.nifti.data);
    %
    %%
    v = prctile(dwi.nifti.data(:),75);
    wmProb = dwi.nifti;
    
    % This is a hack based on the fact that we use 180 somewhere else.  We need
    % to have a wmProb function that is more general.
    wmProb.data = mean(single(dwi.nifti.data > v)*200,4);
    niftiWrite(wmProb,'wmProb.nii.gz');
    
    %%
    % Notice that for these data there are only 6 directions.  So the ellipsoid
    % fits perfectly and there is no chance for a deviation.  This is reflected
    % in the near perfect fits.  Really, these lines are just a test of the
    % calculation.
    %
    [err, ~, ~, predicted, measured] = ...
        dtiError(dwi.files.nifti,'eType','dsig','wmProb','wmProb.nii.gz','ncoords',100);
    
    mrvNewGraphWin;
    plot(predicted(:),measured(:),'o');
    mrvNewGraphWin
    hist(err,50); xlabel('\Delta dsig'); ylabel('Count')
    
    % The only real test we have is the repeats on the b=0.  There are two
    % measurements.
    
    %% Here was a method of analyzing those data
    
    lst = find(dwi.bvals == 0);
    A = dwi.nifti.data(:,:,:,lst(1));
    B = dwi.nifti.data(:,:,:,lst(2));
    err = A(:) - B(:);
    
    % Overall RMSE and error
    mrvNewGraphWin
    hist(err,100); xlabel('\Delta '); ylabel('Count')
    RMSE = sqrt(mean(err.^2));
    fprintf('RMSE %f\n',RMSE);
    
    % Scatter
    mrvNewGraphWin
    plot(A(:),B(:),'o'); grid on;
    xlabel('First b=0'); ylabel('Second b=0')
    title('Scan replication')
    
    %% Show the RMSE as a function of mean level of A
    
    % Show the RMSE as a function of level
    nLevels = 10;
    v = zeros(1,nLevels);
    for ii=1:nLevels
        v(ii) = prctile(A(:),ii*(100/(nLevels+1)));
    end
    
    RMSE = zeros(1,nLevels-1);
    for ii=1:(nLevels-1)
        
        lst = (A(:) < v(ii+1) & A(:) > v(ii));
        lstA = A(lst); lstB = B(lst);
        err = lstA(:) - lstB(:);
        RMSE(ii) = sqrt(mean(err.^2));
        
        %     mrvNewGraphWin
        %     plot(lstA(:),lstB(:),'o'); grid on;
        %     xlabel('First b=0'); ylabel('Repeat')
        
    end
    
    mrvNewGraphWin;
    plot(v(2:nLevels),RMSE,'-o','linewidth',2);
    xlabel('S0 level');ylabel('RMSE')
    grid on;
    
end

%%



