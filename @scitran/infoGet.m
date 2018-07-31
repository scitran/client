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
  
  % Search for files
  files = st.search('file',...
      'project label exact','DEMO', ...
      'acquisition label exact','1_1_3Plane_Loc_SSFSE');
  info = st.infoGet(files{1},'container type','file acquisition');
%}
%{
  acquisition = st.search('acquisition',...
      'project label exact','DEMO', ...
      'acquisition label exact','1_1_3Plane_Loc_SSFSE');
  info = st.infoGet(acquisition{1});
%}
%{
  sessions = st.search('session',...
     'project label exact','DEMO');
  sessionID = idGet(sessions{1},'data type','session');

  % List acquisitions
  acquisition = st.list('acquisition',sessionID);
  info = st.infoGet(acquisition{1});
%}

%% Figure out parameters

p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('object');

validTypes = {'project','session','acquisition','collection', ...
    'fileproject','filesession','fileacquisition','filecollection'};
p.addParameter('containertype','',@(x)(ismember(ieParamFormat(x),validTypes)));
p.addParameter('containerid','',@ischar);
p.addParameter('infotype','all',@ischar);

p.parse(st,object,varargin{:});

containerType = p.Results.containertype;
containerID   = p.Results.containerid;
infoType = p.Results.infotype;

%% Figure out the the proper container information

% This might all become a method scitran.objectParse
if ischar(object)
    
    % User sent in a string.  So, this must be a file.  And we must
    % have the container type and id
    fname = object;
    containerType = stParamFormat(containerType);  % Spaces, lower
    if ~isequal(containerType(1:4),'file')
        error('Char requires file container type.'); 
    end
    if isempty(containerID), error('container id required'); end

    % If containerType is fileX format, get the containerType from the
    % second half of the string
    if length(containerType) > 4
        fileContainerType = containerType(5:end);
    else
        % No fileX. We assume the user gave just the container file type
        fileContainerType = containerType;
    end
    % Did I mention this has to be a file?
    containerType     = 'file';

else
    % Either a list return or a search return. 
    
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
end

%% Call the right SDK function to get the whole info struct

switch containerType
    case 'project'
        meta = st.fw.getProject(containerID);
    case 'session'
        meta = st.fw.getSession(containerID);
    case 'acquisition'
        meta = st.fw.getAcquisition(containerID);
    case 'collection'
        meta = st.fw.getCollection(containerID);
    case 'file'
        switch fileContainerType
            case 'project'
                meta = st.fw.getProjectFileInfo(containerID,fname);
            case 'session'
                meta = st.fw.getSessionFileInfo(containerID,fname);
            case 'acquisition'
                meta = st.fw.getAcquisitionFileInfo(containerID,fname);
            case 'collection'
                meta = st.fw.getCollectionFileInfo(containerID,fname);
        end
end

%% If the user asks for something specific, parse the request here

% Not sure what info type fields are there.  I think classification is
% only present for a file.
switch infoType
    case 'all'
        info = meta;
    case 'info'
        info = meta.info;
    case 'note'
        info = meta.notes;
    case 'tag'
        info = meta.tags;
    case 'classification'
        if ~isequal(containerType,'file')
            error('classification present only for files');
        elseif isfield(meta,'classification')
            info = meta.classification; 
        end
    otherwise
        % Probably just info
end

end
