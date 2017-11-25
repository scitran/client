function status = upload(obj,filename,containerType,containerId,varargin)
% Upload a file to a Flywheel site
%
% Syntax
%   status = upload(obj,filename,containerType,containerId,varargin)
%
% Upload a file to one of several types of containers on a Flywheel site.
% 
% Inputs:
%   filename  - A full path to a file
%   container - Struct defining the container. This can be a project,
%               session, acquisition, or collection
% Outputs:
%  status:  Boolean indicating success (0) or failure (~=0)
%
% See also:  downloadFile, create
%
% LMP/BW Vistasoft Team, 2015-16

% Example:
%{
 st = scitran('vistalab');
 
 % Add a JSON file to a project.  Here is the full file path
 fullFilename = fullfile(stRootPath,'data','Rorie2010.json');

 % The project information
 gName = 'Wandell Lab';
 pLabel = 'deleteMe';
 idS = st.create(gName,pLabel);
 
 % Upload the file
 st.upload(fullFilename,'project',idS.project);

 % If the project already exists, you can search and do the upload
 project = st.search('project','project label exact','deleteMe');
 fullFilename = fullfile(stRootPath,'data','dtiError.json');
 st.upload(fullFilename,'project',project{1}.project.x_id);

 % Clean up
 st.fw.deleteProject(project{1}.project.x_id);

%}

%% Parse inputs
p = inputParser;

p.addRequired('filename',@(x)(exist(x,'file')));
vFunc = @(x)(ismember(x,{'project','session','acquisition','collection'}));
p.addRequired('containerType', vFunc);
p.addRequired('containerId',@ischar);

p.parse(filename,containerType,containerId,varargin{:});

filename      = p.Results.filename;
containerType = p.Results.containerType;
containerId   = p.Results.containerId;

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