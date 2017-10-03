function cmd = updateCmd(obj, containerType, containerId, payload, varargin)
%
% Build the command to update a project/session/acquisition
% More info in the documentation for scitran.update
%
% RF 2016

% PROGRAMMING TODO
% Better type checking on the container strings
%

%%
p = inputParser;

% validType = {'project','session','acquisition','collection',''};
% @(x)(ismember(x,validType))
p.addRequired('containerType',@ischar);

p.addRequired('containerId',@ischar);
p.addRequired('payload',@ischar);
p.addParameter('replaceMetadata', 'false',@ischar);
p.parse(containerType, containerId, payload, varargin{:});

containerType      = p.Results.containerType;
containerId        = p.Results.containerId;
payload            = p.Results.payload;
replaceMetadata    = p.Results.replaceMetadata;

cmd = sprintf('curl -s -XPUT "%s/api/%s/%s?replace_metadata=%s" -H "Authorization":"%s" -k -d ''%s''',...
    obj.url, containerType, containerId, replaceMetadata, obj.token, payload);
end
