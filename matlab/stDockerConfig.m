function status = stDockerConfig(varargin)
% 
%  status = stDockerConfig(varargin)
% 
% Configure the Matlab environment to allow docker calls from within
% Matlab.
%
% 
% INPUTS: 
% 
%       'machine' - [Optional, type=char, default='default'] 
%                   Name of the docker-machine on OSX. Should exist.
% 
%       'debug'   - [Optional, type=logical, default=false] 
%                   If true then messages are displayed throughout the
%                   process, otherwise we're quiet save for an error.
%       
%  OUTPUTS:
% 
%       status    - boolean where 0=success and >0 denotes failure.
% 
% 
%  EXAMPLE USAGE:
%       [status] = stDockerConfig('machine', 'default', 'debug', true); 
% 
% 
% 
% (C) Stanford VISTA Lab, 2016 
% 
% 

%% Parse input arguments

p = inputParser;
p.addParameter('machine', 'default', @ischar);
p.addOptional('debug', false, @islogical); 
p.parse(varargin{:})

args = p.Results;


%% Configure Matlab ENV for the machine


% MAC OSX
if ismac
    % By default, docker-machine is installed in /usr/local/bin:
    initPath = getenv('PATH');
    if isempty(strfind(initPath, '/usr/local/bin'))
        if args.debug
            disp('Adding ''/usr/local/bin'' to PATH.');
        end
        setenv('PATH', ['/usr/local/bin:', initPath]);
    end
    
    % Check that docker machine is installed
    [status, version] = system('docker-machine -v');
    if status == 0; 
        if args.debug; 
            fprintf('Found %s\n', version); 
        end
    else
        error('%s \nIs docker-machine installed?', version); 
    end
    
    % Get the docker env variables for the machine
    [status, docker_env] = system(sprintf('docker-machine env %s', args.machine));
    if status ~= 0; error(docker_env); end
    
    % Configure the Matlab ENV based on the machine ENV
    docker_env = strsplit(docker_env);
    docker_env_vars = {};
    for ii = 1:numel(docker_env)
        if strfind(docker_env{ii}, 'DOCKER')
            docker_env_vars{end+1} = docker_env{ii}; %#ok<AGROW>
        end
    end
    if args.debug  
        fprintf('Configuring docker-machine env for machine: [%s] ...\n', args.machine); 
    end
    for jj = 1:numel(docker_env_vars)
        env_var = strsplit(docker_env_vars{jj},'"');
        setenv(strrep(env_var{1},'=',''), env_var{2});
        if args.debug
            fprintf('%s=%s\n', strrep(env_var{1},'=',''), getenv(strrep(env_var{1},'=','')));
        end
    end
    
    % Check that the configuration worked
    [status, result] = system('docker ps -a');
    if status == 0
        if args.debug
            disp('Docker configured successfully!');
        end
    else
        error('Docker could not be configured: %s', result);
    end
    
    % Start the machine
    [~, result] = system(sprintf('docker-machine start %s', args.machine));
    if args.debug
        disp(result);
    end
    
    
% LINUX
elseif isunix
    % Check for docker
    [status, result] = system('docker ps -a');
    if status == 0
        if args.debug; disp('Docker configured successfully!'); end
    else
        error('Docker not configured: %s', result);
    end

    
% Not MAC or LINUX
else
    error('Platform [%s] not supported.', computer);
    
end

return