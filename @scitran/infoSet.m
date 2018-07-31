function info = infoSet(st,object,metadata,varargin)
% Set metadata (info field) on a Flywheel object
%
% Syntax
%   info = st.infoSet(object,metadata,varargin)
%
% Description
%   Modify an info field of an object. The info can be a field or a
%   note or a tag.
%   
%   QUESTIONS:  Are you a permitted to  modify some, but not all of the info
%   fields? More definition is needed here.  For example, if the field
%   does not exist, then it is added. If it does exist, then its value
%   is changed. Right?
%
%   How are we going to handle deleting fields?
%
% Input
%   object:  A string that defines the object.  These are
%       'project','session','acquisition','collection', 'fileproject',
%       'filesession', 'fileacquisition', 'filecollection'.  We
%       consider fileX to be a group and they required the key/value
%       fname (see below).
%   metadata:  By default the infotype is 'info'.  In this case data
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
  info = st.infoGet(project{1},'info type','info');

  % Set up and modify the specific field
  metadata = struct('delete','this metadata.');
  modInfo  = st.infoSet(project{1}, metadata);
  
  % Clean it up
  projectID = idGet(project{1},'data type','project');
  st.fw.deleteProjectInfoFields(projectID,{{'delete'}});

%}
%{
  project = st.search('project','project label exact','DEMO');
  projectID = idGet(project{1},'data type','project');

  sessions = st.list('session',projectID);
  allinfo = st.infoGet(sessions{1});
  info = st.infoGet(sessions{1},'infotype','info');

  data.subject.firstname = 'Annette2';
  modInfo = st.infoSet(sessions{1},data);
  modInfo.info.subject.firstname

  % Put it back
  data.subject.firstname = 'Annette';
  modInfo = st.infoSet(sessions{1},data);
  modInfo.info.subject.firstname

%}
%{
  % Add and delte a note
  project = st.search('project','project label exact','DEMO');
  projectID = idGet(project{1},'data type','project');
  modInfo = st.infoSet(project{1}, 'Test note','infotype','note');
  st.fw.deleteProjectNote(projectID,modInfo.notes{1}.id)

%}

%%
p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('object');
p.addRequired('metadata',@(x)(isstruct(x) || ischar(x)));

% The data can be added to an info slot or treated as a tag or a note
validInfo = {'info','note','tag','classification'};
p.addParameter('infotype','info',@(x)(ismember(x,validInfo)));

p.parse(st,object,metadata,varargin{:});

infoType = p.Results.infotype;

%% Figure out the the proper container information

% This would be a part of scitran.objectParse, as drafted in infoGet.m

% Figure out what type of object this is.
[oType, sType] = stObjectType(object);

% If it is a search, then ...
if isequal(oType,'search')  && isequal(sType,'file')
    % A file search object has a parent id included.
    containerType = 'file';
    fname  = object.file.name;
    containerID   = object.parent.id;
    fileContainerType = object.parent.type;
    
elseif isequal(oType,'search')
    % Another type of search.  The id and type should be there.
    containerType = sType;
    containerID   = object.(sType).id;
else
    % It a list return, not a search return
    containerType = oType;
    containerID = object.id;
end


%%  Call the right Flywheel SDK routie

switch containerType
    case 'project'
        switch infoType
            case 'info'
                st.fw.setProjectInfo(containerID,metadata);
            case 'note'
                st.fw.addProjectNote(containerID,metadata);
            case 'tag'
                st.fw.addProjectNote(containerID,metadata);
        end
        info = st.fw.getProject(containerID);
        
    case 'session'
        switch infoType
            case 'info'
                st.fw.setSessionInfo(containerID,metadata);
            case 'note'
                st.fw.addSessionNote(containerID,metadata);
            case 'tag'
                st.fw.addSessionTag(containerID,metadata);
        end
        info = st.fw.getSession(containerID);
        
    case 'acquisition'
        switch infoType
            case 'info'
                st.fw.setAcquisitionInfo(containerID,metadata);
            case 'note'
                st.fw.addAcquisitionNote(containerID,metadata);
            case 'tag'
                st.fw.addAcquisitionTag(containerID,metadata);
        end
        info = st.fw.getAcquisition(containerID);
        
    case 'collection'
        switch infoType
            case 'info'
                st.fw.setCollectionInfo(containerID,metadata);
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
            case 'collection'
                fw.setCollectionFileInfo(containerID,fname,metadata);
                info = st.fw.getCollectionFileInfo;
        end
        
    otherwise
        error('Container type %s either unknown or not implemented\n',containerType);
end

end

