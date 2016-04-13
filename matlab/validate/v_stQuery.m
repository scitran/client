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
% You should insert the string "_0x2E_".   In subject.age you should have
% subject_0x2E_age.
%
% If you do not include subject.age, then all ages will be returned.
%
% Because this is ugly, we might use the syntax _dot_ and then do a
% strrep(). Also, notice that gte means greater than or equal to, and lte
% for less than or equal to.
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


%% Does a search for bvec files.

% Set up the json payload the we send to define the search.
% In this case 
%  fields  - Which fields to search.  * means all.  'name' means name field
%  query   - String to search on
%  lenient - Things like allowing upper/lower case on the search
% We need a document on all the slots that we can fill.

clear jsonSend
jsonSend.multi_match.fields = '*';
jsonSend.multi_match.query = '.bvec';
jsonSend.multi_match.lenient = 'true';

% Convert
jsonData = savejson('',jsonSend);

% Build up the curl command.  We use s to denote the structure that
% contains the parameters used to create the command.
clear s
s.url    = furl;
s.token  = token;

% Could search on a collection, or if not set then we search on everything
% including acquisitions, sessions, whatever.  
s.collection = 'patients';

% The possible search targets are
%
%    Group, Project, Session, Acquisition and Files
%
% When you are looking for bvec files, then the target is files.  For other
% queries, say you are looking for age, then you would search for session
% because the age of a subject is attached to the session.
s.target = 'files';

s.body   = jsonData;

% This defines the search
disp(s)

%% Run the search 
[~, result] = system(stCommandCreate(s));

% Load the result file
scitranData = loadjson(strtrim(result)); % NOTE the use of strtrim
disp(scitranData{1}); % The rusults should come back in an array

% Dump the data names
for ii=1:length(scitranData)
    scitranData{ii}.type
    scitranData{ii}.name
end

fprintf('Returned %d matches\n',length(scitranData))

%% Downloads the first bvec file

% Build up the link to the data file 
% TODO:
%  We need a function that looks
%
%     plink = plinkCreate(url,acqID,filename)
%
plink = sprintf('%s/api/acquisitions/%s/files/%s', furl, scitranData{1}.acquisition.x0x5F_id, scitranData{1}.name);

% Download the file
% dl_file = stGet(plink, token);
% dl_file = stGet(plink, token, 'destination',fullfile(pwd,'deleteMe.bvec'));
dl_file = stGet(plink, token, 'destination',fullfile(pwd,'deleteMe.bvec'),'size',scitranData{1}.size);

% You can check the data in this case
bvecs = load(dl_file,'ascii');
hdl = mrvNewGraphWin;
plot3(bvecs(1,:),bvecs(2,:),bvecs(3,:),'o');
axis equal; 
print -dpng 'bvecs.png';

%% Put the image back up as an attachment

fName = fullfile(pwd,'bvecs.png');
[status, result] = stPut(fName, plink, token);

%%
urlAndName = https://flywheel.scitran.stanford.edu/api/acquisitions/56ea1534ddea7f915e81f7b9/files/bvecs.png



%%