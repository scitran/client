function clone(tbx)
% Clone the toolboxes locally
%
% The install command brings them down as zip files.
% The clone command brings the history and everything down
%
% TODO:
%  Specify the install directory
%
% BW Scitran Team, 2017

%%
nTbx = length(tbx.names);
for ii=1:nTbx
    thisTestCmd = which(tbx.testcmd{ii});
    if isempty(thisTestCmd)
        % This should be updated to a window that selects the
        % directory, starting with the current directory.
        fprintf('Installing in directory *** %s ***\n',pwd);
        fprintf('<Return> to continue: ');     pause
        fprintf('\n');
        
        status = system(tbx.getcmd{ii});
        if status
            error('Git clone command for %s failed. Status %d (128- dir exists).\n',tbx.name{ii},status);
        end
        
        % We should move the directory to its tbxdirectory name
        chdir(tbx.names{ii}); addpath(genpath(pwd));
        gitRemovePath;
        thisTestCmd = which(tbx.testcmd{ii});
        if ~isempty(thisTestCmd)
            fprintf('%s cloned and added to path.\n',tbx.names{ii});
        end
    else
        fprintf('*** Found toolbox %s\n',tbx.names{ii});
    end
end
end