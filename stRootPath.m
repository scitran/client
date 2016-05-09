function rootPath = stRootPath
% Determine path to root of the scitran client directory
%
%        rootPath = stRootPath;
%
% This function MUST reside in the directory at the base of the scitran
% client directory structure 
%
% Copyright Scitran Team, 2016

rootPath=which('stRootPath');

rootPath= fileparts(rootPath);

return
