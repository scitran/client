function info = fileInfoGet(st,file,varargin)
% Get the info associated with a file from a specific container type
%
%   NOT YET IMPLEMENTED - WORKING ON HOW TO HANDLE DIFFERENT CONTAINERS
%
% Syntax
%    st.fileInfoGet(obj,file,...)
%
% Description
%  Files have an associated info object that describes critical metadata.
%  This method returns the availble info.  To find the info, we apparently
%  have to list the container and then search for the info field associated
%  with that file in the container.  See getdicominfo for an example.
%
% Input (required)
%   file - A search response defining the file, or the filename
%   
% Input (optional)
%   parentid - If file is a string, the parent id is required
%   parentType
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
info = st.fileInfoGet(files{1});
%}

%% Figure out parameters

p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('file',@(x)(isa(x,'flywheel.model.SearchResponse') || ischar(x)));
vFunc = @(x)(validatestring(x,'project','session','acquisition','collection'));
p.addParameter('parenttype',vFunc);
p.addParameter('parentid',@ischar);

p.parse(st,file,varargin{:});

if ischar(file)
    fname      = file;
    parentID   = p.Results.parentid;
    parentType = p.Results.parenttype;
else
    fname      = file.file.name;
    parentID   = file.parent.id;
    parentType = file.parent.type;
end


%%
switch parentType
    case 'project'
        info = st.fw.getProjectFileInfo(parentID,fname);
    case 'session'
        info = st.fw.getSessionFileInfo(parentID,fname);
    case 'acquisition'
        info = st.fw.getAcquisitionFileInfo(parentID,fname);
    case 'collection'
        info = st.fw.getCollectionFileInfo(parentID,fname);
    otherwise
        error('Unknown data type %s\n',datatype);
end

%%