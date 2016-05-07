%% v_stGearExample
%
%  Executes an FSL gear function using data from a scitran database.  
%
%  The processed output (in this case skull-stripped brain) is placed in
%  the scitran output along with the structure that describes the docker
%  container that ran the skull-stripping and other parameters needed for
%  reproducibility.
%
%  In addition, we create a "Reproducibility file".  This is a json file
%  that includes all the parameters required for running the analysis
%  again.
%
% LMP/BW

%%  Authorization 

% Get the authorized token
[token, client_url] = stAuth();

%% Set up and execute a simple search 

% [status, result] = stQuery()

% Build up the search command.
clear srch
srch.url    = client_url;
srch.token  = token;

% In this example, we search on a collection that we created called
% GearTest
srch.collection = 'ENGAGE';

% We are searching for files in the collection (as opposed to ...)
srch.target = 'files';

% We will set up more complex queries later.  But this is a simple one
srch.body   = stQueryCreate('fields','type','query','nifti');

% We convert the srch structure to a curl command
srchCommand = stSearchCreate(srch);

% Run the search and return the results in a structure

%% Load the result file

[srchResult, srchFile] = stSearchRemote(srchCommand,'summarize',true);


%% Find an nii.gz that is an anatomy (t1) file

inds = stSearchResultFilter(srchResult, 'measurement', 'anatomy');

% If we found one, choose it.
if ~isempty(inds) 
    fprintf('Found %d files: %s\n',length(inds)); 
    disp(inds);
    idx = inds(1); % Choose the first one
else
    fprintf('No anatomicals found\n');
end

% This is what our search found us
RESULT = srchResult{idx};
SUB_ID = RESULT.session.subject.code;


%% RUN BET: #1 Configure docker/directories

% Configure docker
stDockerConfig('machine', 'default');

% Make input directory
iDir    = fullfile(pwd,'input');
stDirCreate(iDir);

% Make utput directory
oDir = fullfile(pwd,'output');
stDirCreate(oDir);


%% RUN BET: #2 Download the file from the scitran database

destFile = fullfile(iDir, RESULT.name);
[dl_file, inputPlink] = stFileDownload(client_url, token, RESULT, 'destination', destFile);
fprintf('Downloaded: %s\n', dl_file);


%% RUN BET: #3 Set up parameters for the docker container and run it

% Build the docker structure to run the container
clear docker
docker.iDir  = iDir;
docker.oDir  = oDir;

% The file in the input directory.
docker.iFile =  RESULT.name;

% For this particular FSL tool (brain extraction) do this.
baseName = strsplit(docker.iFile,'.nii.gz');
docker.oFile  = [SUB_ID, '_', baseName{1},'_bet'];
container = 'vistalab/bet';

% Here is the command
docker_cmd = stDockerCommand(container,docker);

%  RUN the docker command
[status, result] = system(docker_cmd, '-echo');

if status ~= 0
    fprintf('docker error: %s\n', result);
end


%% UPLOAD: the processed/result file to the collection

clear upload
upload.token     = token;
upload.url       = client_url;
upload.fName     = fullfile(docker.oDir, [docker.oFile,'.nii.gz']);
upload.target    = 'collections';
upload.id        = RESULT.collection.x0x5F_id;

[status, result, resultPlink] = stFileUpload(upload);
if status ~= 0
    fprintf('Upload Error: %s\n', result);
end


%%