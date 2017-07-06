function clone(tbx,varargin)
% Clone the toolboxes (tbx) locally
%
% The clone command downloads the history and everything.
%
% The alternative install command downloads a zip file.
%
% BW Scitran Team, 2017

%% set up the download directory
p = inputParser;
destination = fullfile(stRootPath,'local','tbxDownloads');
p.addParameter('destination',destination,@(x)(exist(x,'dir')));
p.parse(varargin);
destination = p.Results.destination;

if ~exist(destination,'dir')
    fprintf('Creating directory %s\n',destionation);
    mkdir(destination); 
end

%% Download the toolboxes
nTbx = length(tbx);
for ii=1:nTbx
    thisTestCmd = which(tbx(ii).testcmd);
    if isempty(thisTestCmd)
        % This should be updated to a window that selects the
        % directory, starting with the current directory.
        fprintf('Installing in directory *** %s ***\n',pwd);
        fprintf('<Return> to continue: ');     pause
        fprintf('\n');
        
        status = system(tbx(ii).getcmd);
        if status
            error('Git clone command for %s failed. Status %d (128- dir exists).\n',tbx.name{ii},status);
        end
        
        % We should move the directory to its tbxdirectory name
        chdir(tbx(ii).name); addpath(genpath(pwd));
        gitRemovePath;
        thisTestCmd = which(tbx(ii).testcmd);
        if ~isempty(thisTestCmd)
            fprintf('%s cloned and added to path.\n',tbx(ii).name);
        end
    else
        fprintf('*** Found toolbox %s\n',tbx(ii).name);
    end
end

end