%% Running a Gear
%
%            *** The project on scientific transparency ***
%
%  Flywheel uses the term 'Gear' to describe the process of
%
%     * retrieving data from a scitran database,
%     * selecting the parameters, 
%     * analyzing the data with a program stored in a docker container, and
%     * placing the result and parameters into the database for
%       scientific transparency and reproducibility
%
% This script illustrates one simple Gear for anatomical processing
% (skull-stripping).  In this example, we execute a docker container built
% to run the FSL brain extraction tool (bet2). Data are retrieved from a
% scitran database and processed. The result are placed back in the scitran
% database.
%
% There will be many other gears for a very wide range of data processing
% purposes. We are building gears for (a) tractography, (b) cortical mesh
% visualization, (c) quality assurance, (d) tissue measurement, (e)
% spectroscopy, and ...
%
% Operating Gears will be possible from within the web browser via an
% easy-to-use graphic interface (pulldown menus and forms to set the
% parameters).
%
% This code shows the principles of what happens behind the graphical user
% interface in the browser window.
%
% This script illustrates how to interact from the command line with the
% scitran database using Matlab. There is also a Python interface.  Using
% these command line tools, you can build your own Gears.
%
% We are committed to making our code and parameters transparent, and we
% are committed to helping you create and share your own Gears.  That's
% why we call this the project on scientific transparency!
%
% LMP/BW, Scitran Team, 2016

%%  Authorization 

% Get authorization to read from the database
[s.token, s.url] = stAuth('action', 'create', 'instance', 'scitran');

%% Configure your local computer to run docker containers

% A docker container is a virtual machine that can be copied to almost any
% computer and run there.  We can have many different docker containers
% that execute all kinds of data processing

% Docker containers can run either locally, on your machine, or on a remote
% computer in the Cloud.  In this example, we will run the brain extraction
% tool from FSL, which we have installed in a docker container.
stDockerConfig('machine', 'default');

% Make an empty directory for the input to the docker container
iDir    = fullfile(pwd,'input');
stDirCreate(iDir);

% Make an empty directory for the output from the docker container
oDir = fullfile(pwd,'output');
stDirCreate(oDir);

%% Execute a simple search 

% This search could also be done from the browser interface

% We are searching for T1 weighted files in the GearTest collection.
clear b
b.path = 'files';                         % Looking for files

% These files match the following properties
b.collections.match.label  = 'GearTest';   % In this collection
b.acquisitions.match.label = 'T1w';        % Acquisition T1w
b.files.match.type         = 'nifti';      % A nifti type

% Attach the search terms to the json field in the search structure
s.json = b;

% Run the search and get information about files
files = stEsearchRun(s);

%% Get the file from the scitran database

% Execute the docker container on one file.  This could be a loop.
fname = files{1}.source.name;
destFile = fullfile(iDir, fname);

% Get the file from the database
stGet(files{1}.plink,s.token,'destination',destFile);

%% Set up for the brain extraction tool docker container and run it

% Build the docker structure to run the container
clear docker
docker.iDir  = iDir;
docker.oDir  = oDir;

% The input file
docker.iFile =  fname;

% For this particular FSL tool (brain extraction) do this.
baseName = strsplit(docker.iFile,'.nii.gz');
docker.oFile  = [baseName{1},'_bet'];

% Indicate that we want to run the brain extraction tool (bet) docker
% container
docker.container = 'vistalab/bet';

% The docker struct and the files cell array contains the information
% needed for reproducibility
stDockerRun(docker);

%% Upload the result to the collection in the database

% Find information about the Collection so we can upload
clear a
a.path = 'collections';                    
a.collections.match.label = b.collections.match.label;
s.json = a;
collections = stEsearchRun(s);

% Build a struct with the information needed to upload the results
clear upload
upload.label = 'FSL bet2 analysis';      % Analysis label
upload.outputs{1}.name = [docker.oFile,'.nii.gz'];   % Name of the results file from vistalab/bet
upload.inputs{1}.name = docker.iFile;    % Name of the results file

% Store the result in the database
stPutAnalysis(s, collections{1}, upload);

%% Go to the browser and have a look at the collection

stBrowser(s.url,collections{1});

%%




































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

