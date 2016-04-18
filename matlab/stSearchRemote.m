function [srchResult, srchFile] = stSearchRemote(srchCommand,varargin)
% Run a remote search on with curl on a scitran database
%
%   [srchResult, srchFile] = stSearchRemote(srchCommand,varargin)
%
% Executes the curl command to search the database.  Data are first saved
% in a json file, read from the file into a struct, and then returned.
%
% Pehaps we should, by default, delete the json file.
%
% 
% INPUTS
%   srchCommand:  A curl command created by stCommandCreate
%   summarize:    Logical governing print output
%
% OUTPUTS
%   srchResult:   Structure containing database info
%   srchFile:     Json file returned by search command
%
% Example:
%  
% See also: v_stGearExample, stCreateQuery, stCommandCreate
%
% LMP/BW Vistasoft Team, 2016

%%
p = inputParser;
p.addRequired('srchCommand',@ischar);
p.addParameter('summarize',false,@islogical);

p.parse(srchCommand,varargin{:});
srchCommand = p.Results.srchCommand;
summarize   = p.Results.summarize;

%% Execute the search and load
[~, srchFile] = system(srchCommand);

% Read the json file
srchResult = loadjson(strtrim(srchFile)); % NOTE the use of strtrim
if isempty(srchResult)
    disp('No files matching query found');
elseif summarize
    nResults = length(srchResult);
    fprintf('Search results are in the file %s\n',srchFile);
    fprintf('The returned search cell contains %d entries\n',nResults);

    % Dump the data names
    fprintf('Result names\n');
    for ii=1:nResults
        fprintf('%3d:  %s\n',ii,srchResult{ii}.name)
    end

end

    
end
