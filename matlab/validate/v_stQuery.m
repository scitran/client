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
[token, furl, ~] = stAuth('action', 'create', 'instance', 'scitran');


%% Does a search

% The main information types (targets) for the scitran client are
%
%    Group, Project, Session, Acquisition and Files
%
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

% Run the search 
[~, result] = system(stCommandCreate(s));

% Load the result file
scitranData = loadjson(strtrim(result)); % NOTE the use of strtrim
disp(scitranData{1}); % The rusults should come back in an array

% Dump the data names
for ii=1:length(scitranData)
    scitranData{ii}.type
    scitranData{ii}.name
end


%% Searches a collection

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
[~, result] = system(stCommandCreate(s));

% Dump the data names
scitranData = loadjson(strtrim(result));
for ii=1:length(scitranData)
    scitranData{ii}.type
    scitranData{ii}.name
end


%% To search for all subjects of a certain age range and sex


%% To search for subjects of a certain age range, sex, and type of measurement
%
% The type of measurement is specified as 'measurement' in the Files group
%
% {
% 	"range": {
% 		"subject.age": {
% 			"gte": 10,
% 			"lte": 90
% 		}
% 	}
% }


%% Does a download

% Build up the link to the data file 
%TODO: This should be a subfunction in stGet
plink = sprintf('%s/api/acquisitions/%s/files/%s', furl, scitranData{1}.acquisition.x0x5F_id, scitranData{1}.name);

% Download the file
dl_file = stGet(plink, [], token);

% Verify file size  
% TODO: this should be baked in to stGet
dlf = dir(dl_file);
if isequal(dlf.bytes, scitranData{1}.size)
    disp('File downloaded and same size');
else
    disp('Something went wrong');
end




%% Does an upload

%%



%%