There are cases when it is useful to provide a Matlab function for a session or project on the Flywheel site.  This functionality is particularly useful when you want a record of how data were analyzed and publication figures were created. 

The **scitran** method runFunction downloads an Matlab function and runs it. We illustrate the runFunction method an example that relies on **scitran** calls that validate the toolbox installation, retrieve data, analyze the data, and create figures.

## Invoking the runFunction
### Checking the toolboxes
The runFunction locally executes an m-file attached to the Flywheel site.  The next few lines of code first check that the necessary toolboxes are installed for the user.  
```
tbx = st.getToolbox('aldit-toolboxes.json','project name','ALDIT');
valid = st.toolboxValidate(tbx,'verbose',true);
if ~valid, error('Set up your toolboxes!'); end
```
If the toolboxes are not installed, the user would call the function
```
% Test and install.  Default method is zip download.
tbx = st.toolbox('aldit-toolboxes.json',...
    'project','ALDIT',...
    'install',true);
```
### Running the function
Then the Matlab function dtiErrorALDIT.m is run.  Notice that you can send in parameters to the function to choose data sets or set parameter values.
```
mFile = 'dtiErrorALDIT.m';
% Make sure the project is available and get the id
[s,id] = st.exist('project','ALDIT');  
if s
    clear params
    params.project = 'ALDIT';
    params.session = 'Set 1';
    [~,RMSE1] = st.runFunction(mFile,...
        'container type','project',...
        'container ID',id,...
        'params',params);
else
    error('Could not find project ALDIT');
end
disp(RMSE1)
```

### Analyze diffusion error
The contents of the dtiErrorALDIT.m are shown here.  This script was used in a study that compared diffusion-weighted images from many different sites. The data from the different sites along with this script were placed on the Flywheel site.  We walk through the script itself to illustrate how it works.

The header explains that one can make the call with many different types of parameter settings that govern which data are analyzed and which parameters are used for the analysis.

```
function nRMSE = dtiErrorALDIT(varargin)
% ALDIT data set error analysis (phantom data)
%
% Syntax
%     nRMSE = dtiErrorALDIT(...);
%
% ALDIT data set error analysis (phantom data)
%
% Syntax
%     nRMSE = dtiErrorALDIT(...);
%
% Description 
%   Analyze the diffusion weighted imaging noise from a site using
%   dtiError. The data from multiple b-values are stored in an acquisition
%   for each site.
%
%   The graph and numerical evaluations can be compared with data from
%   phantom measurements on other scanners.
%
% Inputs (required)
%  None
%
% Inputs (optional)
%  project - Project label
%  session - Session label
%  wmPercentile - White matter percentile
%  nSamples     - Number of bootstrap samples
%
% Examples in the source code
%
% BW Scitran Team, 2017
%
% See also:  scitran.runFunction
```
The function parses the input parameters
```
%% Start with initialization
p = inputParser;

p.addParameter('project','ALDIT',@ischar);
p.addParameter('session','Set 1',@ischar);
p.addParameter('wmPercentile',95,@isnumeric);
p.addParameter('nSamples',250,@isnumeric);
p.addParameter('scatter',false,@islogical);
p.addParameter('histogram',false,@islogical);

p.parse(varargin{:});

projectlabel = p.Results.project;
sessionlabel = p.Results.session;
wmPercentile = p.Results.wmPercentile;
nSamples     = p.Results.nSamples;
```
Now, the interactions with Flywheel begin.  First, we open a scitran instance to communicate.  The user must have the **scitran** client and access to the site.
```
%% Open the Flywheel object
st = scitran('vistalab');
```
The function reads the data and performs the analysis.  This is done on the local compute device (either on premise or on a machine in the cloud).  These are managed by standard **scitran** methods and methods from the toolboxes.
```
%% Search for the session and acquisition

% List the Diffusion acquisitions in the first session
acquisitions = st.search('acquisition', ...
    'project label exact',projectlabel, ...
    'session label exact',sessionlabel,...
    'acquisition label contains','Diffusion',...
    'summary',true);

if isempty(acquisitions)
    fprintf('No acquisitions in project %s, session %s\n',projectlabel,sessionlabel);
    return;
end

%% Pull down the nii.gz, bvec and bval from the first acquisition

nAcquisitions = length(acquisitions);
nRMSE = zeros(1,nAcquisitions);
label = cell(1,nAcquisitions);

for ii=1:nAcquisitions
    
    % We group the diffusion data, bvec and bval into a dwi structure as
    % per vistasoft
    dwi = st.dwiLoad(idGet(acquisitions{ii}));
    
    % Check the download this way
    %  niftiView(dwi.nifti);
    %  mrvNewGraphWin; hist(double(dwi.nifti.data(:)),100);
    
    %% Write out a white matter mask (vistasoft functions)
    wmProb = wmCreate(dwi.nifti,wmPercentile);
    niftiWrite(wmProb,'wmProb.nii.gz');
    
    %% dtiError test (dti-error toolbox function)
    [err, ~, ~, predicted, measured] = ...
        dtiError(dwi.files.nifti,'eType','dsig','wmProb','wmProb.nii.gz','ncoords',nSamples);
       
    % Normalized RMSE
    nRMSE(ii) = sqrt(mean((predicted(:)-measured(:)).^2))/mean(measured(:));
    
end
```
The key variables are computed, and the remaining code generates plots and the return variables.
```
%% Always plot the bar graph.

% A reasonable bar graph summary of the normalized RMSE
mrvNewGraphWin;
[label,idx] = sort(label);
b = bar3(nRMSE(idx),0.3); zlabel('Normalized RMSE');
set(b,'FaceLighting','gouraud','EdgeColor',[1 1 1]);
set(gca,'YTickLabel',label);
view([-64,23]);
title(sessionlabel)

end
```


