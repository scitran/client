%% v_stGearExample
%
%  Executes an FSL gear using data from a scitran database.  
%
%  The processed output (in this case skull-stripped brain) is placed in
%  the scitran output along with the structure that describes the docker
%  container that ran the skull-stripping and other parameters needed for
%  reproducibility.
%
%  In addition, we create a "Reproducibility file".  This is a json file
%  that includes the parameters required for running the analysis
%  again.
%
% LMP/BW

%%  Authorization 

% Get the authorized token
st = scitran('action', 'create', 'instance', 'scitran');

%% Search for a NIFTI T1 anatomical in the ENGAGE project 

[file, srchS] = st.search('files',...
    'project label','VWFA',...
    'file type','nifti',...
    'file measurement','anatomy_t1w',...
    'file name contains','Whole');

%% Find the subject for a file

RESULT   = file{1};
SUB_ID   = file{1}.source.session.subject.code;
FILENAME = file{1}.source.name;

%% RUN BET: #1 Configure docker/directories

% Configure docker
stDockerConfig('machine', 'default');
workingDir = fullfile(stRootPath,'local','gearBetTest');
mkdir(workingDir);
chdir(workingDir);
% Make input directory
iDir    = fullfile(pwd,'input');
stDirCreate(iDir);

% Make utput directory
oDir = fullfile(pwd,'output');
stDirCreate(oDir);

%% RUN BET: #2 Download the file from the scitran database
st.get(file{1},'destination',fullfile(workingDir,'input',FILENAME));

%% RUN BET: #3 Set up parameters for the docker container and run it

% Build the docker structure to run the container
clear docker
docker.iDir  = iDir;
docker.oDir  = oDir;

% The file in the input directory.
docker.iFile =  FILENAME;

% For this particular FSL tool (brain extraction) do this.
baseName = strsplit(docker.iFile,'.nii.gz');
docker.oFile  = [SUB_ID, '_', baseName{1},'_bet'];
docker.container = 'vistalab/bet';

% Here is the command
docker_cmd = stDockerCommand(docker);

%%  RUN the docker command
[status, result] = system(docker_cmd, '-echo');

if status ~= 0
    fprintf('docker error: %s\n', result);
end

%% Visualize - you are on your own.  But we have checked
%  1.  Freeview
%  2.  niftiView


%% UPLOAD: the processed/result file to the collection

% clear upload
% upload.token     = token;
% upload.url       = client_url;
% upload.fName     = fullfile(docker.oDir, [docker.oFile,'.nii.gz']);
% upload.target    = 'collections';
% upload.id        = RESULT.collection.x0x5Fid;
% 
% [status, result, resultPlink] = stFileUpload(upload);
% if status ~= 0
%     fprintf('Upload Error: %s\n', result);
% end


%%