function cmd = deleteContainerCmd(obj, containerType, containerID)

p = inputParser;
p.addRequired('containerType',@ischar);
p.addRequired('containerID',@ischar);
p.parse(containerType, containerID);
containerType      = p.Results.containerType;
containerID        = p.Results.containerID;

cmd = sprintf('curl -s -XDELETE "%s/api/%s/%s" -H "Authorization":"%s" -k',...
    obj.url, containerType, containerID, obj.token);
end