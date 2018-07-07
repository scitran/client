function containerDelete(obj, containerType, containerID, varargin )
% Deletes an object from a Flywheel site.  
% 
%  st.containerDelete(obj, containerType, containerID, varargin)
%
% Required inputs
%    containerId - string that identifies the Flywheel object
%    containerType - {'project','session','acquisition','collection'}
%
% Optional parameters
%    query - This applies to project deletion. If the project contains
%            sessions, we ask the user before deleting. Setting this to
%            true, then the user will always be asked even if there are no
%            sessions (default: false).
%
% RF 2017

%{ 
   % Examples

   % Create a project hierarcy and upload a file.  Try various deletions.
   st = scitran('stanfordlabs'); 
   gName = 'Wandell Lab';
   pLabel = 'deleteMe';
   sLabel = 'deleteSession';
   aLabel = 'deleteAcquisition';
   id     = st.create(gName, pLabel,'session',sLabel,'acquisition',aLabel);

   fullFileName = fullfile(stRootPath,'data','dtiError.json');
   st.upload(fullFileName,'project',id.project);
   files = st.search('file',...
      'project label exact',pLabel,...
      'file name','dtiError.json');
   
   % Delete a project.  Scary
   containerType = 'project';
   containerID = id.project;
   st.deleteContainer(containerType,containerID);

   % Delete the session and then the project
   s = st.search('session',...
          'session label exact',sLabel,...
          'project label exact',pLabel);
   st.deleteContainer('session',s{1}.session.x_id);
   
   containerType = 'project';
   containerID = id.project;
   st.deleteContainer(containerType,containerID);

   % Delete the acquisition and then the project
   a = st.search('acquisition',...
          'acquisition label exact',aLabel,...
          'project label exact',pLabel);
   st.deleteContainer('acquisition',a{1}.acquisition.x_id);
   
   containerType = 'project';
   containerID = id.project;
   st.deleteContainer(containerType,containerID);

%}

%%
p = inputParser;

vFunc = @(x)(ismember(x,{'project','session','acquisition','collection'}));
p.addRequired('containerType', vFunc);
p.addRequired('containerID',@ischar);
p.addParameter('query',false,@islogical);

% Parse 
p.parse(containerType,containerID,varargin{:});

containerType  = p.Results.containerType;
containerID    = p.Results.containerID;
query          = p.Results.query;

%% Delete

switch containerType
    case 'project'
        % If the project contains sessions, or the query flag is true, we
        % ask the user.
        sessions = obj.fw.getProjectSessions(containerID);
        if ~isempty(sessions) ||  query
            project = obj.containerInfoGet('project',containerID);
            prompt = sprintf('Delete project named "%s": (y/n) ',project.label);
            str = input(prompt,'s');
            if ~isequal(lower(str(1)),'y')
                disp('User canceled.'); 
                return;
            end
        end
        obj.fw.deleteProject(containerID);
        
    case 'session'
        obj.fw.deleteSession(containerID);
    case 'acquisition'
        obj.fw.deleteAcquisition(containerID);
    case 'collection'
        obj.fw.deleteCollection(containerID);
    otherwise
        error('Unknown container type %s\n',containerType);
end

end