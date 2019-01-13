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

% Examples:
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
        if isempty(projects), return; end
        
        % We always check about conversion, see note below in acquisitions
        if isstruct(projects)
            results = cell(numel(projects),1);
            for ii=1:numel(projects)
                results{ii} = projects(ii);
            end
        else, results = projects;
        end

        for ii=1:numel(results)
            if strcmp(results{ii}.label,label)
                status = true;
                id = results{ii}.id;
                return;
            end
        end
    case 'session'
        % In this case, the parentID (project) is required
        % st.exist('session',label,'parentID',projectID);
        if isempty(parentID), error('Project ID required'); end
        sessions = obj.fw.getProjectSessions(parentID);
        if isempty(sessions), return; end

        % We  always convert the acquisitions to a cell array
        % because of the note below.  Not sure we ever have a problem with
        % sessions, but just in case, I put this here.  If we end up using
        % this a lot, we should have a function structArray2CellArray
        if isstruct(sessions)
            results = cell(numel(sessions),1);
            for ii=1:numel(sessions)
                results{ii} = sessions(ii);
            end
        else, results = sessions;
        end

        for ii=1:numel(results)
            if strcmp(results{ii}.label,label)
                status = true;
                id = results{ii}.id;
                return;
            end
        end
    case 'acquisition'
        % In this case the parentID (session) is required
        % st.exist('acquisition',label,'parentID',projectID);
        if isempty(parentID), error('Session ID required'); end
        acquisitions = obj.fw.getSessionAcquisitions(parentID);
        if isempty(acquisitions), return; end
           
        % We should always convert the acquisitions to a cell array because
        % a cell array is returned some times (not always). This happens
        % when an acquisition has files or doesn't have files, the structs
        % would differ, so they give us a cell.  They should probably
        % always give us cell arrays.  To discuss.  (BW)
        if isstruct(acquisitions)
            results = cell(numel(acquisitions),1);
            for ii=1:numel(acquisitions)
                results{ii} = acquisitions(ii);
            end
        else, results = acquisitions;
        end
        
        
        for ii=1:numel(results) 
            if strcmp(results{ii}.label,label)
                status = true;
                id = results{ii}.id;
                return;
            end
        end
                   
    otherwise
        error('Unknown object type %s',objectType);
end

end

