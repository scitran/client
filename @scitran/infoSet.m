function info = infoSet(st,object,metadata,varargin)
% Set metadata (info field) on a Flywheel object
%
% Syntax
%   info = st.infoSet(object,metadata,varargin)
%
% Description
%   Very little of this is tested yet.  We need to create the unit
%   tests!
%
%   Modify an info field of an object. The info can be a field or a
%   note or a tag.
%   
%   QUESTIONS:  Are you a permitted to  modify some, but not all of
%   the info fields? More definition is needed here.  For example, if
%   the field does not exist, then it is added. If it does exist, then
%   its value is changed. Right?
%
%   Why are there add and set and modify methods.  Which are the right
%   ones to use here?
%
%   How are we going to handle deleting fields?
%
%
% Input
%   object:  The Flywheel object. It will be parsed by objectParse.
%   metadata:  By default the infotype is 'info'.  In this case data
%                   should be a struct whose fields contain the new values.
%                   Some possible fields are 'label' and 'description'.
% 
%                   If the infotype is a 'note' or 'tag' then data should
%                   be a string.
%
% Optional key/value
%   fname    -  File name, required for fileXXXX container types
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
  project  = st.lookup('scitran/DEMO');
  sessions = project.sessions();
  allinfo = st.infoGet(sessions{1});
  info    = st.infoGet(sessions{1},'infotype','info');

  data.subject.firstname = 'Annette2';
  modInfo = st.infoSet(sessions{1},data);
  modInfo.info.subject.firstname

  % Put it back
  data.subject.firstname = 'Annette';
  modInfo = st.infoSet(sessions{1},data);
  modInfo.info.subject.firstname
%}
%{
    project  = st.lookup('scitran/DEMO');
    subjects = project.subjects();
    thisSubject = subjects{1};
%}
%{
  % Add and delete a note
  project = st.search('project','project label exact','DEMO');
  projectID = idGet(project{1},'data type','project');
  modInfo = st.infoSet(project{1}, 'Test note','infotype','note');
  st.fw.deleteProjectNote(projectID,modInfo.notes{1}.id)
%}
%{
info = struct('some_key', 'somevalue', 'another_key', 10);
fw.setAnalysisInfo(analysisId, info);
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
p.addParameter('containerid','',@ischar);
p.addParameter('containertype','',@ischar);

p.parse(st,object,metadata,varargin{:});

% 
infoType = p.Results.infotype;

% Dealing with fileXXX types
containerID   = p.Results.containerid;
containerType = p.Results.containertype;

%% Figure out the the proper container information

% Figure out what type of object this is.
[containerID, containerType, fileContainerType, fname] = ...
    st.objectParse(object,containerType,containerID);

%%  Call the right Flywheel SDK routie

switch containerType
    case 'project'
        switch infoType
            case 'info'
                st.fw.setProjectInfo(containerID,metadata);
            case 'note'
                st.fw.addProjectNote(containerID,metadata);
            case 'tag'
                st.fw.addProjectTag(containerID,metadata);
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
        
    case 'analysis'
        % Not tested yet.  
        switch infoType
            case 'info'
                st.fw.setAnalysisInfo(containerID,metadata);
            case 'note'
                st.fw.addAnalysisNote(containerID,metadata);
            case 'tag'
                st.fw.addAnalysisTag(containerID,metadata);
        end
        info = st.fw.getAnalysis(containerID);
        
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

switch infoType
    case 'info'
    case 'tags'
        disp('info returned.  infoType tags not yet implemented')
    case 'notes'
        disp('info returned.  infoType notes not yet implemented')
    case 'classification'
        disp('info returned.  infoType classification not yet implemented')
    otherwise
        error('Unknown info type %s',infoType);
end

end

