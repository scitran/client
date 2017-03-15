function found = stGitCheck(funcName,varargin)
% STGITCHECK - 
%
% Input parameters
%  funcName - Test function that should be on your path
%
% Optional
%  gitInfo  - URL to the github repository if needed
%  basePath - Base directory for the local repository (default = tempdir)
%
% Example:
%  funcName = 'ctmr_gauss_plot';
%  gitInfo = 'https://github.com/dorahermes/Paper_Hermes_2010_JNeuroMeth';
%  found = stGitCheck(funcName,'gitInfo',gitInfo);
%  found = stGitCheck(funcName,'gitInfo',gitInfo,'basePath','/Users/wandell/Github');
%
% DH/BW Vistasoft Team

%% Parse inputs
p = inputParser;

p.addRequired('funcName',@isstr);        % Test function name
p.addParameter('gitInfo','',@isstr);     % https of git repository
p.addParameter('basePath','',@isstr);    % Where to put the repository
p.parse(funcName,varargin{:});

gitInfo  = p.Results.gitInfo;
basePath = p.Results.basePath;

%%
found = which(funcName);

if ~isempty(found)
    % Found.  Go away.
    return;
elseif isempty(found) && isempty(gitInfo)
    % Not found and no help
    error('Validation function %s not found',funcName);   
else
    % Go download from git respository
    [~,gitDirectory] = fileparts(gitInfo);
    
    curPath = pwd;
    
    % Where do we put it?
    if isempty(basePath), basePath = tempdir; end
    gitPath = fullfile(basePath,gitDirectory);
    
    % If it exists, update.  Could set a no-update flag ...
    if exist(gitPath,'dir')
        chdir(gitPath);
        cmd = 'git pull';
        system(cmd);
        disp('Updated with git pull')
    else
        % Get it from Github
        chdir(basePath);
        cmd = sprintf('git clone %s',gitInfo);
        system(cmd);
    end
    
    % Add the location
    addpath(genpath(gitPath));
    chdir(curPath);
    
    found = which(funcName);
    if isempty(found)
        error('Failed to download github repository with %s',funcName);
    end
end

%%