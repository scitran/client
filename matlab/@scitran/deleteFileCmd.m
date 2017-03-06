function cmd = deleteFileCmd(obj, containerType, containerID, filename)

p = inputParser;
p.addRequired('containerType',@ischar);
p.addRequired('containerID',@ischar);
p.addRequired('filename',@ischar);
p.parse(containerType, containerID, filename);
containerType      = p.Results.containerType;
containerID        = p.Results.containerID;
filename           = p.Results.filename;

cmd = sprintf('curl -s -XDELETE "%s/api/%s/%s/files/%s" -H "Authorization":"%s" -k',...
    obj.url, containerType, containerID, filename, obj.token);
end