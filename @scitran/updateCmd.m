function cmd = updateCmd(obj, containerType, containerId, payload, varargin)

% Build the command to updaate a project/session/acquisition
%
%
% RF
p = inputParser;
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
