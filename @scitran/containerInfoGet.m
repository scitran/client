function info = containerInfoGet(st,containerType, containerID)
% Read info from a Flywheel container
%
% Syntax
%   info = st.containerInfoGet(containerType, containerID)
%
% Description
%   Return a struct with the container information.
%
% Inputs
%   containerType:  project, session, acquisition, or collection.  There is
%                   a separate method for File Info. 
%   containerID:    The ID, typically returned by a search or list
%                   operation.
%
% Return:
%   info:   A struct containing the metadata for this container
%
% Example
%  p = st.search('project','project label exact','VWFA')
%  info = st.getContainerInfo('project',idGet(p{1}));
%
% BW, Vistasoft, 2017
%
% See also:

% Example
%{
  st = scitran('stanfordlabs');

  project = st.search('project','project label exact','VWFA');
  id = idGet(project{1},'project');
  info = st.getContainerInfo('project',id);

  sessions = st.list('session',id);   % Parent id
  stPrint(sessions,'subject','code')
  info = st.getContainerInfo('session',idGet(sessions{1},'session'));
%}

%% Parse

p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('containerType',@(x)(ismember(x,{'project','session','acquisition','collection'})));
p.addRequired('containerID',@ischar);

p.parse(st,containerType,containerID);

%% Call the right Flywheel SDK routine

switch containerType
    case 'project'
        info = st.fw.getProject(containerID);
    case 'session'
        info = st.fw.getSession(containerID);
    case 'acquisition'
        info = st.fw.getAcquisition(containerID);
    case 'collection'
        info = st.fw.getCollection(containerID);
    otherwise
        error('Unknown container type %s\n',containerType);
end

end
