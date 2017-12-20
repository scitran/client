function info = getFileInfo(st,file,varargin)
% Get the info associated with a specific file
%
%   NOT YET IMPLEMENTED - WORKING ON HOW TO HANDLE DIFFERENT CONTAINERS
%
% Syntax
%    st.getFileInfo(file,...)
%
% Description
%  Some files have an associated info object that describes critical
%  metadata.  This method returns the availble info.  To find the info, we
%  apparently have to list the container and then search for the info field
%  associated with that file in the container.  See getdicominfo for an
%  example.
%
% Input (required)
%   file - A struct defining the file, or the filename
%
% Input (optional)
%   parentid - If file is a string, the parent id is required
%
% Return
%  info - struct
%
% BW, Vistasoft Team, 2017
%
% See also:  scitran.setFileInfo, scitran.setInfo, scitran.getFileInfo

% st = scitran('vistalab');
% Example
%{
  % List the files
  files = st.search('file',...
      'project label exact','DEMO', ...
      'acquisition label exact','1_1_3Plane_Loc_SSFSE');
  info = st.getFileInfo(files{1});

%}

%%  How do we handle different types of containers?
return;
%{
p = inputParser;
p.addRequired('file',@(x)(isstruct(x) || ischar(x)));

varargin = stParamFormat(varargin);
p.addParameter('parentid','',@ischar);

p.parse(file,varargin{:});

parentid = p.Results.parentid;
info = [];
if isstruct(file)
    parentid = idGet(file);
elseif ischar(file) && isempty(parentid)
    error('When file is a string, you must include parent id');
end

thisAcq = st.search('acquisition',parentid);

thisFile = st.search('file','acquisition id',parentid)
%}

%%