function [cmd, status, result] = docker(obj,docker)
% Run the container with the parameters in the docker struct
%
%  [cmd, status, result] = stDockerRun(docker)
%
% Inputs - docker is a struct with the following fields
%
%   container  - Name of docker container on docker hub
%   iFile      - input file
%   iDir       - input directory
%   oFile      - output file
%   oDir       - output directory
%
% See also:  stDockerCommand
%
% BW/LMP Scitran Team, 2016

%% Check input arguments
p = inputParser;
p.addRequired('docker',@isstruct);
p.parse(docker);
docker = p.Results.docker;

%% Create and run the command
cmd = stDockerCommand(docker);

[status, result] = system(cmd, '-echo');

% Not catching error correctly.
if status ~= 0
    fprintf('docker error: %s\n', result);
else
    fprintf('%s returned successfully\n',docker.container)
end

end