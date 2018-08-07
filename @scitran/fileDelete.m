function status = fileDelete(st, filename, containerid, containertype )
% Deletes a file from a container on a Flywheel site.  
% 
%  status = scitran.fileDelete(obj, file, containerid, containertype)
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
  localFilename = fullfile(stRootPath,'local','test.json');
  s.test = '123';
  s.more = '456';
  jsonwrite(localFilename,s);
  project = st.search('projects','project label exact','DEMO');
  [id,cType] = st.objectParse(project{1});
  st.fileUpload(localFilename,id,cType);

  % This is the delete operation based on search
  file = st.search('file',...
    'project label exact','DEMO',...
    'filename','dtiError.json');

  file = st.search('file',...
    'project label exact','DEMO',...
    'filename','test.json');

  st.fileDeleteFile(file);
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

% varargin = stParamFormat(varargin);

% We should be able to deal with a cell array of FileEntry types.
% And maybe a cell array of filenames.
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('filename',@ischar);
p.addRequired('containertype',@ischar);
p.addRequired('containerid',@ischar);

% Parse and sort
p.parse(st,filename,containertype,containerid);

%% Delete

% Delete a file from one of these types of containers
switch containertype
    case 'project'
        status = st.fw.deleteProjectFile(containerid,filename);
    case 'acquisition'
        status = st.fw.deleteAcquisitionFile(containerid,filename);
    case 'session'
        status = st.fw.deleteSessionFile(containerid,filename);
    case 'collection'
        status = st.fw.deleteCollectionFile(containerid,filename);
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
