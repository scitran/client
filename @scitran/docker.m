function [cmd, status, result] = docker(~,docker)
% Run the Docker Container with the parameters defined in the docker struct
%
%  ** DEPRECATED **
%
%  [cmd, status, result] = st.docker(docker)
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

%%
warning('%s command is deprecated',mfile);

%% Check input arguments
p = inputParser;
vFunc = @(x) (isstruct(x) && ...
    isfield(x,'container') && ...
    isfield(x,'iFile') &&isfield(x,'iDir') && ...
    isfield(x,'oFile') && isfield(x,'oDir'));
p.addRequired('docker',vFunc);

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