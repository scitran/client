function status = upload(obj,filename,containerType,containerId,varargin)
% Upload a file to a Flywheel site.
%
% Syntax
%   status = upload(obj,filename,containerType,containerId,varargin)
%
% Description
%  Upload a file to one of several types of containers on a Flywheel site.
%  Typically the file name is preserved.  You can use the 'remote name'
%  parameter to change the file name on the Flywheel site.
% 
% Inputs (required):
%   filename      - A full path to a local file
%   containerType - This can be a project,session, acquisition, or
%                   collection 
%   containerID   - You can use idGet() to find the id
%
% Inputs (optional):
%  remoteName     - File name as it should appear on the Flywheel site
%
% Outputs:
%  status:  Boolean indicating success (0) or failure (~=0)
%
% See also:  downloadFile, create
%
% Examples in the code
%
% LMP/BW Vistasoft Team, 2015-16

% st = scitran('stanfordlabs');
%
% Example 1
%{
 % Upload a file to a dummy project
 fullFilename = fullfile(stRootPath,'data','test.json');
 gName = 'Wandell Lab';  % Group name (or label?)
 pLabel = 'deleteMe';    % Project label
 id = st.create(gName,pLabel);  % Returns a slot with project id
 
 % Upload the file.
 st.upload(fullFilename,'project',id.project);

 % Delete the dummy project
 st.deleteContainer('project',id.project); 
%}

% Example 2
%{
 % If the project already exists, search and do the upload
 project = st.search('project','project label exact','DEMO');
 fullFilename = fullfile(stRootPath,'data','dtiError.json');
 st.upload(fullFilename,'project',idGet(project));
%}
% Example 3
%{
 project = st.search('project','project label exact','DEMO');
 fullFilename = fullfile(stRootPath,'data','dtiError.json');
 st.upload(fullFilename,'project',idGet(project),'remote name','namechange.json');
%}

%% Parse input parameters
p = inputParser;

p.addRequired('filename',@(x)(exist(x,'file')));
vFunc = @(x)(ismember(x,{'project','session','acquisition','collection'}));
p.addRequired('containerType', vFunc);
p.addRequired('containerId',@ischar);

p.addParameter('remotename','',@ischar);

varargin = stParamFormat(varargin);
p.parse(filename,containerType,containerId,varargin{:});

filename      = p.Results.filename;
containerType = p.Results.containerType;
containerId   = p.Results.containerId;
remoteName    = p.Results.remotename;

%% If we want to change the name as it appears on the Flywheel site.

% Would be nice if this were an option.  Maybe I can use the setInfo
% methods to change rather than copying?
remoteFlag = false;
if ~isempty(remoteName)
    remoteName = fullfile(tempdir,remoteName);
    copyfile(filename,remoteName);
    remoteFlag = true;
else
    remoteName = filename;
end


%%
switch containerType
    case 'project'
        status = obj.fw.uploadFileToProject(containerId, remoteName);
    case 'session'
        status = obj.fw.uploadFileToSession(containerId, remoteName);
    case 'acquisition'
        status = obj.fw.uploadFileToAcquisition(containerId, remoteName);
    case 'collection'
        status = obj.fw.uploadFileToCollection(containerId, remoteName);
    otherwise
        error('Not handled yet');
end

%% Clean up
if remoteFlag,  delete(remoteName); end

end