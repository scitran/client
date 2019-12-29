function aDirs = stDir(varargin)
% List directories but exclude '.' and '..'
%
% Syntax
%   dirList = stDir(varargin)
%
% Input
%   List the current directory, excluding files that beging with a '.'.
%   
% Optional key/val pairs
%   quiet - Just return the directories, do not list (true)
%
% Return
%   aDirs:  Array of directories in Matlab struct format
%
% Description
%   This function wraps 'dir'.  It excludes any directory that starts with
%   a '.' This leaves out '.', '..', and '.DS_Store'.
%
%   If you want those directories in the list, just use 'dir'.
%
% Wandell, 2019-12-24
%

% Examples:
%{
   stDir;
%}
%{
 aDirs = stDir('quiet',true);
 aDirs
%}

%%
p = inputParser;
p.addParameter('arg','',@ischar);
p.addParameter('quiet',false,@islogical);
p.parse(varargin{:});

arg   = p.Results.arg;
quiet = p.Results.quiet;

%% List everything
aDirs = dir(arg);
nDirs = numel(aDirs);

% Only keep directories that do NOT start with a '.'
keep = false(nDirs,1);
for ii=1:nDirs
    thisName = aDirs(ii).name;
    keep(ii) = ~isequal(thisName(1),'.');
end
aDirs = aDirs(keep);

if quiet, return; end

fprintf('\nBasedir:  %s\n',pwd);
fprintf('-------------\n');
for ii=1:numel(aDirs)
    fprintf('%s ', aDirs(ii).name)
end
fprintf('\n\n');

end

