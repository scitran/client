function cmd = createCmd(obj, containerType, payload, varargin)
% Build the command to create a project/session/acquisition
%
%
%
% RF/BW Scitran Team, 2016
p = inputParser;
p.addRequired('containerType',@ischar);
p.addRequired('payload',@ischar);
p.parse(containerType, payload, varargin{:});

containerType      = p.Results.containerType;
payload            = p.Results.payload;

cmd = sprintf('curl -s -XPOST "%s/api/%s" -H "Authorization":"%s" -k -d ''%s''',...
    obj.url, containerType, obj.token, payload);
cmd = regexprep(cmd, '\n|\t', ' ');
cmd = regexprep(cmd, ' *', ' ');

end
