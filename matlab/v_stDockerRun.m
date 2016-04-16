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

% Look in this field (label in this case; * means all fields)
jsonSend.multi_match.fields = '*';  
% jsonSend.multi_match.query = 'Anatomy_t1w';
% jsonSend.multi_match.query = 'nii.gz';
jsonSend.multi_match.query = '.nii.gz';   % The label we are looking for
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
s.collection = 'GearTest';

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
if isempty(searchResult)
    disp('No files matching query found');
else
    disp(searchResult{1}); % The rusults should come back in an array
    
    % Dump the data names
    for ii=1:length(searchResult)
        searchResult{ii}.name
    end
    
    fprintf('Returned %d matches\n',length(searchResult))
    
end

%% Find an anatomy t1 file

% Check that the measurement type is anatomy
for i = 1:numel(searchResult)
    if strfind(lower(searchResult{i}.acquisition.measurement), 'anatomy')
        indX = i;
        break
    end
end

% CHeck that this is an anatomical
% searchResult{indX}
searchResult{indX}.acquisition.measurement

%% Download the file
plink = sprintf('%s/api/acquisitions/%s/files/%s',...
    furl, searchResult{indX}.acquisition.x0x5F_id, searchResult{indX}.name);

dl_file = stGet(plink, token, 'destination', fullfile(pwd,searchResult{indX}.name),'size',searchResult{indX}.size);

% Create an output directory. Must start as empty!
% The engine takes anything in the output directory and uploads it.
outputDirectory = fullfile(pwd,'output');
if exist(outputDirectory,'dir')
    delete(fullfile(outputDirectory,'*'))
else 
    mkdir(outputDirectory);
end
    
%% Run docker

% Configure docker
stDockerConfig('machine', 'default');
% stDockerConfig('machine', 'vista'); 

% Run a docker container
baseName = strsplit(searchResult{indX}.name,'.nii.gz');
oFile = [baseName{1},'_bet'];
docker_cmd = sprintf('docker run -ti --rm -v %s:/input -v %s:/output vistalab/bet /input/%s /output/%s',...
    pwd, outputDirectory, searchResult{indX}.name, oFile);

[status, result] = system(docker_cmd, '-echo');

disp(status);
disp(result);


%% Upload the file as a session attachment

clear A
A.token     = token;
A.url       = furl;
A.fName     = fullfile(pwd, 'output',[oFile,'.nii.gz']);
A.target    = 'collections';
A.id        = searchResult{indX}.collection.x0x5F_id;

[status, result] = stAttachFile(A);
disp(status);
disp(result);

%%
