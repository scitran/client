function info = containerInfoSet(st,containerType,containerID,data)
% Modify the database info from a Flywheel container
%
% Syntax
%   info = st.containerInfoSet(containerType,containerID,data)
%
% Description
%   Modify the info fields of a container.  You are permitted to modify
%   some, but not all of the fields. More definition is needed here.
%
% Input
%   containerType:  A string from 'project','session','acquisition','collection'
%   containerID:    Flywheel id
%   data:           A struct whose fields contain the new values.  Possible
%                   fields are 'label' and 'description'.  
%
% BW, Vistasoft, 2017

% Example
%{
  % The syntax for the modify info SDK call is:
  %   st.fw.modifyProject(projectId, struct('label','testdrive'));

  project = st.search('project','project label exact','VWFA');
  info = st.getContainerInfo('project',idGet(project,'project'));

  % Set up and modify the field
  data = struct('description','Visual word form area in adult.');
  modInfo = st.setContainerInfo('project',idGet(project,'project'),data);

  sessions = st.list('session',idGet(project,'project'));
  info = st.getContainerInfo('session',idGet(sessions{1},'session'));
  data.subject.firstname = 'Annette2';
  modInfo = st.setContainerInfo('session',idGet(sessions{1},'session'),data);
  modInfo.subject.firstname

  % Put it back
  data.subject.firstname = 'Annette';
  modInfo = st.setContainerInfo('session',idGet(sessions{1},'session'),data);
  modInfo.subject.firstname

%}

%%
p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('containerType',@(x)(ismember(x,{'project','session','acquisition','collection','group','user'})));
p.addRequired('containerID',@ischar);
p.addRequired('data',@isstruct);

p.parse(st,containerType,containerID,data);

%%  Call the right Flywheel SDK routie

switch containerType
    case 'project'
        st.fw.modifyProject(containerID,data);
        info = st.fw.getProject(containerID);
    case 'session'
        st.fw.modifySession(containerID,data);
        info = st.fw.getSession(containerID);
    case 'acquisition'
        st.fw.modifyAcquisition(containerID,data);
        info = st.fw.getAcquisition(containerID);
    case 'collection'
        st.fw.modifyCollection(containerID,data);
        info = st.fw.getCollection(containerID);
    otherwise
        error('Container type %s either unknown or not implemented\n',containerType);
end

end

