function aDirs = stDir(basedir)
% List directories but exclude '.' and '..'
%
% Syntax
%   dirList = stDir(basedir)
%
% Input
%   basedir:  Normally just the basedir.  But it could be any argument
%            that you would use to dir, such as '*.m'.  If not passed
%            in then 'pwd' is used.
%
% Optional key/val pairs
%   None
%
% Return
%   aDirs:  Array of directories in Matlab struct format
%
% Description
%   This function wraps 'dir'.  It excludes the . and .. directories.
%   If you want those directories in the list, just use 'dir'.
%
% Wandell, 2019-12-24
%
if notDefined('basedir'),basedir = pwd; end

aDirs = dir(basedir); 
aDirs=aDirs(~ismember({aDirs.name},{'.','..'})); 

end

