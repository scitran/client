function authAPIKey(obj, instance,varargin)
% Set the API key and url of an @scitran object
%
%    st.authAPIKey(instance, varargin)
%
% The API key is generated under the User -> Profile (typically upper right).
%
% This routine is invoked by the scitran constructor, and not usually
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
%  st = scitran('scitran','action', 'create')
%  st = scitran('local',  'action', 'refresh', )
%  st = scitran('myflywheel', 'action', 'remove')
%
% (C) Stanford VISTA Lab, 2016 - LMP

%%
p = inputParser;

p.addRequired('instance', @ischar);

actions = {'create', 'refresh', 'remove'};
p.addParameter('action', 'create', @(x) any(strcmp(x,actions)));
p.addParameter('verify',false,@islogical);

p.parse(instance,varargin{:})

verify   = p.Results.verify;
action   = p.Results.action;
instance = p.Results.instance;

obj.instance = instance;

%% Configure MATLAB warning messages

% Matlab warning ids to check (and turn off)
warn_ids = {'MATLAB:namelengthmaxexceeded'};

% Checks and turns off MATLAB warnings
for ii = 1:numel(warn_ids)
    w = warning('query', warn_ids{ii});
    if strcmpi(w.state, 'on')
        warning('off', warn_ids{ii});
    end
end


%% Load or create local token file

% Base directory to store user-specific files
% If the directory doesn't exist, make it.
if ispc, home = getenv('USERPROFILE');
else,    home = getenv('HOME');
end

stDir = fullfile(home, '.stclient');
if ~exist(stDir,'dir')
    mkdir(stDir);
end

% If the token file does not exist, then copy it from the path
tokenFile = fullfile(stDir, 'st_tokens');
obj.token = '';

if ~exist(tokenFile, 'file'),     st = {};
else,                             st = jsonread(tokenFile);
end

%% Adjust instance and client information

switch lower(action)
    case  'remove'
        % Remove the fields for this instance and save st_tokens file.
        st = rmfield(st, instance);
        st.url   = '';
        st.token = '';
        jsonwrite(tokenFile,st);
        
        
    case 'refresh'
        if ~isfield(st,instance)
            fprintf('No instance %s found. Cannot refresh.\n',instance);
        else
            % Found it.  So carry on.
            obj.url = st.(instance).client_url;
            prompt = sprintf('Would you like to refresh the API key for %s? (y/n): ', instance);
            response = input(prompt,'s');
            if lower(response) == 'y'
                % obj.token   = ['scitran-user ', input('Please enter the API key: ', 's')];
                obj.token   = input('Please enter the API key: ', 's');
                if isempty(obj.token)
                    disp('User canceled.');
                    return;
                else
                    st.(instance).token = obj.token;
                    st.(instance).client_url = obj.url;
                    jsonwrite(tokenFile,st);
                    fprintf('API key saved for %s.\n',instance);
                end
            else
                disp('User canceled.');
                return;
            end
        end
    case 'create'
        if isfield(st,instance)
            % Loading from st_tokens
            if verify,fprintf('API Key found for %s\n', instance); end
            obj.token = st.(instance).token;
            obj.url = st.(instance).client_url;
        else
            % Create a new instance and save data in st_tokens file.
            stNew(obj,st,instance,tokenFile);
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
newStr = strsplit(apiKey,':');
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

