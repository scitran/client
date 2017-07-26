function authAPIKey(obj, instance,varargin)
% Set the API key and url of an @scitran object
%
%    st.authAPIKey(instance, varargin)
%
% For Flywheel sites, the API key is generated for the user on under the
% the 'user' name.
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
%  'verify'   - Print out messages verifying the site is found.s
%
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
stDir = fullfile(getenv('HOME'), '.stclient');
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
        
        % Never verify on a remove.
        verify = false;
        
    case 'refresh'
        if ~isfield(st,instance)
            fprintf('No instance %s found. Cannot refresh.\n',instance);
        else
            % Found it.  So carry on.
            obj.url = st.(instance).client_url;
            prompt = sprintf('Would you like to refresh the API key for %s? (y/n): ', instance);
            response = input(prompt,'s');
            if lower(response) == 'y'
                obj.token   = ['scitran-user ', input('Please enter the API key: ', 's')];
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
            obj = stNew(obj,st,instance,tokenFile);
        end
        
end

%% Verify by running a search on projects

% This is fast enough for a little test.s
if verify
    try
        fprintf('%d projects found\n',length(obj.search('projects')));
    catch ME
        rethrow(ME)
    end
end

end

%%
function obj = stNew(obj,st,instance,tokenFile)
% Get the URL and the API key

% In some cases, the API key copied from the site (e.g., Flywheel) has the
% url embedded in it.  We check for that.  If it is there, we do not ask
% for the url.  If it is not there, we do ask.
apiKey = input('Please enter the API key: ', 's');

% If there is a url embeded, then we get two cells
newStr = split(apiKey,':');
if isempty(newStr{1})
    disp('User canceled.');
    return;
elseif length(newStr) == 2
    obj.url = ['https://', newStr{1}];
    obj.token = ['scitran-user ', newStr{2}];
elseif length(newStr) == 1
    obj.token = ['scitran-user ', newStr{1}];
    % Didn't find it in the API string
    obj.url = input('Please enter the url (https://...): ', 's');
    if strcmp(obj.url(1:5),'http:')
        disp('*** Replacing http: with https: ***');
        obj.url = ['https:',obj.url(6:end)];
        disp(obj.url);
    end
end

st.(instance).token = obj.token;
st.(instance).client_url = obj.url;
jsonwrite(tokenFile,st);
fprintf('API key saved for "%s".\n',instance);

end

