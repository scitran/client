function install(tbx)
% Install all of the toolboxes by downloading the repositories
% as zip files.
%
% Clone the toolboxes locally
%
% The install command brings them down as zip files.
% The clone command brings the history and everything down
%
% TODO:
%  Specify the install directory
%
% BW, Scitran Team, 2017

%% Make the directory for the download
startDirectory = pwd;

% This will be a parameter
installDirectory = fullfile(pwd,'scitranTBX');
if ~exist(installDirectory,'dir'), mkdir(installDirectory); end
% Empty the install directory?

fprintf('Installing in directory *** %s ***\n',installDirectory);
fprintf('<Return> to continue: ');     pause
fprintf('\n');

%%
nTbx = length(tbx.names);
for ii=1:nTbx
    thisTestCmd = which(tbx.testcmd{ii});
    if isempty(thisTestCmd)
        % This could be updated to a window that selects the
        % directory, starting with the current directory.
        chdir(installDirectory);
        %
        % The getcmd should probably be something like this
        %  getcmd.user
        %  getcmd.project
        %  getcmd.sha
        % And we then build the urul
        % https://github.com/getcmd.user/getcmd.project/archive/{sha or master}.zip
        %
        % url = 'https://github.com/isetbio/WLVernierAcuity/archive/master.zip';
        % Whatever you name the download file, when unzip'd the directory becomes
        % WLVernierAcuity-{sha or master}
        %
        filename = 'WlVernierAcuity-master.zip';
        outfilename = websave(filename,url);
        if exist(outfilename,'file')
            unzip(outfilename);
        end
        
        status = system(tbx.getcmd{ii});
        if status
            error('Download of zip file %s failed. Status %d (128- dir exists).\n',tbx.name{ii},status);
        end
        
        thisTestCmd = which(tbx.testcmd{ii});
        if ~isempty(thisTestCmd)
            fprintf('%s installed and added to path.\n',tbx.names{ii});
        end
    else
        fprintf('*** Found toolbox %s\n',tbx.names{ii});
    end
end

% We should move the directory to its tbxdirectory name
chdir(installDirectory); addpath(genpath(pwd));
chdir(startDirectory);

end
