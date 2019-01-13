function info = infoGet(st,container,varargin)
% Get the info associated from a container or a file within a container 
%
% Syntax
%    scitran.infoGet(container,...)
%
% Description
%  Flywheel objects have an associated set of metadata called 'info'.
%  This method returns the info specified by 'infotype'.  There are
%  several possible info types, specified below in the optional
%  key/value input.
%
% Input (required)
%   container - A search response or an object container, OR, a string
%       defining the file, or the filename. If a file name string, you
%       must use the key/value pairs to specify the container type and id. 
%   
% Optional key/value pairs
%   'info type'      - 'info' (default),'tag','note'
%   'container type' - If the 'object' input is a string, we know that
%                      the request is for a file. The parent container
%                       and id required
%   containerID      - See above.
%
% Return
%  info - Returned information field.  Either info, tag or note.
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
  sessionID = st.objectParse(sessions{1}); 

  % List acquisitions in that session
  acquisition = st.list('acquisition',sessionID);
  info = st.infoGet(acquisition{1});
%}

%% Figure out parameters

p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('container');

validTypes = {'project','session','acquisition','collection','analysis', ...
    'fileproject','filesession','fileacquisition','filecollection'};
p.addParameter('containertype','',@(x)(ismember(stParamFormat(x),validTypes)));
p.addParameter('containerid','',@ischar);
p.addParameter('infotype','info',@ischar);

p.parse(st,container,varargin{:});

containerType = p.Results.containertype;
containerID   = p.Results.containerid;
infoType      = p.Results.infotype;

%% Figure out the the proper container information
[containerID, containerType, fileContainerType, fname] = ...
    st.objectParse(container, containerType,containerID);

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
        warning('No option for %s.  Returning info\n',infoType);
        info = meta.info;

end

end
