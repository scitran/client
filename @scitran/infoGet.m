function info = infoGet(st,object,varargin)
% Get the info associated from a container or a file within a container 
%
% Syntax
%    st.infoGet(obj,object,...)
%
% Description
%  Flywheel objects have an associated set of metadata called 'info'.
%  This method returns the info specified by 'infotype'.  There are
%  several possible info types, specified below in the optional
%  key/value input.
%
% Input (required)
%   file - A search response defining the file, or the filename
%          string.  If a string, you must send container type and id.
%   
% Optional key/value pairs
%   infoType      - 'all' (default),'info','tag','note'
%   containerType - If the 'object' input is a string, we know that
%                   the request is for a file. The parent container
%                   and id required
%   containerID   - See above.
%
% Return
%  info - Returned information.  Might be a struct or a flywheel.model
%         class. 
%
% BW, Vistasoft Team, 2017
%
% See also:  scitran.infoSet

% 
% Examples:
%{
  st = scitran('stanfordlabs');
  st.verify;

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

validTypes = {'project','session','acquisition','collection','analysis', ...
    'fileproject','filesession','fileacquisition','filecollection'};
p.addParameter('containertype','',@(x)(ismember(ieParamFormat(x),validTypes)));
p.addParameter('containerid','',@ischar);
p.addParameter('infotype','all',@ischar);

p.parse(st,object,varargin{:});

containerType = p.Results.containertype;
containerID   = p.Results.containerid;
infoType      = p.Results.infotype;

%% Figure out the the proper container information
[containerID, containerType, fileContainerType, fname] = ...
    st.objectParse(object, containerType,containerID);

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
    case 'analysis'
      meta = obj.fw.getAnalysis(containerID);

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

% There are separate methods for Notes and Tags.  I don't think they
% are needed because the information is in the info object.  So, the
% preferred way to get them is infoGet( ...., 'info type','note') ...
% or similar.
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
