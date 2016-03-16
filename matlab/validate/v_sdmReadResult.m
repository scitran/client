%% Read in the json file that is returned from a search
%
%    * Search
%    * Read in search result to a structure
%
% Do something
%
% LMP/BW Scitran Team, 2016


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

%% Should fail
curlcmd = ...
    sprintf('curl -XGET "https://docker.local.flywheel.io:8443/api/search/files?user=evilperson@flywheel.io&root=1" -k -d ');
syscommand = [curlcmd,'''',jsonData,''''];

% On your system, you must have curl libraries properly configured
cENV = configure_curl;
[status, result] = system(syscommand);
unconfigure_curl(cENV);

%% Read the data
scitranData = loadjson(result);
for ii=1:length(scitranData)
    scitranData{ii}.type
    scitranData{ii}.name
end


%% Does a download

%% Does an upload

%%