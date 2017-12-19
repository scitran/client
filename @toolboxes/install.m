function repoDirectory = install(tbx,varargin)
% Install a  github toolbox repository as a zip file.
%
% Syntax
%  repoDirectory = toolboxes.install(tbx,...)
%
% Description
%  Download a zip file from a github repository, unzip it, and install it
%  on the user's path.
%
% Input (required)
%   None
%
% Input (optional)
%   destination - Directory that will contain the repo directory.
%
% Return
%   repoDirectory - full path to the repository
%
% BW, Scitran Team, 2017
%
% See also toolboxes.clone, scitran.toolboxInstall

% Example:
%{
   tbx = toolboxes('WLVernierAcuity.json');
   tbx.install('destination',pwd);
%}
%{
   % Use a commit sha for a particular commit
   tbx = toolboxes('WLVernierAcuity.json');
   tbx.gitrepo.commit = 'fa1f7b0b4349d8be4620c29ca002bcf8620952dd';
   tbx.install;
%}

%% Read installation directory, if passed.

p = inputParser;

p.addParameter('destination',userpath,@(x)(exist(x,'dir')));

p.parse(varargin{:});

installDirectory = p.Results.destination;

if ~exist(installDirectory,'dir')
    % Should never happen, I think.
    fprintf('Creating directory %s\n',installDirectory);
    mkdir(installDirectory); 
end

%% Download toolbox as zip and add to path

startDirectory = pwd;

if isempty(which(tbx.testcmd))
    
    % This could be updated to a window that selects the
    % directory, starting with the current directory.
    chdir(installDirectory);

    gitrepo = tbx.gitrepo;
    repoDirectory = sprintf('%s-%s',gitrepo.project,gitrepo.commit(1:6));
    repoDirectory = fullfile(installDirectory,repoDirectory);
    
    if exist(repoDirectory,'dir')
        % Directory is there but not on the path
        fprintf('Repository exists, but is not on your path. Adding.\n')
    else
        % Can't find the command or the directory.  So, onward.
        %
        % Ask the user if destination is OK
        %     fprintf('Installing in directory <%s>\n',repoDirectory);
        %     fprintf('<Return> to continue: ');     pause;
        %     fprintf('\n');
        
        % To build the url
        %  https://github.com/getcmd.user/getcmd.project/archive/{sha or master}.zip
        %
        % Whatever you name the download file, when unzip'd the directory becomes
        % WLVernierAcuity-{sha or master}.zip
        
        % commit is either a sha of a commit or the string 'master'
        filename = sprintf('%s.zip',gitrepo.commit);
        url = sprintf('https://github.com/%s/%s/archive/%s.zip',...
            gitrepo.user,gitrepo.project,gitrepo.commit);
        fprintf('Downloading zip file ...\n');
        
        outfilename = websave(filename,url);
        if exist(outfilename,'file')
            fprintf('Unzipping to %s ...\n',repoDirectory);
            unzip(outfilename);
            if ~isequal(gitrepo.commit,'master')
                % Download name after unzipping
                tmp = sprintf('%s-%s',gitrepo.project,gitrepo.commit);
                % Desired name
                movefile(tmp,repoDirectory);
            end
            delete(outfilename); % Removes the zip file.
        end
        fprintf('Done\n');
    end
else
    fprintf('Found <%s> in <%s>\n',tbx.testcmd,which(tbx.testcmd));
    return;
end


%% Add repository to the path

% The zip file comes down with an extra -master or some info.  We are going
% to change the directory name to match name in the toolbox.
[p,~] = fileparts(repoDirectory);
movefile(repoDirectory,fullfile(p,tbx.gitrepo.project));
repoDirectory = fullfile(p,tbx.gitrepo.project);

chdir(repoDirectory);
addpath(genpath(pwd));
chdir(startDirectory);

% Test that we find the test command
if isempty(which(tbx.testcmd))
    fprintf('%s not found.\n',tbx.testcmd)
else
    fprintf('Repository <%s> installed and added to path.\n',repoDirectory);
end

end
