function [status, result, cmd] = deleteFile(obj, file, varargin )
% Deletes a file from a container on a scitran site.  
% 
%   [status, result, cmd] = scitran.deleteFile(obj, file, varargin)
%
% Required parameter
%    file - cell with one element, struct, or string.  If a string, then it
%           must have a containerType and containerID.
%
% Optional parameters for string
%    containerType - {'projects','sessions','acquisitions','collections'}
%    containerID   - From the container struct returned by a search
%    
% Examples:
%   fw = scitran('vistalab'); chdir(fullfile(stRootPath,'data'));
%   project = fw.search('projects','project label contains','SOC');
%
%   fw.put(fullFilename,project);
%   file = fw.search('files',...
%    'project label contains','SOC',...
%    'file name','WLVernierAcuity.json');
%   fw.deleteFile(file);
%
% Or 
%   fw.deleteFile(file{1});
%
% Or
%   project = fw.search('projects','project label contains','SOC');
%   fw.deleteFile('WLVernierAcuity.json','containerType','projects','containerID',project{1}.id);   
%
% RF 2017

%%
p = inputParser;
p.addRequired('file',@(x)(iscell(x) || isstruct(x) || ischar(x)));

% Set up default container values based on the struct
if iscell(file)
    fileStruct = file{1};
    if length(file) > 1
        warning('Multiple cells sent in.  Using 1st only');
    end
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