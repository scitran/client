function [cmd, oFile] = stEsearchCreate(varargin)
% Create the cURL command for a scitran elastic search query
%
%   [cmd, oFile] = stEsearchCreate(varargin)
%
% Inputs (either as struct or parameter/value)
%  'token' - authorization token
%  'url'   - scitran instance url
%  'json'  - json data sent in for search
%  'oFile' - json output file from the elastic search
%
% Example
% 
% BW, Scitran Team, 2016

%% Decode input arguments
p = inputParser;
p.PartialMatching = false;
p.CaseSensitive   = true;

% The url should be secure
vFunc = @(x) isequal(x(1:6),'https:');
p.addParameter('url','https://flywheel.scitran.stanford.edu',vFunc);

% This is the security token obtained via stAuth
p.addParameter('token','',@ischar);

% This is the json data that defines the search
p.addParameter('json','',@ischar);

% Output file name, must end with a .json extension
oFile = [tempname, '.json'];
vFunc = @(x) isequal(x(end-5:end),'.json');
p.addParameter('oFile',oFile,vFunc);

% Parse
p.parse(varargin{:});

url    = p.Results.url;
token  = p.Results.token;
json   = p.Results.json;
oFile  = p.Results.oFile;

%% Build the command

% Set the number of search results desired (does not work with collection
% searches)
% Ask LMP what to do about this issue
% num_results = 50;

cmd = sprintf('curl -XGET "%s/api/search" -H "Authorization":"%s" -k -d ''%s'' > %s && echo "%s"',...
    url, token, json, oFile, oFile);
    
    
end
