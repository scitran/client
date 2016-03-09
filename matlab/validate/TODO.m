%% Validation scripts we hope to write
%
% The scitranClient utilities are designed to interact with the scitran API
% that manages MR and related neuroimaging data.
%
% The utlities require user authentication to interact with the database.
% The basic capabilities we plan are simply for
%
%    * Search
%    * Download
%    * Upload
%
% We wil build utilities on top of those capabilities over time.
% What will be returned will be a mix of URLs to the data or in some cases
% the data themselves.
% The search will extend (a) through MongoDB only? or (b) through the
% Elastic search capabilities.
%
% Examples
%   Return all the diffusion scans for males between 12 and 15 years of age
%   Return the T1 scans for people in the ADNI project
%
% 
%
% LMP/BW Scitran Team, 2016

%% Check that the database is up

%% Authorization

%% Does a search

% Set up the structure that will be converted to json format
jsonSend.multi_match.fields = 'name';
jsonSend.multi_match.query = 't1.zip';
jsonSend.multi_match.lenient = true;

% Convert
jsonData = savejson('',jsonSend);

% Build up the curl command
curlcmd = ...
    sprintf('curl -XGET "https://docker.local.flywheel.io:8443/api/search/files?user=renzofrigato@flywheel.io&root=1" -k -d ');
syscommand = [curlcmd,'''',jsonData,''''];

% On your system, you must have curl libraries properly configured
cENV = configure_curl;
[status, result] = system(syscommand);
unconfigure_curl(cENV);

% Dump the data
scitranData = loadjson(result);
for ii=1:length(scitranData)
    scitranData{ii}.type
    scitranData{ii}.name
end


%% Does a download

%% Does an upload

%%