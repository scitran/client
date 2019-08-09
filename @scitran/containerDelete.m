function containerDelete(st, container, varargin )
% Deletes an object from a Flywheel site.  
% 
%  st.containerDelete(container, varargin)
%
% Required
%  container - a Flywheel container
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

% Examples:
%{
%  None.
%}

%%
p = inputParser;

p.addRequired('container');
p.addParameter('query',false,@islogical);  % Check before deleting a project

% Parse 
p.parse(container,varargin{:});

query = p.Results.query;

[containerID, containerType] = st.objectParse(container);

%% Delete

switch containerType
    case 'project'
        % If the project contains sessions, or the query flag is true, we
        % ask the user before deleting
        sessions = st.fw.getProjectSessions(containerID);
        if ~isempty(sessions) ||  query
            project = st.containerGet(containerID);
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