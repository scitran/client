%% ALDIT data set error analysis (phantom data)
%
% This is an example. We find an acquisition, download the DWI data, and do
% something reasonable with it.  This graph can be compared with graphs
% from other phantom measurements on other scanenrs.
%
% @LMP - We could add info to the plots about the data, project label and
% subject, but perhaps other things.  Also, we could standardize a bit more
% on the look of the graphs.
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
project = 'ALDIT: Stanford CNI';
subjectCode = '11671';

sessions = st.search('sessions',...
    'project label contains',project,...
    'file type','nifti',...
    'session contains subject',subjectCode, ...
    'summary',true);

%  List the acquisitions in the first session

acquisitions = st.search('acquisitions', ...
    'session label',sessions{1}.source.label,...
    'summary',true);

%% Pull down the nii.gz, bvec and bval from the first acquisition

% This could be a function that is like dwiLoad().  Say
%
%   dwi = st.dwiLoad(acquisitionID,'destination',dirName);

thisA = 2;
bvecFile = st.search('files',...
    'acquisition id',acquisitions{thisA}.id,...
    'file type','bvec');
st.get(bvecFile{1},'destination',fullfile(workingDir,'dmri.bvec'));

bvalFile = st.search('files',...
    'acquisition id',acquisitions{thisA}.id,...
    'file type','bval');
st.get(bvalFile{1},'destination',fullfile(workingDir,'dmri.bval'));

niiFile = st.search('files',...
    'acquisition id',acquisitions{thisA}.id,...
    'file type','nifti');
st.get(niiFile{1},'destination',fullfile(workingDir,'dmri.nii.gz'));

dwi = dwiLoad(fullfile(workingDir,'dmri.nii.gz'));

% The data have negative numbers.  Sigh.
dwi.nifti.data = abs(dwi.nifti.data);

%% Run dtiError

niftiView(dwi.nifti);

mrvNewGraphWin;
hist(dwi.nifti.data(:),100);

%% Write out a white matter mask

% This is a hack based on the fact that we use 180 somewhere else.  We need
% to have a wmProb function that is more general.
v = prctile(dwi.nifti.data(:),75);
wmProb = dwi.nifti;
wmProb.data = mean(single(dwi.nifti.data > v)*200,4);
niftiWrite(wmProb,'wmProb.nii.gz');
% niftiView(wmProb);

%% Local test

% Notice that for these data there are only 6 directions.  So the ellipsoid
% fits perfectly and there is no chance for a deviation.  This is reflected
% in the near perfect fits.  Really, these lines are just a test of the
% calculation.
%
%  [err, dwi, coords, predicted, measured] = ...
%    dtiError(baseName,'eType','dsig','wmProb','wmProb.nii.gz','ncoords',100);
%
%  mrvNewGraphWin;
%  plot(predicted(:),measured(:),'o');
%  mrvNewGraphWin
%  hist(err,50); xlabel('\Delta dsig'); ylabel('Count')

% The only real test we have is the repeats on the b=0.  There are two
% measurements.

%% So, load them all up in a structure
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

%%



