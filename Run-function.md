There are cases when it is useful to provide a Matlab function for a session or project on the Flywheel site.  For example, suppose you write a script to analyze Flywheel data.  You may want to associate this script with the Flywheel data by attaching it to the project or session. 

The **scitran** method runFunction downloads a Matlab function from a Flywheel site and runs it. The script can be downloaded and run by anyone who is given permission to access the project.  

This page illustrates the runFunction.  The example first uses **scitran** methods to validate the toolbox installation. Then, the script is explained.

## Invoking the runFunction
### Checking the toolboxes
The runFunction locally executes an m-file attached to the Flywheel site.  The next few lines of code first check that the necessary toolboxes are installed for the user.  
```
tbx = st.toolboxGet('aldit-toolboxes.json','project name','ALDIT');
valid = st.toolboxValidate(tbx,'verbose',true);
if ~valid, error('Set up your toolboxes!'); end
```
If the toolboxes are not installed, the user can call the method
```
% The install method uses a zip download.  Use toolboxClone if you want to clone the repository.
% The tbx information can specify a specific commit.
tbx = st.toolboxInstall(tbx);
```
### Running the function
The Matlab function dtiErrorALDIT.m analyzes Flywheel data. The function accepts parameters that choose data or set parameter values.
```
% Make sure the project is available and get the id
[valid,id] = st.exist('project','ALDIT');  
if valid
    clear params
    params.project = 'ALDIT';
    params.session = 'Set 1';
    [~,RMSE1] = st.runFunction('dtiErrorALDIT.m',...
        'container type','project',...
        'container ID',id,...
        'params',params);
else
    error('Could not find project ALDIT');
end
disp(RMSE1)
```

### Analyze diffusion error
The dtiErrorALDIT.m function was used in a project that compares diffusion-weighted images from many different sites. The data from the different sites along with this script were placed on the Flywheel site.  We explain the function.

The header explains the parameter options that govern which data are analyzed and which parameters are used for the analysis.

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
Now, the interactions with Flywheel begin.  First, we open a scitran instance to communicate with the Flywheel site ('vistalab' instance).  The user must have the **scitran** client and access to this site.
```
%% Open the Flywheel object
st = scitran('vistalab');
```
The function reads the data from a particular acquisition. The data are searched and downloaded using **scitran** methods.
```
%% Search for the session and acquisition

% List the acquisitions containing the label 'Diffusion' that are in this session
acquisitions = st.search('acquisition', ...
    'project label exact',projectlabel, ...
    'session label exact',sessionlabel,...
    'acquisition label contains','Diffusion',...
    'summary',true);

if isempty(acquisitions)
    fprintf('No acquisitions in project %s, session %s\n',projectlabel,sessionlabel);
    return;
end

% Initialize some parameters
nAcquisitions = length(acquisitions);
nRMSE = zeros(1,nAcquisitions);
label = cell(1,nAcquisitions);

for ii=1:nAcquisitions
    
    % We group the diffusion data, bvec and bval into a dwi structure as
    % per vistasoft. This method downloads the nii.gz, bvec and bval files 
    % from the acquisition
    dwi = st.dwiLoad(idGet(acquisitions{ii}));
    
    
    %% Create and write out a white matter mask (vistasoft functions)
    wmProb = wmCreate(dwi.nifti,wmPercentile);
    niftiWrite(wmProb,'wmProb.nii.gz');
    
    %% dtiError test (dti-error toolbox function)
    [err, ~, ~, predicted, measured] = ...
        dtiError(dwi.files.nifti,'eType','dsig','wmProb','wmProb.nii.gz','ncoords',nSamples);
       
    % Calculated the Normalized RMSE
    nRMSE(ii) = sqrt(mean((predicted(:)-measured(:)).^2))/mean(measured(:));
    
end
```
The remaining code generates plots and the return variables.
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


