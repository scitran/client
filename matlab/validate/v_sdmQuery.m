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
% Notes on curl configuration
%
% On your system, you must have curl libraries properly configured.  Matlab
% has its own environment
%
%    cENV = configure_curl;
%       ... Your code here ...
%    unconfigure_curl(cENV);
%   
% LMP/BW Scitran Team, 2016


%% Get ready

% On your system, you must have curl libraries properly configured
cENV = configure_curl;

% Turn off the very annoying Matlab warning regarding variable name length
warning('off', 'MATLAB:namelengthmaxexceeded');


%% Authorization
% The auth returns both a token and the url of the flywheel instance
[token, furl, ~] = sdmAuth('action', 'create', 'instance', 'scitran');


%% Does a search

% The main information types for the scitran client are
%
%    Group, Project, Session, Acquisition and Files
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
% TODO: The lines commented below do not work.
% clear jsonSend
% jsonSend.range.subject_0x2E_age.gte=10;
% jsonSend.range.subject_0x2E_age.lte=20;
% jsonData = savejson('',jsonSend);

clear jsonSend
jsonSend.multi_match.fields = '*';
jsonSend.multi_match.query = '.bvec';
jsonSend.multi_match.lenient = 'true';
 
% Convert
jsonData = savejson('',jsonSend);

% Build up the curl command
clear s
s.url    = furl;
s.token  = token;
s.body   = jsonData;
s.target = 'files';
%s.collection = 'patients';
srchCMD = sdmCommandCreate(s);

%%
[~, result] = system(srchCMD);
scitranData = loadjson(strtrim(result)); % NOTE the use of strtrim
disp(scitranData{1});


%% Dump the data names
for ii=1:length(scitranData)
    scitranData{ii}.type
    scitranData{ii}.name
end

%%
clear jsonSend
jsonSend.multi_match.fields = '*';
jsonSend.multi_match.query = '.zip';
jsonSend.multi_match.lenient = 'true';

% Convert
jsonData = savejson('',jsonSend);

% Build up the curl command
clear s
s.url    = furl;
s.token  = token;
s.body   = jsonData;
s.target = 'files';
s.collection = 'patients';
[~, result] = system(sdmCommandCreate(s));

% Dump the data names
scitranData = loadjson(result);
for ii=1:length(scitranData)
    scitranData{ii}.type
    scitranData{ii}.name
end


%% Does a download

%% Does an upload

%%



%%