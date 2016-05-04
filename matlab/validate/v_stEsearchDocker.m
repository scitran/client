%% v_stEsearchDocker
%
%  Illustrates how we interaction from the command line with the scitran
%  database.
%
%  This example executes an FSL brain extraction tool (bet2) using data
%  from a scitran database. The processed data are placed back in the
%  scitran database in the 'Session Analyses' section.
%
%  Separately, we show how to create a "Reproducibility file".  This is a
%  json file that includes all the parameters required for running the
%  analysis again.
%
% LMP/BW, Scitran Team, 2016

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

%% Set up parameters for the docker container and run it

% Build the docker structure to run the container
clear docker
docker.iDir  = iDir;
docker.oDir  = oDir;

% The input file
docker.iFile =  fname;

% For this particular FSL tool (brain extraction) do this.
baseName = strsplit(docker.iFile,'.nii.gz');
docker.oFile  = [baseName{1},'_bet'];

% Set up which docker container to run
docker.container = 'vistalab/bet';

% The docker struct is essential for reproducibility
stDockerRun(docker);

%% Find the collection in the database

% We will upload the data to the Collection Analyses section
clear a
a.path = 'collections';                    
a.collections.match.label = b.collections.match.label;
s.json = a;
collections = stEsearchRun(s);

% Build a struct with the information needed to upload the analysis.
clear upload
upload.label = 'FSL bet2 analysis';      % Analysis label
upload.outputs{1}.name = [docker.oFile,'.nii.gz'];   % Name of the results file from vistalab/bet
upload.inputs{1}.name = docker.iFile;    % Name of the results file

% We could add elements to the upload structure, such as a description of
% the analysis (note), the name of the person who did the analysis.  These
% names are free form.

% Put the results in the database
stPutAnalysis(s, collections{1}, upload);

%% Go to the browser and have a look at the collection

% This will find me the sessions in FearTest
stBrowser(s.url,collections{1});

% This would be a more direct way to get to the web page
% clear b
% b.path = 'sessions';
% b.collections.match.label = 'GearTest';
% s.json = b;
% sessions = stEsearchRun(s);
% stBrowser(s.url,sessions{1},'collection',collections{1});


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