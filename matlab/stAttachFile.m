function [status, result] = stAttachFile(varargin)
%
% Upload a file as an attachment to a given target ('project', 'session',
% 'acquisition') within a SciTran DB.
%
%      stAttachFile(varargin)
%
% INPUTS: 
%   
%   fName:   [Required, type=char] Full path to the file on disk to
%            attach/put/upload
%   
%   target:  [Required, type=char, valid='projects', 'sessions', 'acquisitions'] 
%            Target for the attachment
%   
%   id:      [Required, type=char] Id of the target
%   
%   url:     [Required, type=char] URL for the instance
%   
%   token:   [Required, type=char] Authorization token for upload
% 
% 
% OUTPUTS:
%   
%   status:  Boolean indicating success (0) or failure (~=0)
%   
%   result:  The output of the verbose curl command.
%
% 
% Example:
%   [A.token, A.url] = stAuth('instance', 'scitran');
%   A.fName = '/Users/lmperry/test.txt';
%   A.target = 'session';
%   A.id    = '8277393993jd78djd7393k';
% 
%   [status, result] = stAttachFile(A);
% 
% 
% LMP/BW Vistasoft Team, 2015-16
% 


%% Parse inputs

% Allowed targets
targets = {'sessions', 'acquisitions', 'projects'};

p = inputParser;
p.addParameter('fName', @(x) ischar(x) && exist(x, 'file'));
p.addParameter('target', @(x) ischar(x) && ismember(x, targets));
p.addParameter('id', @ischar);
p.addParameter('url', @ischar);
p.addParameter('token', @ischar);

p.parse(varargin{:});

args = p.Results;


%% Configure library paths for curl command to work properly

curENV = configure_curl();


%% Build and execute the curl command

curl_cmd = sprintf('curl -F "file=@%s" %s/api/%s/%s/files -H "Authorization:%s"',...
    args.fName, args.url, args.target, args.id, args.token);

% Execute the command
fprintf('Sending... ');
[status, result] = system(curl_cmd);

% Let the user know if it worked
if status ~= 0
    warning('Upload failed');
    disp(result)
else
    fprintf('File sucessfully uploaded.\n');
end


%% Reset library paths

unconfigure_curl(curENV);


return














