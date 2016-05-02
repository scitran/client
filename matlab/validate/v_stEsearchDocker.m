%% v_stEsearchDocker
%
%  Same as v_stEngageExample except using elastic search routines
%
%  Executes an FSL gear function using data from a scitran database.  
%
%  The processed output (in this case skull-stripped brain) is placed in
%  the scitran output along with the structure that describes the docker
%  container that ran the skull-stripping and other parameters needed for
%  reproducibility.
%
%  TODO: Create a "Reproducibility file".  This is a json file
%  that includes all the parameters required for running the analysis
%  again.
%
%  The necessary parameters are just
%    fname
%    plink{1}
%    container
%    docker
%
% LMP/BW

%%  Authorization 

% Get the authorized token
[srch.token, srch.url] = stAuth();

%% Set up and execute a simple search 

clear b
b.path = 'files';                         % Looking for T1 weighted files
b.collections.match.label = 'GearTest';   
b.acquisitions.match.label = 'T1w 1mm';   % Description column
fname = '11810_8_1.nii.gz';
b.files.match.name = fname;

% b.acquisitions.match.type  = 'nifti';
s.json = savejson('',b);
[data, plink] = stEsearchRun(s);
fprintf('Found %d matching files\n',length(data))


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

destFile = fullfile(iDir, fname);
dl_file = stGet(plink{1},s.token,'destination',destFile);
fprintf('Downloaded: %s\n', dl_file);


%% RUN BET: #3 Set up parameters for the docker container and run it

% Build the docker structure to run the container
clear docker
docker.iDir  = iDir;
docker.oDir  = oDir;

% The file in the input directory.
docker.iFile =  fname;

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

% It would be nice to have the collection id from the previous search
clear b
b.path = 'collections';                         % Looking for T1 weighted files
b.collections.match.label = 'GearTest';   
s.json = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d collection(s) named %s\n',length(data.collections),b.collections.match.label);
id = data.collections{1}.x0x5F_id;

% Now get ready for the upload
clear upload
upload.token     = token;
upload.url       = client_url;
upload.fName     = fullfile(docker.oDir, [docker.oFile,'.nii.gz']);
upload.target    = 'collections';
upload.id        = id;

[status, result, resultPlink] = stFileUpload(upload);
if status ~= 0
    fprintf('Upload Error: %s\n', result);
end


%%