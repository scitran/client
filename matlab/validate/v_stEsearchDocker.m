%% v_stEsearchDocker
%
%  Based on v_stEngageExample except using elastic search
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
[s.token, s.url] = stAuth('action', 'create', 'instance', 'scitran');

%% Configure docker/directories

% This is one time on the local machine.

% Configure docker
stDockerConfig('machine', 'default');

% Make input directory
iDir    = fullfile(pwd,'input');
stDirCreate(iDir);

% Make utput directory
oDir = fullfile(pwd,'output');
stDirCreate(oDir);

%% Set up and execute a simple search 

% This search and many like it should be generated from a GUI interface
% that helps with selecting the possible options.

% We are looking for T1 weighted 1mm files in the GearTest collection.
clear b
b.path = 'files';                         % Looking for files

% These files are
b.collections.match.label  = 'GearTest';   % In this collection
b.acquisitions.match.label = 'T1w';        % Acquisition T1w 1mm
b.files.match.type         = 'nifti';      % The nifti type

% Attach the search terms to the json field in the search structure
s.json = b;

% Run the search
files = stEsearchRun(s);

% What files did we find?
fprintf('Found %d matching files\n',length(files))
for ii=1:length(files)
    fprintf('%d  %s\n',ii,files{ii}.source.name);
end

%% RUN BET: #2 Download the file from the scitran database

% This could be a loop for files{}.  But for now, just execute on one files
fname = files{1}.source.name;
destFile = fullfile(iDir, fname);
dl_file = stGet(files{1}.plink,s.token,'destination',destFile);
fprintf('Downloaded: %s\n', dl_file);

%% RUN BET: Set up parameters for the docker container and run it

% Build the docker structure to run the container
clear docker
docker.iDir  = iDir;
docker.oDir  = oDir;

% The file in the input directory.
docker.iFile =  fname;

% For this particular FSL tool (brain extraction) do this.
baseName = strsplit(docker.iFile,'.nii.gz');
docker.oFile  = ['subject', '_', baseName{1},'_bet'];
container = 'vistalab/bet';

% Here is the command
docker_cmd = stDockerCommand(container,docker);

% RUN the docker command
[status, result] = system(docker_cmd, '-echo');

if status ~= 0
    fprintf('docker error: %s\n', result);
end

%% Upload to the collection analyses window

% Get the collection ID 
b.path = 'collections';                         % Looking for files
b.collections.match.label  = 'GearTest';   % In this collection
s.json = b;
collections = stEsearchRun(s);

COL_ID = collections{1}.id;

% Construct the json payload
% .label and .files are required.
% We can add elements to the structure, such as a description of the
% analysis (note), the name of the person who did the analysis.  These
% names are free form. Hmmm.
clear payload
payload.label = 'FSL bet2 analysis';      % Analysis label
payload.outputs{1}.name = [docker.oFile,'.nii.gz'];   % Name of the results file
payload.outputs{end+1}.name = '';         % We have to pad the json struct or savejson will not give us a list

payload.inputs{1}.name = docker.iFile;    % Name of the results file
payload.inputs{end+1}.name = '';          % We have to pad the json struct or savejson will not give us a list

% Jsonify the payload
PAYLOAD = savejson('',payload);
PAYLOAD = strrep(PAYLOAD, '"', '\"');   % Escape the " or the cmd will fail.

% Location of analysis file on disk
outAnalysis = fullfile(pwd, 'output',payload.outputs{1}.name);
inAnalysis  = fullfile(pwd, 'input', payload.inputs{1}.name);

% Construct the command
% curlCmd = sprintf('curl -F "file=@%s" -F "metadata=%s" %s/api/collections/%s/analyses -H "Authorization":"%s"', analysis_file, PAYLOAD, furl, COL_ID, token );
curlCmd = sprintf('curl -F "file1=@%s" -F "file2=@%s" -F "metadata=%s" %s/api/collections/%s/analyses -H "Authorization":"%s"', inAnalysis, outAnalysis, PAYLOAD, furl, COL_ID, token );

%% Run the command
[status, result] = stCurlRun(curlCmd);

% This will find me the sessions in FearTest
clear b
b.path = 'sessions';
b.collections.match.label = 'GearTest';
s.json = b;
sessions = stEsearchRun(s);

stBrowser(s.url,sessions{1});


%% Display the resulting analysis ID (as json)
% disp(result);
% 
% % Load the json result
% R = loadjson(result); % Has x0x5F_id field
% 
% % Display the analysis id
% fprintf('Analysis id: %s \n', R.x0x5F_id);


%% UPLOAD: the processed/result file to the collection (OLD)

% It would be nice to have the collection id from the previous search
% clear b
% b.path = 'collections';                         % Looking for T1 weighted files
% b.collections.match.label = 'GearTest';   
% s.json = savejson('',b);
% data = stEsearchRun(s);
% fprintf('Found %d collection(s) named %s\n',length(data.collections),b.collections.match.label);
% id = data.collections{1}.x0x5F_id;
% 
% % Now get ready for the upload
% clear upload
% upload.token     = token;
% upload.url       = client_url;
% upload.fName     = fullfile(docker.oDir, [docker.oFile,'.nii.gz']);
% upload.target    = 'collections';
% upload.id        = id;
% 
% [status, result, resultPlink] = stFileUpload(upload);
% if status ~= 0
%     fprintf('Upload Error: %s\n', result);
% end


%%