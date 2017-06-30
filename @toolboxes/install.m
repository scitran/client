function install(tbx)
% Install all the github toolbox repositories, downloading  as zip files.
%
% The tbx.install command brings the github repository as a zip file. 
% The tbx.clone command clones the whole repository (history, everything)
%
% Example:
%   tbx = toolboxes;
%   tbx.testcmd = {'wlvRootPath'};
%   tbx.zipinfo{1}.user = 'isetbio';
%   tbx.zipinfo{1}.project = 'WLVernierAcuity';
%   tbx.zipinfo{1}.name = 'master';
%
% Or use a commit sha for a particular commit
%   tbx.zipinfo{1}.name = 'fa1f7b0b4349d8be4620c29ca002bcf8620952dd';
%
% TODO:
%  Specify the install directory
%
% BW, Scitran Team, 2017

%% Make the directory for the download
startDirectory = pwd;

% This will be a parameter some day.
installDirectory = fullfile(pwd,'scitranTBX');
if ~exist(installDirectory,'dir'), mkdir(installDirectory); end

% Empty the install directory?

%% Ask the user if things are OK
fprintf('Installing in directory *** %s ***\n',installDirectory);
fprintf('<Return> to continue: ');     pause;
fprintf('\n');

%% Loop over the toolboxes

nTbx = length(tbx.testcmd);
for ii=1:nTbx
    fprintf('%d - Looking for %s\n',tbx.testcmd{ii});
    if isempty(which(tbx.testcmd{ii}))
        % This could be updated to a window that selects the
        % directory, starting with the current directory.
        chdir(installDirectory);
        

        % To build the url
        %  https://github.com/getcmd.user/getcmd.project/archive/{sha or master}.zip
        %
        % Whatever you name the download file, when unzip'd the directory becomes
        % WLVernierAcuity-{sha or master}.zip
        
        zipinfo = tbx.zipinfo{ii};
        % Either a sha of a commit or 'master'
        filename = sprintf('%s.zip',zipinfo.name);
        url = sprintf('https://github.com/%s/%s/archive/%s.zip',...
            zipinfo.user,zipinfo.project,zipinfo.name);
        fprintf('Downloading zip file ...');
        outfilename = websave(filename,url);
        if exist(outfilename,'file')
            fprintf('Unzipping ...');
            unzip(outfilename);
            delete(outfilename); % Removes the zip file.
        end
        fprintf('Done\n');
    else
        fprintf('*** Found the function %s\n',tbx.testcmd{ii});
    end
end

%% Add everything in scitranTBX to path

chdir(installDirectory); addpath(genpath(pwd));
chdir(startDirectory);

% Test that we have each of the testcmd functions
for ii=1:nTbx    
    if isempty(which(tbx.testcmd{ii}))
        fprintf('%s not found.\n',tbx.testcmd{ii})
    else
        fprintf('Repository containing ** %s ** installed and added to path.\n',tbx.testcmd{ii});
    end
end

end
