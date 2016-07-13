function [status, result] = stCurlRun(curl_command)
%  Execute any 'curl' command, setting/resetting ENV variables. 
% 
%       [status, result] = stCurlRun(curl_command)
% 
% This function handles the configuration of the Matlab's ENV to allow Curl
% commands to be executed properly on a MAC or LINUX system. It will
% configure the ENV, execute (via 'system') the curl command, and then
% reset the ENV to its previous state.
% 
% 
% INPUT: 
%       curl_command: [type=char] The curl command to be executed. Valid
%                     inputs are of type char and contain the string
%                     'curl'.
% 
% OUTPUT:
%       status: [type=double] Boolean denoting success (0) or failure (~0).
%                             Note that this only indicates that the
%                             command ran successfully, not that you got
%                             the result you wanted - 'result' output
%                             should be monitored.
%       result: [type=char] The result (output) of the command. 
% 
% 
% EXAMPLE:
% 
%       curl_cmd = sprintf('/usr/bin/curl -v -X GET "%s" -H "Authorization":"%s" -o %s\n', pLink, token, destination);
%       [status, result] = stCurlRun(curl_cmd);
% 
% 
% SciTran team (LMP/BW) - 2016 
% 

%% Parse input 

p = inputParser;
p.addRequired('curl_command',@(x) ischar(x) && any(strfind(x, 'curl')));
p.parse(curl_command);

args = p.Results;


%% Configure the ENV for curl

% MAC
if ismac
    curENV = getenv('DYLD_LIBRARY_PATH');
    setenv('DYLD_LIBRARY_PATH','');
% Linux
elseif (isunix && ~ismac)
    curENV = getenv('LD_LIBRARY_PATH');
    setenv('LD_LIBRARY_PATH','/usr/lib:/usr/local/lib'); 
% Other/Unknown
else
    error('Unsupported system.\n');
end


%% Run the curl command

[status, result] = system(args.curl_command);
if status ~= 0 || ~isempty(strfind(lower(result), 'status_code'))
    warning('stCulrRun: %s\n', result);
end

%% Reset the ENV

% Reset library paths
if ismac
    setenv('DYLD_LIBRARY_PATH',curENV);
elseif (isunix && ~ismac)
    setenv('LD_LIBRARY_PATH',curENV);
else
    error('Unsupported system.\n');
end

return