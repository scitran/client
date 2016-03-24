%% Query the database
%
%    * Authorize
%    * Search
%
%
% LMP/BW Scitran Team, 2016

%% Authorization

token = sdmAuth('create','scitran');

%% Does a search

% Now, we can search for elements of the data model
%
%    https://github.com/scitran/core/wiki/Data-Model,-v2
%

% The main information types for the scitran client are
%
%    Group, Project, Session, Acquisition and Files
%
% There are other types that are used internally for the data model.
%

%% To search for subjects within that age and of a particular sex

loadjson('sdm_search1.json');

%% To search for all subjects of a certain age range and sex


%% To search for subjects of a certain age range, sex, and type of measurement
%
% The type of measurement is specified as 'measurement' in the Files group


%% 

%   subject age
%   subject sex
%   subject id
%
%   project name
%
%   session label
%
%   Acquisition measurement
%   


% Set up the structure that will be converted to json format
jsonSend.multi_match.fields = 'name';
jsonSend.multi_match.query = 't1.zip';
jsonSend.multi_match.lenient = true;

clear jsonSend

jsonSend.range.('subject.age').gte=10;

jsonSend.range.subject_0x2E_age.lte=20;

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

% Dump the data
scitranData = loadjson(result);
for ii=1:length(scitranData)
    scitranData{ii}.type
    scitranData{ii}.name
end


%% Does a download

%% Does an upload

%%