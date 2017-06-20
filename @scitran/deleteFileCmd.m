function cmd = deleteFileCmd(obj, containerType, containerID, filename)
% Create a command that deletes a file from a container
% 
% example:
% 
%   st = scitran('scitran', 'action', 'create');
%   cmd = st.deleteFileCmd('sessions', '58d470397c09ef001ceaa005', 'foo.pdf');
%   [status, result] = stCurlRun(cmd);
% 
%
% RF 2017

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