function [status, id, results] = exist(obj, objectType, label, varargin)
% Test whether a project, session, acquisition with a label exists
%
%  [status, id, results] = st.exist(objectType, label, varargin)
%
% Searches for a type of object with a specific (case-sensitive) label.
%
% Returns:
%   status  - Logical (true/false)
%   id      - The id of the object(s) (acq, or session, or project)
%   results - Cell array of the matching search result
%
% RF/BW Scitran Team, 2016

% Example
%{
 % The results are all the objects of that type within the project or
 % session.  
  [status, pid, results] = st.exist('project','VWFA FOV')
  [status, gid, results] = st.exist('group','Wandell Lab')
  [status, sid, results] = st.exist('session','20151128_1621','parentID', pid)
  [status, aid, results] = st.exist('acquisition','10_1_fMRI_Ret_knk','parentID', sid)
%}


%%
p = inputParser;
p.addRequired('label',@ischar);
allowableContainers = {'project','session','acquisition','group'};
p.addRequired('objectType',@(x)(ismember(x,allowableContainers)));
p.addParameter('parentID',[], @ischar);
p.parse(label, objectType, varargin{:});

label        = p.Results.label;
objectType   = p.Results.objectType;
parentID     = p.Results.parentID;

%% For different container types, we do different things

id = [];
status = false;
switch objectType
    case 'group'
        groups = obj.fw.getAllGroups;
        results = groups;
        for ii=1:numel(groups)
            if strcmp(groups{ii}.label,label)
                status = true;
                id = groups{ii}.id;
                return;
            end
        end
    case 'project'
        projects = obj.fw.getAllProjects;
        results = projects;
        for ii=1:numel(projects)
            if strcmp(projects{ii}.label,label)
                status = true;
                id = projects{ii}.id;
                return;
            end
        end
    case 'session'
        % In this case, the parentID (project) is required
        % st.exist('session',label,'parentID',projectID);
        if isempty(parentID), error('Project ID required'); end
        sessions = obj.fw.getProjectSessions(parentID);
        results = sessions;
        % NOTE:  This is an array of structs.  The project is a cell array.
        % Sigh.
        for ii=1:numel(sessions)
            if strcmp(sessions(ii).label,label)
                status = true;
                id = sessions(ii).id;
                return;
            end
        end
    case 'acquisition'
        % In this case the parentID (session) is required
        % st.exist('acquisition',label,'parentID',projectID);
        if isempty(parentID), error('Session ID required'); end
        acquisitions = obj.fw.getSessionAcquisitions(parentID);
        results = acquisitions;
        % NOTE:  This is an array of cells again. 
        % To fix.
        for ii=1:numel(acquisitions)
            if strcmp(acquisitions{ii}.label,label)
                status = true;
                id = acquisitions{ii}.id;
                return;
            end
        end
    otherwise
        error('Unknown object type');
end

end

