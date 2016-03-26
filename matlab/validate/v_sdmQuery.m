%% Query the database
%
%    * Authorize
%    * Search
%
% When you want a dot in the search field, for example
%
% {
% 	"range": {
% 		"subject.age": {
% 			"gte": 10,
% 			"lte": 90
% 		}
% 	}
% }
% 
% You should insert the string "_0x2E_".   Because this is ugly, we might
% use the syntax _dot_ and then do a strrep()
%
%   
% LMP/BW Scitran Team, 2016

% On your system, you must have curl libraries properly configured
cENV = configure_curl;

%% Authorization

[token, furl, ~] = sdmAuth('action', 'create', 'instance', 'scitran');


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
% srch = loadjson('sdm_search1.json');
% 
% savejson('',srch,'tmp.json');
%% To search for all subjects of a certain age range and sex


%% To search for subjects of a certain age range, sex, and type of measurement
%
% The type of measurement is specified as 'measurement' in the Files group

%%  Build the json object
%
% We test with this one
%
% {
% 	"range": {
% 		"subject.age": {
% 			"gte": 10,
% 			"lte": 90
% 		}
% 	}
% }

% Convert the struct to a json data string that we will send.
clear jsonSend
jsonSend.range.subject_0x2E_age.gte=10;
jsonSend.range.subject_0x2E_age.lte=20;
jsonData = savejson('',jsonSend);

% Build up the curl command
clear s
s.url    = furl;
s.token  = token;
s.body   = jsonData;
s.target = 'sessions';
srchCMD = sdmCommandCreate(s);
[~, result] = system(srchCMD);

% Dump the data
scitranData = loadjson(result);
for ii=1:length(scitranData)
    scitranData{ii}.type
    scitranData{ii}.name
end


%% This command should fail
% 
% curlcmd = ...
%     sprintf('curl -XGET "https://docker.local.flywheel.io:8443/api/search/files?user=evilperson@flywheel.io&root=1" -k -d ');
% syscommand = [curlcmd,'''',jsonData,''''];
% 
% [status, result] = system(syscommand);
% 
% % Dump the data
% scitranData = loadjson(result);
% for ii=1:length(scitranData)
%     scitranData{ii}.type
%     scitranData{ii}.name
% end


%% Does a download

%% Does an upload

%%

unconfigure_curl(cENV);