function [status, result, cmd] = fileDelete(obj, file, varargin )
% Deletes a file from a container on a Flywheel site.  
% 
%      NOT YET IMPLEMENTED
%
%  [status, result, cmd] = scitran.fileDelete(obj, file, varargin)
%
% Required parameter
%  file - can be either
%         1 element cell
%         struct
%         string, which case we need the containerID (needs optional parameters)
%
% Optional parameters for string
%  containerType - {'projects','sessions','acquisitions','collections'}
%  containerID   - From the container struct returned by a search
%    
% BW 2017

% Examples assume
%   st = scitran('stanfordlabs');
%
%{
  % Make sure we have a dummy file up there
  % remoteFileName = 'test.json';
  localFilename = fullfile(stRootPath,'data','test.json');
  project = st.search('projects',...
    'project label exact','DEMO');

  st.upload(localFilename,'project',idGet(project,'project'));

  % This is the delete operation based on search
  file = st.search('file',...
    'project label exact','DEMO',...
    'filename','dtiError.json');

  file = st.search('file',...
    'project label exact','DEMO',...
    'filename','test.json');

  st.deleteFile(file);
%}

%{
   st.deleteFile(file{1});
%}

%{
 project = st.search('projects','project label contains','SOC');
 st.deleteFile('WLVernierAcuity.json','containerType','projects','containerID',project{1}.id);   
%}

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

%% Delete - Egads!

% We have to

error('deleteFile is not implemented!')

%{

% If we need it sooner, then we need to resurrect these commands, 
% deleteFileCmd and stCurlRun
%
cmd = obj.deleteFileCmd(containerType,containerID,filename);

[status, result] = stCurlRun(cmd);

% Let the user know if it worked
if ~status, fprintf('%s sucessfully deleted.\n',filename); end
}
%}

end