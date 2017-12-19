function repoDirectory = clone(tbx,varargin)
% Clone the toolboxes (tbx) locally
%
% Syntax
%   repoDirectory = tbx.clone(...)
% 
% Description
%   Clone a github repository locally
%
% Input (required)
%   None when called as a method
%
% Input (optional)
%   destination - Directory that will contain the clone repository
%   cloneDepth  - How much history you want
%
% Return
%   repoDirectory - Full path to the cloned directory
%
% BW Scitran Team, 2017
%
% See also:  scitran.toolboxInstall, scitran.toolboxClone, toolboxes.install

% tbx = toolboxes('WLVernierAcuity.json');
% Examples
%{
   tbx.gitrepo.commit  = 'master';
   tbx.clone('destination',pwd);
%}
%{
   tbx.gitrepo.commit = 'fa1f7b0b4349d8be4620c29ca002bcf8620952dd';
   tbx.clone('destination',pwd);
%}
%{
%  Specify the depth of the clone and the destination
   tbx.gitrepo.commit  = 'master';
   tbx.clone('cloneDepth',1,'destination',pwd);
%}

%% set up the download directory
p = inputParser;
destination = userpath;
p.addParameter('destination',destination,@(x)(exist(x,'dir')));
p.addParameter('cloneDepth',2,@isnumeric);

p.parse(varargin{:});
installDirectory = p.Results.destination;
cloneDepth       = p.Results.cloneDepth;

if ~exist(installDirectory,'dir')
    % Should never happen
    fprintf('Creating directory %s\n',installDirectory);
    mkdir(installDirectory);
end

% Save these
startDirectory = pwd;
gitrepo = tbx.gitrepo;
repoDirectory = fullfile(installDirectory,gitrepo.project);

%% Download the toolboxes

if ~isempty(which(tbx.testcmd))
    fprintf('Found toolbox <%s> on your path.',repoDirectory);
end

% This might be updated to a window that selects the
% directory, starting with the current directory.
%         fprintf('Installing in directory *** %s ***\n',pwd);
%         fprintf('<Return> to continue: ');     pause
%         fprintf('\n');
if exist(repoDirectory,'dir')
    % Directory is there but not on the path
    fprintf('Repository exists, but not on your path. Adding.\n')
    chdir(repoDirectory);
    addpath(genpath(pwd));
    return;
else
    % OK, couldn't find it and no testcmd.
    
    % Clone it
    chdir(installDirectory);
    url = sprintf('https://github.com/%s/%s',gitrepo.user,gitrepo.project);
    cmd = sprintf('git clone --depth %d %s\n',cloneDepth,url);
    status = system(cmd);
    if status
        error('Git clone command failed. Status %d (128- dir exists).\n',status);
    end
    
    % Set to the commit hash
    if ~isequal(gitrepo.commit,'master')
        chdir(gitrepo.project)
        cmd = sprintf('git checkout %s\n',gitrepo.commit);
        system(cmd);
        chdir(installDirectory);
    end
end

chdir(repoDirectory);
addpath(genpath(pwd));
gitRemovePath;
chdir(installDirectory);

%% Check that we have it

chdir(startDirectory);

% Test that we find the test command
if isempty(which(tbx.testcmd)), fprintf('Oddly, %s not found.\n',tbx.testcmd)
else, fprintf('Repository <%s> installed and added to path.\n',repoDirectory);
end

end