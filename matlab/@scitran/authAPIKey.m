function [] = authAPIKey(obj, varargin)
% Set the token and url
%
%    status = auth(varargin)
%
% The authorization token is generated for the user on the website under
% the the 'user' name.
%
% In addition, there are several configuration steps that may be needed the
% first time you use scitran client in a session.  These initializations
% for the PATH configuration are managed here by the 'init' flag.
%
% INPUTS:
%
%  'action' - Token action to perform.
%             'create'  - [default] generate a new token. This will
%                         refresh the token if one exists.
%             'refresh' - refresh an existing token.
%             'remove'  - remove an existing token.
%
%  'instance' - String denoting the st instance to authorize
%               against. Information about the instance is saved
%               within a mat file (e.g. stAuth.mat) and loaded when
%               chosen. Default='sni_st' (sni-st.stanford.edu). New
%               instances will have to be added to this repo in the
%               correct format, with the client_id and client_secret
%               stored as vars in the mat file (for new connections
%               users are prompted for the client_secret.
%
% OUTPUTS:
%   obj.token   - string containing the token
%   obj.url     - the base url for the instance
%   status      - boolean where 0=success and >0 denotes failure.
%
% EXAMPLES:
%  st = scitran('action', 'create', 'instance', 'local')
%  st = scitran('action', 'refresh', 'instance', 'local')
%  st = scitran('action', 'remove', 'instance', 'local')
%
% (C) Stanford VISTA Lab, 2016 - LMP

%%
p = inputParser;

actions = {'create', 'refresh', 'remove'};
p.addParameter('action', 'create', @(x) any(strcmp(x,actions)));

p.addParameter('instance', 'scitran', @ischar);

p.parse(varargin{:})

action = p.Results.action;
instance = p.Results.instance;
if isempty(instance)
    disp('instance empty. Aborting...');
    return
end
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
stDir = fullfile(getenv('HOME'), '.stclient');
if ~exist(stDir,'dir')
    mkdir(stDir);
end

% If the file does not exist, then copy it from the path
tokenFile = fullfile(stDir, 'st_tokens');
obj.token = '';

if ~exist(tokenFile, 'file'),     st = {};
else                              st = loadjson(tokenFile);
end

%% Load instance and client information (used in python command)

% Check for client/instance info in the localAuthFile
% Prompt to add it if not found, then save it for next time.
if strcmp(action, 'remove')
    st = rmfield(st, instance);
    savejson('', st, tokenFile);
elseif ~isfield(st, instance) || strcmp(action, 'refresh')
    prompt = sprintf('Would you like to %s token for instance %s in your local config? (y/n): ', action, instance);
    response = input(prompt,'s');
    if lower(response) == 'y'
        if strcmp(action, 'refresh')
            obj.url = st.(instance).client_url;
        else
            obj.url = input('Please enter the url (https://...): ', 's');
            if strcmp(obj.url(1:5),'http:')
                disp('*** Replacing http: with https: ***');
                obj.url = ['https:',obj.url(6:end)];
                disp(obj.url);
            end
                
        end
        obj.token   = ['scitran-user ', input('Please enter the token: ', 's')];
        % Check that fields are not blank
        if isempty(obj.token) || isempty(obj.url);
            disp('One more more keys is empty, aborting');
            return;
        else
            st.(instance).token = obj.token;
            st.(instance).client_url = obj.url;
            savejson('', st, tokenFile);
            disp('Instance URL and token saved.');
        end
    else
        disp('Aborting');
        return
    end
else
    prompt = sprintf('\nAPI key found for instance %s', instance);
    disp(prompt)
    obj.token = st.(instance).token;
    obj.url = st.(instance).client_url;
end

%% Check that the url begins with https:, not http:

end
