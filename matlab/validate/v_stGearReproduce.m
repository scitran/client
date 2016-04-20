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

% In this case, we appear to need 
%   dockerCmd
%   plink to data in scitran
%  


% stRepFile = 'st.rep';
% stRep = loadjson(stRepFile);

% This will load an stRep struct

% The plink will be in the file
clear stRep;
stRep.data.iDir = fullfile(pwd,'input');
stRep.data.iFile = lst{end};

stRep.data.oDir = fullfile(pwd,'output');
stRep.data.oFile = 'test_bet';   % Need oFile

stRep.inputPlink = inputPlink;  % If we decide to compare
stRep.resultPlink = resultPlink;  % If we decide to compare

stRep.docker.container = 'vistalab/bet';   % Need the container

% stRep.data.iFile.plink = downPlink;
% lst = strsplit(downPlink,'/');   % Need downPlink
% lst{end}

%% Set up the docker command

% Configure docker
stDockerConfig('machine', 'default');
stDirCreate(stRep.data.iDir);
stDirCreate(stRep.data.oDir);


%% Download the file from the scitran database

% Put the file in the destination location
dest = fullfile(stRep.data.iDir,stRep.data.iFile);
dl_file = stGet(stRep.inputPlink, token, 'destination',dest );

% Create and run the docker command.
stRep.docker.cmd = stDockerCommand(stRep.docker.container,stRep.data);
[status, result] = system(stRep.docker.cmd, '-echo');

if status ~= 0
    fprintf('docker error: %s\n', result);
end

%% See v_stQuery for related stuff

