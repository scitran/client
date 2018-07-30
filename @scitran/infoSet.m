function info = infoSet(st,containerType,containerID,metadata,varargin)
% Modify the database info from a Flywheel container
%
% Syntax
%   info = st.infoSet(containerType,containerID,metadata,varargin)
%
% Description
%   Modify an info field of a container or a file in a container. The
%   info can be a field or a note or a tag. 
%   
%   QUESTIONS:  Are you a permitted to  modify some, but not all of the info
%   fields? More definition is needed here.  For example, if the field
%   does not exist, then it is added. If it does exist, then its value
%   is changed. Right?
%
% Input
%   containerType:  A string that defines the object.  These are
%       'project','session','acquisition','collection', 'fileproject',
%       'filesession', 'fileacquisition', 'filecollection'.  We
%       consider fileX to be a group and they required the key/value
%       fname (see below).
%   containerID:    The container's id
%   data:           By default the infotype is 'info'.  In this case data
%                   should be a struct whose fields contain the new values.
%                   Some possible fields are 'label' and 'description'.
% 
%                   If the infotype is a 'note' or 'tag' then data should
%                   be a string.
%
% Optional key/value
%   fname    -  File name, required for fileX container types
%   infotype -  Add an 'info' field, a 'note', or a 'tag' and we
%               should add 'classification' (default: 'info')
%
% Return
%   info - The whole info structure
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
validTypes = {'project','session','acquisition','collection', ...
    'fileproject','filesession','fileacquisition','filecollection'};
p.addRequired('containerType',@(x)(ismember(x,validTypes)));
p.addRequired('containerID',@ischar);
p.addRequired('metadata',@(x)(isstruct(x) || ischar(x)));

% Required for fileX container types
p.addParameter('fname','',@ischar);   

% The data can be added to an info slot or treated as a tag or a note
validInfo = {'info','note','tag'};
p.addParameter('infotype','info',@(x)(ismember(x,validInfo)));

p.parse(st,containerType,containerID,data,varargin{:});

infoType = p.Results.infotype;

% Parse the container type to see if it starts with file.  Then figure
% out the file container type.
if strncmp(containerType,'file',4)
    containerType     = containerType(1:4);
    fileContainerType = containerType(5:end);
    fname = p.Results.fname;
    if isempty(fname), error('File name required'); end
end

%%  Call the right Flywheel SDK routie

switch containerType
    case 'project'
        switch infoType
            case 'info'
                st.fw.modifyProject(containerID,metadata);
            case 'note'
                st.fw.addProjectNote(containerID,metadata);
            case 'tag'
                st.fw.addProjectNote(containerID,metadata);
        end
        info = st.fw.getProject(containerID);
        
    case 'session'
        switch infoType
            case 'info'
                st.fw.modifySession(containerID,metadata);
            case 'note'
                st.fw.addSessionNote(containerID,metadata);
            case 'tag'
                st.fw.addSessionTag(containerID,metadata);
        end
        info = st.fw.getSession(containerID);
        
    case 'acquisition'
        switch infoType
            case 'info'
                st.fw.modifyAcquisition(containerID,metadata);
            case 'note'
                st.fw.addAcquisitionNote(containerID,metadata);
            case 'tag'
                st.fw.addAcquisitionTag(containerID,metadata);
        end
        info = st.fw.getAcquisition(containerID);
        
    case 'collection'
        switch infoType
            case 'info'
                st.fw.modifyCollection(containerID,metadata);
            case 'note'
                st.fw.addCollectionNote(containerID,metadata);
            case 'tag'
                st.fw.addCollectionTag(containerID,metadata);
        end
        info = st.fw.getCollection(containerID);
        
    case 'file'
        % Files are inside of different types of containers.  The call
        % for setting the info on a file differs depending on the type
        % of container it is in.
        
        % We should understand when we want to use modify, set and replace.  I
        % didn't understand Justin's response last time. (BW).
        switch (fileContainerType)
            case 'project'
                fw.setProjectFileInfo(containerID,fname,metadata);
                info = st.fw.getProjectFileInfo;
            case 'session'
                fw.setSessionFileInfo(containerID,fname,metadata);
                info = st.fw.getSessionFileInfo;
            case 'acquisition'
                fw.setAcquisitionFileInfo(containerID,fname,metadata);
                info = st.fw.getAcquisitionFileInfo;
            case 'collecton'
                fw.setCollectionFileInfo(containerID,fname,metadata);
                info = st.fw.getCollectionFileInfo;
        end
        
    otherwise
        error('Container type %s either unknown or not implemented\n',containerType);
end

end

