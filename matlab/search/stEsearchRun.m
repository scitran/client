function [srchResult, plink, srchFile] = stEsearchRun(srch)
% Create a cmd and run an elastic search from the search struct
%
%  [srchResult, plink, srchFile] = stEsearchRun(s)
%
% Input:
%  srch:  A struct containing the url, token and json fields needed to
%  create the elastic search command
%
% Return:
%   srchResult:  Struct of data from scitran
%   plink:       If data type is files, then this is a cell array of permalinks
%   srchFile:    Name of json file returned by the search
%
% BW Scitran Team 2016

%% Could check the srch struct here for the appropriate fields
%

% The struct srch should have a url, token and body
% We use those to create the elastic search command
esCMD = stEsearchCreate(srch);

%% Run the command
[~, result] = system(esCMD);

%% Load the result file, which is a string in the returned data.

srchFile = strtrim(result(strfind(result,'/private/tmp'):end));
srchResult = loadjson(srchFile); % NOTE the use of strtrim

% If the user is searching for files, we build the plink for a file
% download for them right here.  How nice of us!
if nargout >= 2
    if strcmp(fieldnames(srchResult),'files')
        n = length(srchResult.files);
        plink = cell(1,n);
        for ii=1:n
            fname = srchResult.files{ii}.x0x5F_source.name;
            id    = srchResult.files{ii}.x0x5F_source.container_id;
            plink{ii} = sprintf('%s/api/acquisitions/%s/files/%s',srch.url, id, fname);
        end 
    end
end
