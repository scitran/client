%% v_stGearExample
%
%  Executes an FSL gear function using data from a scitran database.  
%
%  The processed output (in this case skull-stripped brain) is placed in
%  the scitran output along with the structure that describes the docker
%  container that ran the skull-stripping and other parameters needed for
%  reproducibility.
%
% LMP/BW

%%  Authorization and initialize

% Set up the parameters for authorization, the first time
st.action = 'create';     % Create a token
st.instance = 'scitran';  % Specify client

% Get the authorized token
[token, client_url] = stAuth(st);

%% Set up and execute a simple search 

% Build up the search command.
clear srch
srch.url    = client_url;
srch.token  = token;

% In this example, we search on a collection that we created called
% GearTest
srch.collection = 'GearTest';

% We are searching for files in the collection (as opposed to ...)
srch.target = 'files';

% We will set up more complex queries later.  But this is a simple one
srch.body   = stQueryCreate('fields','*','query','.nii.gz');

% We convert the srch structure to a curl command
srchCommand = stSearchCreate(srch);

% Run the search and return the results in a structure

%% Load the result file

[srchResult, srchFile] = stSearchRemote(srchCommand,'summarize',true);

%% Find an nii.gz that is an anatomy (t1) file

% Check that the measurement type is anatomy
indX = -1;
aa = 1;
for ii = 1:numel(srchResult)
    if strfind(lower(srchResult{ii}.acquisition.measurement), 'anatomy')
        indX(aa) = ii; aa = aa+1;
    end
end

% If we found one, choose it.
if indX(1) > 0
    fprintf('Found %d files\n',length(indX)); 
    idx = indX(1);   %Use the first one.  At some point we could loop
else
    fprintf('No anatomicals found\n');
end


%% Set up the docker command

% Configure docker
stDockerConfig('machine', 'default');

iDir    = fullfile(pwd,'input');
stDirCreate(iDir);

oDir = fullfile(pwd,'output');
stDirCreate(oDir);


%% Download the file from the scitran database

destFile = fullfile(iDir,srchResult{idx}.name);
dl_file = stFileDownload(client_url,token,srchResult{idx},'destination',destFile);

%% Set up parameters for the docker container and run it

% the input and output directories, and input file
d.iDir  = iDir;
d.oDir  = oDir;

% The file in the input directory.
iFile = srchResult{idx}.name;
d.iFile = iFile;

% For this particular FSL tool (brain extraction) do this.
baseName = strsplit(iFile,'.nii.gz');
d.oFile  = [baseName{1},'_bet'];
container = 'vistalab/bet';

% Here is the command.
docker_cmd = stDockerCommand(container,d);

%  run the docker command
[status, result] = system(docker_cmd, '-echo');

if status ~= 0
    fprintf('docker error: %s\n', result);
end

%% Upload the processed file to the collection

% The principle is to put enough stuff in here so we could run this script
% again and get the same result out.
clear A
A.token     = token;
A.url       = client_url;
A.fName     = fullfile(pwd, 'output',[d.oFile,'.nii.gz']);
A.target    = 'collections';
A.id        = srchResult{idx}.collection.x0x5F_id;
% A.container = 'vistalab/bet';

[status, result] = stFileUpload(A);

%%