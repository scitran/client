function authCLIKey(obj, instance,varargin)
% Set the API key and url of an @scitran object
%
%    st.authCLIKey(instance, varargin)
%
% The CLI key is generated under the User -> Profile in the section titled
% 'Getting Started with the CLIs
%
% This routine is invoked by the scicli constructor, and not usually
% needed by the user.
%
% REQUIRED INPUTS:
%  'instance' - String denoting the name of the @scitran instance.
%               Information about the instance (URL and API Key) is saved
%               in a json file in $HOME/.stclient/st_tokens.
%
% OPTIONAL INPUTS
%
%  'action' - 'create'  - [default] load an existing @scitran object.
%             'refresh' - refresh an existing @scitran object
%             'remove'  - remove an existing @scitran object from the
%                         tokens file.
% OUTPUTS:
%   @scitran object with url, instance name.  Token is private.
%
% EXAMPLES:
%  st = scicli('scitran','action', 'create')
%  st = scicli('local',  'action', 'refresh', )
%  st = scicli('myflywheel', 'action', 'remove')
%
% BW (C) Stanford VISTA Lab, 2018

%%
p = inputParser;

p.addRequired('instance', @ischar);

% The CLI Key can be created the first time, refreshed, or removed.
actions = {'create', 'refresh', 'remove'};
p.addParameter('action', 'create', @(x) any(strcmp(x,actions)));

% Not sure how we will verify.
p.addParameter('verify',false,@islogical);

p.parse(instance,varargin{:})

verify   = p.Results.verify;
action   = p.Results.action;
instance = p.Results.instance;

obj.instance = instance;


%% Load or create local token file

% Base directory to store user-specific files
% If the directory doesn't exist, make it.
stDir = fullfile(getenv('HOME'), '.stclient');
if ~exist(stDir,'dir')
    mkdir(stDir);
end

% If the token file does not exist, then copy it from the path
tokenFile = fullfile(stDir, 'cli_tokens');
obj.token = '';

if ~exist(tokenFile, 'file'),     cli = {};
else,                             cli = jsonread(tokenFile);
end

%% Adjust instance and client information

switch lower(action)
    case  'remove'
        % Remove the fields for this instance and save st_tokens file.
        cli = rmfield(cli, instance);
        cli.token = '';
        jsonwrite(tokenFile,cli);
        
        
    case 'refresh'
        if ~isfield(cli,instance)
            fprintf('No instance %s found. Cannot refresh.\n',instance);
        else
            % Found it.  So carry on.
            obj.url = cli.(instance).client_url;
            prompt = sprintf('Would you like to refresh the CLI key for %s? (y/n): ', instance);
            response = input(prompt,'s');
            if lower(response) == 'y'
                % obj.token   = ['scitran-user ', input('Please enter the API key: ', 's')];
                obj.token   = input('Please enter the API key: ', 's');
                if isempty(obj.token)
                    disp('User canceled.');
                    return;
                else
                    cli.(instance).token = obj.token;
                    cli.(instance).client_url = obj.url;
                    jsonwrite(tokenFile,cli);
                    fprintf('API key saved for %s.\n',instance);
                end
            else
                disp('User canceled.');
                return;
            end
        end
    case 'create'
        if isfield(cli,instance)
            % Loading from st_tokens
            if verify,fprintf('API Key found for %s\n', instance); end
            obj.token = cli.(instance).token;
            obj.url = cli.(instance).client_url;
        else
            % Create a new instance and save data in st_tokens file.
            stNew(obj,cli,instance,tokenFile);
        end
        
end

end

%%
function obj = stNew(obj,st,instance,tokenFile)
% We assume the user copied the apiKey from the Flywheel site.
% The apiKey format is URL:KEY, where URL is missing the https://
%
% We could check this.

apiKey = input('Please enter the API key (domain:key format): ', 's');
if isempty(apiKey)
    disp('User canceled');
    return;
end

% The part before the ':' is the URL.  Get it.
newStr = split(apiKey,':');
if length(newStr) < 2
    % Oops, there was no URL before the :
    ME = MException('FlywheelException:Invalid', 'Invalid API Key');
    throw(ME)
end

% Save the whole apiKey in the token slot.
obj.token = apiKey;
obj.url = ['https://', newStr{1}];

% Create and store the JSON representation in the tokenFile
st.(instance).token = obj.token;
st.(instance).client_url = obj.url;
jsonwrite(tokenFile,st);
fprintf('API key saved for "%s".\n',instance);

end

