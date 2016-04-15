% Run a docker container on a given search result
%
%
%
%

%%
% On your system, you must have curl libraries properly configured
cENV = configure_curl;

% Turn off the very annoying Matlab warning regarding variable name length
warning('off', 'MATLAB:namelengthmaxexceeded');


%% Authorization
% The auth returns both a token and the url of the flywheel instance
[token, furl, ~] = stAuth('action', 'create', 'instance', 'scitran');


%% Does a search for nifti files.

% Set up the json payload the we send to define the search.
% In this case
%  fields  - Which fields to search.  * means all.  'name' means name field
%  query   - String to search on
%  lenient - Things like allowing upper/lower case on the search
% We need a document on all the slots that we can fill.

clear jsonSend
jsonSend.multi_match.fields = '*';
jsonSend.multi_match.query = '.nii.gz';
jsonSend.multi_match.lenient = 'true';

% Convert to json
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
searchResult = loadjson(strtrim(result)); % NOTE the use of strtrim
disp(searchResult{1}); % The rusults should come back in an array

% Dump the data names
for ii=1:length(searchResult)
    searchResult{ii}.type
    searchResult{ii}.name
end

fprintf('Returned %d matches\n',length(searchResult))


%% Find an anatomy t1 file

for i = 1:numel(searchResult)
    if strfind(lower(searchResult{i}.acquisition.measurement), 'anatomy')
        indX = i;
        break
    end
end


%% Download the file
plink = sprintf('%s/api/acquisitions/%s/files/%s',...
    furl, searchResult{indX}.acquisition.x0x5F_id, searchResult{indX}.name);

dl_file = stGet(plink, token, 'destination', fullfile(pwd,searchResult{indX}.name),'size',searchResult{indX}.size);

% Create an output directory (must be empty!)
outputDirectory = fullfile(pwd,'output');
if ~exist(outputDirectory, 'dir')
    mkdir(outputDirectory);
end


%% Run docker

% Configure docker
% stDockerConfig('machine', 'default');
stDockerConfig('machine', 'vista'); 

% Run a docker container
docker_cmd = sprintf('docker run -ti --rm -v %s:/input -v %s:/output vistalab/bet /input/%s /output/%s',...
    pwd, outputDirectory, searchResult{indX}.name, 'brain_extracted');

[status, result] = system(docker_cmd, '-echo');

disp(status);
disp(result);


%% Upload the file as a session attachement

clear A
A.token     = token;
A.url       = url;
A.fName     = fullfile(pwd, 'output/brain_extracted.nii.gz');
A.target    = 'sessions';
A.id        = searchResult{indX}.session.x0x5F_id;

[status, result] = stAttachFile(A);
disp(status);
disp(result);
