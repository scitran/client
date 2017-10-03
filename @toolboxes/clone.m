function tbxDir = clone(tbx,varargin)
% Clone the toolboxes (tbx) locally
%
%    tbxDir = @toolboxes.clone('destination',<directory>,'cloneDepth',<scalar>);%
%
% Required inputs 
%
% Optional inputs
%    'cloneDepth'  - Depth of the clone
%    'destination' - The directory that will contain the repo
%
% Return
%    'tbxDir' - Directory of the clone or install
%
% The clone command downloads the full history.  Set the cloneDepth to
% download only a shallow version of the repository.
%
% Examples
%   tbx = toolboxes;
%   tbx.testcmd         = 'wlvRootPath';
%   tbx.gitrepo.user    = 'isetbio';
%   tbx.gitrepo.project = 'WLVernierAcuity';
%   tbx.gitrepo.commit  = 'master';
%
% Or use a commit sha for a particular commit
%   tbx.read('WLVernierAcuity.json');
%   tbx.gitrepo.commit = 'fa1f7b0b4349d8be4620c29ca002bcf8620952dd';
%
% You can clone the directory this way
%
%    tbx.clone
%
% Or, you can specify the depth of the clone and the destination
%
%    tbx.clone('cloneDepth',1,'destination',pwd);
%
% See also: The alternative install method downloads a zip file. See
%           @toolboxes.install
%
% BW Scitran Team, 2017

%% set up the download directory
p = inputParser;
destination = userpath;
p.addParameter('destination',destination,@(x)(exist(x,'dir')));
p.addParameter('cloneDepth',2,@isnumeric);

p.parse(varargin{:});
installDirectory = p.Results.destination;
cloneDepth       = p.Results.cloneDepth;

if ~exist(installDirectory,'dir')
    fprintf('Creating directory %s\n',installDirectory);
    mkdir(installDirectory);
end

% Save these
startDirectory = pwd;
gitrepo = tbx.gitrepo;
tbxDir = fullfile(installDirectory,gitrepo.project);

%% Download the toolboxes

if isempty(which(tbx.testcmd))
    % This should be updated to a window that selects the
    % directory, starting with the current directory.
    %         fprintf('Installing in directory *** %s ***\n',pwd);
    %         fprintf('<Return> to continue: ');     pause
    %         fprintf('\n');
    
    if exist(tbxDir,'dir')
        % Directory is there but not on the path
        fprintf('Repository exists, but is not on your path. Adding.\n')        
    else
        chdir(installDirectory);
        % Clone it
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
    
    chdir(tbxDir);
    addpath(genpath(pwd));
    gitRemovePath;
    chdir(installDirectory);
else
    fprintf('Found toolbox <%s>\n',tbxDir);
    return;
end

%% Check that we have it

chdir(startDirectory);

% Test that we find the test command
if isempty(which(tbx.testcmd))
    fprintf('%s not found.\n',tbx.testcmd)
else
    fprintf('Repository <%s> installed and added to path.\n',tbxDir);
end

end