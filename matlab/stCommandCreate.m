function cmd = stCommandCreate(varargin)
% Create the system command for the flywheel database query
%
%   cmd = stCommandCreate('url',url, ...
%                          'token', token, ...
%                          'target',{'sessions','acquisitions','files','projects'}, ...
%                          'body', jsonBody);
%
% Example:
%  s.url    = furl;
%  s.token  = token;
%  s.body   = jsonData;
%  s.target = 'sessions';
%  syscommand = stCommandCreate(s);
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

% Set the number of search results desired (does not work with collection
% searches)
num_results = 50;

%% Build the search command
if isempty(collection)
    cmd = sprintf('curl -XGET "%s/api/search/%s%s" -H "Authorization":"%s" -H "Content-Type:application/json" %s -s -d ''%s'' > %s && echo "%s"',...
        url, target, ['?size=', num2str(num_results)], token, insecureFlag, body, result_json_file, result_json_file);
else
    cmd = sprintf('curl -XGET "%s/api/search/%s%s" -H "Authorization":"%s" -H "Content-Type:application/json" %s -s -d ''%s'' > %s && echo "%s"',...
        url, target, ['?collection=', collection], token, insecureFlag, body, result_json_file, result_json_file);   
    
end

end





