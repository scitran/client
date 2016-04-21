%% v_stGearReproduce
%
% Reads a scitran reproducibility file (json format) and executes the gear
% on the same data.
%
% LMP/BW  Vistasoft Team, 2016

%%  Authorization and initialize

% Set up the parameters for authorization, the first time
st.action = 'create';     % Create a token
st.instance = 'scitran';  % Specify client

% Get the authorized token
[token, client_url] = stAuth(st);

%% What should be in the reproducibility file?

% The reproducibility permalink comes either from the web site or from the
% upload script v_stGearExample
repPlink = 'https://flywheel.scitran.stanford.edu/api/collections/57117f9e981f740020aa8932/files/11810_8_1_bet.json';

% We write it out here
lst = strsplit(repPlink,'/'); 
destination = fullfile('output',lst{end});
dl_file = stGet(repPlink,token,'destination',destination);

stRep = loadjson(dl_file);

%% Set up the docker command

% Configure docker
stDockerConfig('machine', 'default');
stDirCreate(stRep.data.iDir);
stDirCreate(stRep.data.oDir);

%% Download the file from the scitran database

% Put the file in the destination location
dest    = fullfile(stRep.data.iDir,stRep.data.iFile);
dl_file = stGet(stRep.inputPlink, token, 'destination',dest );

% Create and run the docker command.
stRep.docker.cmd = stDockerCommand(stRep.docker.container,stRep.data);
[status, result] = system(stRep.docker.cmd, '-echo');

if status ~= 0
    fprintf('docker error: %s\n', result);
end

%% We could download the file from the site and compare ...

%% See v_stQuery for related stuff

