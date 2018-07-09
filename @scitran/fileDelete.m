function status = fileDelete(st, file, containerid, varargin )
% Deletes a file from a container on a Flywheel site.  
% 
%  status = scitran.fileDelete(obj, file, containerid, varargin)
%
% Required parameter
%  file - string or flywheel.model.FileEntry
%    if a string, we need the containerID and type, see below.
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

  st.upload(localFilename,'project',idGet(project,'data type','project'));

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

varargin = stParamFormat(varargin);

% We should be able to deal with a cell array of FileEntry types.
% And maybe a cell array of filenames.
p.addRequired('st',@(x)(isa(x,'scitran')));

% Either a flywheel model file or just the file id
p.addRequired('file',@(x)( isa(x,'flywheel.model.FileEntry') || ischar(x)));
p.addRequired('containertype',@ischar);

% Parse and sort
p.parse(st,file,containertype,varargin{:});

if isa(file,'flywheel.model.FileEntry')
    containerType = p.Results.containertype;
    id            = p.Results.file.id;
else
    % User sent in the id, not the file
    containerType  = p.Results.containertype;
    id             = p.Results.file;
end

%% Delete

% Delete a file from one of these types of containers
switch containerType
    case 'project'
        status = st.fw.deleteProjectFile(id);
    case 'acquisition'
        status = st.fw.deleteAcquisitionFile(id);
    case 'session'
        status = st.fw.deleteSessionFile(id);
    case 'collection'
        status = st.fw.deleteCollectionFile(id);
    otherwise  
      error('deleteFile is not implemented for container type %s\n',containerType)
end

end
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
