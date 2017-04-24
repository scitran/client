function [result, srchFile, esCMD] = search(obj,srch,varargin)
% Create a cmd and run an elastic search from the search struct
%
%  [srchResult, srchFile, esCMD] = st.search(s)
%
% Input:
%  srch:  A struct containing the url, token and json fields needed to
%         create the search command
%  srchFile:  Name of json file if you want it returned by the search
%  esCmd:     The command past for the Elastic Search
%
% Return:
%  srchResult:  Struct of data from scitran
%
% BW Scitran Team 2016

%% Could check the srch struct here for the appropriate fields
%
p = inputParser;

p.addRequired('srch');
% If you want the json file returned by the search, then this should be a
% legitimate file name for writing it.  It should have a .json extension.
p.addParameter('oFile','',@ischar);
p.addParameter('all_data',false,@islogical);

p.parse(srch,varargin{:});
srch  = p.Results.srch;
oFile = p.Results.oFile;
all_data = p.Results.all_data;

%% The srch is a Matlab structure containing the search requirements.

% It is converted to json here.  But, we accept either a struct or a json
% notation for the srch.
if isstruct(srch)
    % It is a Matlab struct, so convert it to json notation.
    % Appears to work for _id, fixed *G Flandin*
    srch = jsonwrite(srch,struct('indent','  ','replacementstyle','hex'));  
    % srch = savejson('',srch);
end
srch = regexprep(srch, '\n|\t', ' ');
srch = regexprep(srch, ' *', ' ');
esCMD = obj.searchCmd(srch,'all_data',all_data);

% Could validate the oFile name
%vFunc = @(x) isequal(x(end-5:end),'.json');

%% Run the command

% result is a string with a bunch of stuff RF put in it, including timing
% information and the json output file.  We get the filename below.

% disp('Remote elastic search');
% tic
[~, result] = system(esCMD);
% toc

% Load the result json file. NOTE the use of strtrim to get rid of the
% final blank character
if ismac
    srchFile = strtrim(result(strfind(result,'/private/tmp'):end));
elseif isunix
    srchFile = strtrim(result(strfind(result,'/tmp'):end));
end

% This is now a Matlab struct with a lot of ugly terms.  We clean them up
% below.
if ~exist(srchFile,'file'), error('Results does not contain a valid search file');
else
    % disp('Running jsonread on returned file');
    %    tic
    % srchResult = loadjson(srchFile);
    srchResult = jsonread(srchFile);
    %   toc
end

if isfield(srchResult,'message')
    result = srchResult;
    fprintf('Search error\n');
    fprintf('Status code: %d\n',result.status_code);
    fprintf('Message:     %s\n',result.message);
    return;
end

% Sometimes the result is empty.  Typically it is a struct.
result = stParseSearch(obj,srchResult);

% Save the search file, or delete it.
if ~isempty(oFile)
    % Less typical
    movefile(srchFile,oFile);
else
    % Typical
    delete(srchFile);
end

end
