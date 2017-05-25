function cmd = deleteContainerCmd(obj, containerType, containerID)
% create a curl cmd to delete a container given the type of the container
% and its id
%
%   cmd = st.deleteContainerCmd('containerType', 'containerID')
%
% example usage in conjunction with stCurlRun:
%
%   cmd = st.deleteContainerCmd('acquisitions', '56f9d31c39a00d9010e51044');
%   [status, result] = stCurlRun(cmd); 
%
% deleteContainerCmd is used in the eraseProject method.
%
% RF 2016 

%%
p = inputParser;
p.addRequired('containerType',@ischar);
p.addRequired('containerID',@ischar);
p.parse(containerType, containerID);
containerType      = p.Results.containerType;
containerID        = p.Results.containerID;

cmd = sprintf('curl -s -XDELETE "%s/api/%s/%s" -H "Authorization":"%s" -k',...
    obj.url, containerType, containerID, obj.token);
end