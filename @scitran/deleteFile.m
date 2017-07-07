function [status, result, cmd] = deleteFile(obj, file, varargin )
% Deletes a file from a container
% 
%   [status, result, cmd] = deleteFile(obj, file, varargin )
%
% Required parameter
%    file - String, struct, or cell with one element
%
% Optional parameters
%    containerType
%    containerID
%    
% Example:
%   file = st.search ...
%   st.deleteFile(file{1});
%
%   st = scitran('vistalab');
% 
%
% RF 2017

%%
p = inputParser;
p.addRequired('file',@(x)(iscell(x) || isstruct(x) || ischar(x)));

% Set up default container values based on the struct
if iscell(file),        fileStruct = file{1}; 
elseif isstruct(file),  fileStruct = file;
elseif ischar(file),    fileStruct = [];
end
if ~isempty(fileStruct)
    containerType = fileStruct.source.container_name;
    % Annoying that this is project, not projects
    containerID   = fileStruct.source.(containerType(1:end-1)).x_id;
    filename      = fileStruct.source.name;
else
    containerID   = '';
    containerType = '';
    filename      = file;
end

p.addParameter('containerType',containerType,@ischar);
p.addParameter('containerID',containerID,@ischar);

% Parse and sort
p.parse(file,varargin{:});

containerType  = p.Results.containerType;
containerID    = p.Results.containerID;

% Final check
if isempty(containerType) || isempty(containerID)
    error('When file is a string, you must specify the container type and id');
end

%% Delete

cmd = obj.deleteFileCmd(containerType,containerID,filename);

[status, result] = stCurlRun(cmd);

% Let the user know if it worked
if ~status, fprintf('%s sucessfully deleted.\n',filename); end

end