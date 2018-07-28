function info = containerInfoSet(st,containerType,containerID,data,varargin)
% Modify the database info from a Flywheel container
%
% Syntax
%   info = st.containerInfoSet(containerType,containerID,data,varargin)
%
% Description
%   Modify an info field of a container.  This includes notes and tags. You
%   are permitted to modify some, but not all of the fields. More
%   definition is needed here.
%
% Input
%   containerType:  A string from 'project','session','acquisition','collection'
%   containerID:    The container's id
%   data:           By default the infotype is 'info'.  In this case data
%                   should be a struct whose fields contain the new values.
%                   Some possible fields are 'label' and 'description'.
% 
%                   If the infotype is a 'note' or 'tag' then data should
%                   be a string.
%
% Optional key/value
%   infotype   -  Add an 'info' field, a 'note', or a 'tag' (default:
%                 'info')
%
% BW, Vistasoft, 2017

% Example
%{
  project = st.search('project','project label exact','VWFA');
  projectID = idGet(project{1},'data type','project');
  info = st.containerInfoGet('project',projectID);

  % Set up and modify the specific field
  data    = struct('description','Visual word form area in adult.');
  modInfo = st.containerInfoSet('project', projectID, data);
%}
%{
  sessions = st.list('session',projectID);
  info = st.containerInfoGet('session',idGet(sessions{1},'data type','session'));
  data.subject.firstname = 'Annette2';
  modInfo = st.containerInfoSet('session',idGet(sessions{1},'data type','session'),data);
  modInfo.subject.firstname

  % Put it back
  data.subject.firstname = 'Annette';
  modInfo = st.containerInfoSet('session',idGet(sessions{1},'data type','session'),data);
  modInfo.subject.firstname

%}
%{
% Add a note
  project = st.search('project','project label exact','VWFA');
  projectID = idGet(project{1},'data type','project');
  modInfo = st.containerInfoSet('project', projectID, 'Test note','infotype','note');
%}

%%
p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('containerType',@(x)(ismember(x,{'project','session','acquisition','collection','group','user'})));
p.addRequired('containerID',@ischar);
p.addRequired('data',@(x)(isstruct(x) || ischar(x)));

% The data can be added to an info slot or treated as a tag or a note
validInfo = {'info','note','tag'};
p.addParameter('infotype','info',@(x)(ismember(x,validInfo)));

p.parse(st,containerType,containerID,data,varargin{:});

infoType = p.Results.infotype;

%%  Call the right Flywheel SDK routie

switch containerType
    case 'project'
        switch infoType
            case 'info'
                st.fw.modifyProject(containerID,data);
            case 'note'
                st.fw.addProjectNote(containerID,data);
            case 'tag'
                st.fw.addProjectNote(containerID,data);
        end
        info = st.fw.getProject(containerID);
        
    case 'session'
        switch infoType
            case 'info'
                st.fw.modifySession(containerID,data);
            case 'note'
                st.fw.addSessionNote(containerID,data);
            case 'tag'
                st.fw.addSessionTag(containerID,data);
        end
        info = st.fw.getSession(containerID);
        
    case 'acquisition'
        switch infoType
            case 'info'
                st.fw.modifyAcquisition(containerID,data);
            case 'note'
                st.fw.addAcquisitionNote(containerID,data);
            case 'tag'
                st.fw.addAcquisitionTag(containerID,data);
        end
        info = st.fw.getAcquisition(containerID);
        
    case 'collection'
        switch infoType
            case 'info'
                st.fw.modifyCollection(containerID,data);
            case 'note'
                st.fw.addCollectionNote(containerID,data);
            case 'tag'
                st.fw.addCollectionTag(containerID,data);
        end
        info = st.fw.getCollection(containerID);
        
    otherwise
        error('Container type %s either unknown or not implemented\n',containerType);
end

end

