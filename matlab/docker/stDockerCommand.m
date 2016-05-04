function dockerCommand = stDockerCommand(varargin)
% Create a docker command to run a container
%
%   dockerCommand = stDockerCommand(varargin)
%
% Inputs:
%    container - the Docker container to run
%
%    iDir -  Directory that will mount on /input
%    oDir -  Directory to mount on /output
%    iFile - Input file list for processing (cell array)
%    oFile - Output file list for processing (cell array)
%
% Output:
%    dockerCommand - This is the system command to run
%   
% LMP/BW Vistasoft, 2016

%%
p = inputParser;
p.addParameter('container',@ischar);
p.addParameter('iFile','notNamed',@ischar);
p.addParameter('oFile','notNamed',@ischar);
p.addParameter('iDir','input',@ischar);
p.addParameter('oDir','output',@ischar);
p.parse(varargin{:});

container = p.Results.container;
iDir  = p.Results.iDir;
oDir  = p.Results.oDir;
iFile = p.Results.iFile;
oFile = p.Results.oFile;

%% Build the command
dcmd =  'docker run -ti --rm -v ';

dockerCommand = ...
    sprintf('%s %s:/input -v %s:/output %s /input/%s /output/%s',...
    dcmd, iDir, oDir, container, iFile, oFile);

end