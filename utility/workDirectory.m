function workingDir = workDirectory(workingDir)
% Change into a working directory; if absent create it
%
%    wDir = workDirectory(pwd);
%
% If the directory does not exist, we create it.  We always change into it
% because, well, that's where we want to work.
%
% Example:
%   wDir = workDirectory(fullfile(stRootPath,'local'));
%   pwd
%   wDir
%
% BW Scitran Team, 2017

if notDefined('workingDir'), workingDir = pwd; end

if ~exist(workingDir,'dir')
    fprintf('Creating working directory %s\n',workingDir);
    mkdir(workingDir);
end

chdir(workingDir);

end