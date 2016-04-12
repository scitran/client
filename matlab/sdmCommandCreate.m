function cmd = sdmCommandCreate(varargin)
% Create the system command for the flywheel database query
%
%   cmd = sdmCommandCreate('url',url, ...
%                          'token', token, ...
%                          'target',{'sessions','acquisitions','files','projects'}, ...
%                          'body', jsonBody);
%
% Example:
%  s.url    = furl;
%  s.token  = token;
%  s.body   = jsonData;
%  s.target = 'sessions';
%  syscommand = sdmCommandCreate(s);
%  system(syscommand)
%
% LMP/BW Vistasoft team, 2016

%% Parse the inputs
p = inputParser;
p.PartialMatching = false;
p.CaseSensitive   = true;

p.addParameter('token','',@ischar);
p.addParameter('body','',@ischar);

% The url should be secure
vFunc = @(x) isequal(x(1:6),'https:');
p.addParameter('url','https://flywheel.scitran.stanford.edu',vFunc);

% Default we are searching the full database.  But the user could say
% search a specific collection only.
p.addParameter('collection','',@ischar);

% These are the options.  Could do this in reverse order ... check for a
% valid string after finding the target parameter (below)
vStrings = {'sessions','acquisitions','files','projects'};
vFunc = @(x) any(strcmp(x,vStrings));
p.addParameter('target','sessions',vFunc);

% Parse
p.parse(varargin{:});

token  = p.Results.token;
body   = p.Results.body;
target = p.Results.target;
url    = p.Results.url;
collection = p.Results.collection;

% If this is a local instance we need to insert the 'insecure' flag
if strfind(url, 'docker.local') 
    insecureFlag = ' -k ';
else
    insecureFlag = '';
end

% Write out the result to a json file
result_json_file = [tempname, '.json'];

%% Build the search command
if isempty(collection)
    cmd = sprintf('curl -XGET "%s/api/search/%s?size=15" -H "Authorization":"%s" -H "Content-Type:application/json" %s -s -d ''%s'' > %s && echo %s',...
        url, target, token, insecureFlag, body, result_json_file, result_json_file);
else
    cmd = sprintf('curl -XGET "%s/api/search/%s?collection=%s" -H "Authorization":"%s" -H "Content-Type:application/json" %s -s -d ''%s'' > %s && echo %s',...
        url, target, collection, token, insecureFlag, body, result_json_file, result_json_file);   
    
end

end





