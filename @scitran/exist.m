function [status, id, results] = exist(st, objectType, label, varargin)
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
  [status, gid, results] = st.exist('group','Wandell Lab')
  [status, pid, results] = st.exist('project','VWFA FOV')
  [status, sid, results] = st.exist('session','20151128_1621','parentID', pid)
  [status, aid, results] = st.exist('acquisition','10_1_fMRI_Ret_knk','parentID', sid)
%}


%% Parse - parentID is required in some cases

p = inputParser;

allowableContainers = {'project','session','acquisition','group'};
p.addRequired('st',@(x)(isequal(class(x),'scitran')));
p.addRequired('label',@ischar);
p.addRequired('objectType',@(x)(ismember(x,allowableContainers)));

p.addParameter('parentID',[], @ischar);
p.parse(st,label, objectType, varargin{:});

label        = p.Results.label;
objectType   = p.Results.objectType;
parentID     = p.Results.parentID;

if (isequal(objectType,'acquisition') || isequal(objectType,'session')) && ...
        isempty(parentID)
    error('Parent ID required for session and acquisition');
end

%% For different container types, we do different things

id = [];
status = false;
switch objectType
    case 'group'
        groups = st.groups;
        results = stSelect(groups,'label',label);
        if ~isempty(results)
            status = true;
            id = results{1}.id;
        end
        
    case 'project'
        projects = st.fw.getAllProjects;
        results = stSelect(projects,'label',label,'contains',false);
        if ~isempty(results)
            status = true;
            id = results{1}.id;
        end
        
    case 'session'
        % In this case, the parentID (project) is required
        % st.exist('session',label,'parentID',projectID);
        project = st.fw.get(parentID);
        session = project.sessions.findOne(sprintf('label=%s',label));
        if ~isempty(session)
            status = true;
            id = session.id;
            clear results;
            results{1} = session;
        end
        
    case 'acquisition'
        % In this case the parentID (session) is required
        % st.exist('acquisition',label,'parentID',projectID);        
        session = st.fw.get(parentID);
        acquisition = session.acquisitions.findOne(sprintf('label=%s',label));
        if ~isempty(acquisition)
            status = true;
            id = acquisition.id;
            clear results;
            results{1} = acquisition;
        end
                   
    otherwise
        error('Unknown object type %s',objectType);
end

end

