function status = fileUpload(obj,filename,containerId,containerType)
% Upload a file to a Flywheel site.
%
% Syntax
%   status = st.fileUpload(obj,filename,containerId,containerType)
%
% Description
%  Upload a file into one of several types of containers on a Flywheel
%  site. The local file name is preserved.
% 
% Inputs (required):
%   filename      - A full path to a local file
%   containerID   - You can use st.objectParse to find an id and type
%   containerType - This can be a project, session, acquisition, or
%                   collection 
%
% Outputs:
%   status:  Boolean indicating success (0) or failure (~=0)
%
% Examples in the code
%
% LMP/BW Vistasoft Team, 2015-16
%
% See also:  
%  fileDownload

%
% Example 1
%{
 % Get a local file to work with
 st = scitran('stanfordlabs');
 fname = 'dtiError.json';
 file = st.search('file','file name contains',fname);
 [id,oType,fileContainerType] = st.objectParse(file{1});
 chdir(fullfile(stRootPath,'local'));

 localFile = st.fileDownload(fname,'container id',id,'container type', fileContainerType);
%}
%{
 % Upload a file to a dummy project
 gName = 'Wandell Lab';  % Group name (or label?)
 pLabel = 'deleteMe';    % Project label
 id = st.containerCreate(gName,pLabel);  % Returns a slot with project id
 
 % Upload the file.
 st.fileUpload(fullFilename,id.project,'project');

 % Delete the dummy project
 st.deleteContainer('project',id.project); 
%}
%
% Example 2
%{
 % If the project already exists, search and do the upload
 project = st.search('project','project label exact','DEMO');
 fullFilename = fullfile(stRootPath,'data','dtiError.json');
 st.fileUpload(fullFilename,'project',idGet(project,'data type','project'));
%}
% Example 3
%{
 project = st.search('project','project label exact','DEMO');
 [id, cType] = st.objectParse(project{1});
 fullFilename = fullfile(stRootPath,'data','dtiError.json');
 st.fileUpload(fullFilename,id,cType);
%}

%% Parse input parameters
p = inputParser;

% varargin = stParamFormat(varargin);
p.addRequired('obj',@(x)(isa(x,'scitran')));
p.addRequired('filename',@(x)(exist(x,'file')));
p.addRequired('containerId',@ischar);
vFunc = @(x)(ismember(x,{'project','session','acquisition','collection'}));
p.addRequired('containerType', vFunc);

p.parse(obj,filename,containerId,containerType);

%%
switch containerType
    case 'project'
        status = obj.fw.uploadFileToProject(containerId, filename);
    case 'session'
        status = obj.fw.uploadFileToSession(containerId, filename);
    case 'acquisition'
        status = obj.fw.uploadFileToAcquisition(containerId, filename);
    case 'collection'
        status = obj.fw.uploadFileToCollection(containerId, filename);
    otherwise
        error('Not handled yet');
end


end