function rootPath = sdmRootPath
% Determine path to root of the scitran client directory
%
%        rootPath = sdmRootPath;
%
% This function MUST reside in the directory at the base of the scitran
% client directory structure 
%
% Copyright Scitran Team, 2016

rootPath=which('sdmRootPath');

rootPath= fileparts(rootPath);

return
