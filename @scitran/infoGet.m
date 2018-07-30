function info = infoGet(st,object,varargin)
% Get the info associated from a container or a file within a container 
%
% Syntax
%    st.infoGet(obj,object,...)
%
% Description
%  Files have an associated info object that describes critical metadata.
%  This method returns the availble info.  To find the info, we apparently
%  have to list the container and then search for the info field associated
%  with that file in the container. 
%
%  TODO: Notes and Tags and Classification are part of the info.  We
%  should add an infoType parameter if we only want one of those back.
%
% Input (required)
%   file - A search response defining the file, or the filename
%          string.  If a string, you must send container type and id.
%   
% Input (optional)
%   containerID   - 
%   containerType - If file is a string, the parent id is required
%
% Return
%  info - struct
%
% BW, Vistasoft Team, 2017
%
% See also:  scitran.setFileInfo, scitran.setInfo, scitran.getFileInfo

% 
% Example
%{
  st = scitran('stanfordlabs');
  % List the files
  files = st.search('file',...
      'project label exact','DEMO', ...
      'acquisition label exact','1_1_3Plane_Loc_SSFSE');
  files{1}  
  info = st.infoGet(files{1},'container type','file acquisition');
%}
%{
  acquisition = st.search('acquisition',...
      'project label exact','DEMO', ...
      'acquisition label exact','1_1_3Plane_Loc_SSFSE');
  info = st.infoGet(session{1});

%}
%{
  sessions = st.search('session',...
     'project label exact','DEMO');
  sessionID = idGet(sessions{1},'data type','session');
  acquisition = st.list('acquisition',sessionID);
  info = st.infoGet(acquisition{1});
%}

%% Figure out parameters

p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('object',@(x)(isa(x,'flywheel.model.SearchResponse') || ischar(x)));

validTypes = {'project','session','acquisition','collection', ...
    'fileproject','filesession','fileacquisition','filecollection'};
p.addParameter('containertype','',@(x)(ismember(x,validTypes)));
p.addParameter('containerid','',@ischar);
p.addParameter('infotype','info',@ischar);

p.parse(st,object,varargin{:});

containerType = p.Results.containertype;
containerID   = p.Results.containerid;

% Parse containerType to see if it starts with 'file'.  If so, get a
% file name and fileContainerType
if strncmp(containerType,'file',4)
    containerType = stParamFormat(containerType);
    fileContainerType = containerType(5:end);
    containerType     = containerType(1:4);
else
    fileContainerType = '';
end


if ischar(object)
    fname = object;
    if isempty(containerID)
        error('container id required');
    end
else
    [oType, sType] = stObjectType(object);
    if strncmp(oType,'search',6)  % A search object
        fname  = object.file.name;
        if isempty(containerID)
            containerID   = object.parent.id;
        end
        if isempty(containerType)
            containerType = object.parent.type;
        end
    end
end

%% Call the right SDK function to get the whole info struct

switch containerType
    case 'project'
        info = st.fw.getProject(containerID);
    case 'session'
        info = st.fw.getSession(containerID);
    case 'acquisition'
        info = st.fw.getAcquisition(containerID);
    case 'collection'
        info = st.fw.getCollection(containerID);
    case 'file'
        switch fileContainerType
            case 'project'
                info = st.fw.getProjectFileInfo(containerID,fname);
            case 'session'
                info = st.fw.getSessionFileInfo(containerID,fname);
            case 'acquisition'
                info = st.fw.getAcquisitionFileInfo(containerID,fname);
            case 'collection'
                info = st.fw.getCollectionFileInfo(containerID,fname);
        end
end

%% If the user asks for something specific, parse the request here

% Not sure what info type fields should be allowed.s
switch infotype
    case 'info'
    case 'note'
    case 'tag'
    case 'classification'
    otherwise
        % Probably just info
end

end
