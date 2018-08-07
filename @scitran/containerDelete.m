function containerDelete(st, object, varargin )
% Deletes an object from a Flywheel site.  
% 
%  st.containerDelete(object, varargin)
%  st.containerDelete([],'container type',ct,'container id',id);
%
% Required
%    object - a Flywheel search response or List return
%
% Key/value pairs inputs
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

% Examples
%{
%}

%%
p = inputParser;

p.addRequired('object');

vFunc = @(x)(ismember(x,{'project','session','acquisition','collection'}));
p.addParameter('containerType', vFunc);
p.addParameter('containerID',@ischar);
p.addParameter('query',false,@islogical);

% Parse 
p.parse(object,varargin{:});

% We can allow people to send in an empty object if they provide the
% container type and id as parameters.
containerType  = p.Results.containerType;
containerID    = p.Results.containerID;
query          = p.Results.query;

[containerID, containerType] = st.objectParse(object,containerType, containerID);

%% Delete

switch containerType
    case 'project'
        % If the project contains sessions, or the query flag is true, we
        % ask the user.
        sessions = st.fw.getProjectSessions(containerID);
        if ~isempty(sessions) ||  query
            project = st.containerInfoGet('project',containerID);
            prompt = sprintf('Delete project named "%s": (y/n) ',project.label);
            str = input(prompt,'s');
            if ~isequal(lower(str(1)),'y')
                disp('User canceled.'); 
                return;
            end
        end
        st.fw.deleteProject(containerID);
        
    case 'session'
        st.fw.deleteSession(containerID);
    case 'acquisition'
        st.fw.deleteAcquisition(containerID);
    case 'collection'
        st.fw.deleteCollection(containerID);
    otherwise
        error('Unknown container type %s\n',containerType);
end

end