function id = create(obj, group, project, varargin)
% Create a project, session or acquisition on a flywheel instance
%
%   st.create(group, project,'session',sessionLabel,'acquisition',acquisitionLabel)
%
% How do we deal with groups?
%
% Check if the project exists.  If not, create it.
% Check if the session exists within the project.  If not, create it.
% Check if the acq exists within the session. If not, well you get the
% idea.
%
% Inputs
%  project - Required project name
%  object-name pairs
%
% Returns:
%   ID of the created object
%
% Examples:
%
%  Create a project
%    idP = st.create(gName, pLabel);
%
% Create a session within a project
%    idS = st.create(gName, pLabel,'session',sLabel);
%
% Create an acquisition within a session within a project
%    idA = st.create(gName, pLabel,'session',sLabel,'acquisition',aLabel);
%
% When you create an acquisition, you can use the returned idA to put a
% file, as in
%
%     st.put('file',filename,'id',idA);
%
% For example, we add an acquisition to the Logothetis_DES
%
%   st.create('Logothetis_DES','session','folderName','acquisition','FMRI');
% or
%   st.create('Logothetis_DES','session','folderName','acquisition','Anatomical');
%
% RF/BW Scitran Team, 2016

%% Input arguments are the project/session/acquisition labels

p = inputParser;
p.addRequired('group',@ischar);
p.addRequired('project',@ischar);
p.addParameter('session',[],@ischar);
p.addParameter('acquisition',[],@ischar);

p.parse(group,project,varargin{:});

group       = p.Results.group;
project     = p.Results.project;
session     = p.Results.session;
acquisition = p.Results.acquisition;

% Returned value is only empty on an error
id = [];

%% Check whether the group exists
[status, groupID] = obj.exist(group, 'groups');

if ~status
    error('group does not exist');
elseif status ~= 1
    error('multiple group found with name %s', group);
end



%% Test for the project label; does it exist on flywheel? If not create it
[status, projectID] = obj.exist(project, 'projects', 'parentID', groupID{1});

% If it does not exist, we check with the user and then create it.
if ~status
    projectID = createPrivate(obj, 'projects', project, 'group', groupID{1});
elseif status ~= 1
    return
else
    projectID = projectID{1};
end

% We now have a project id

% If no session is passed, then we are done and return the project ID
if isempty(session), id = projectID; return; end


%% Test for the session label; does it exist on flywheel? If not create it
[status, sessionID] = obj.exist(session, 'sessions', 'parentID', projectID);

if ~status
    sessionID = createPrivate(obj, 'sessions', session, 'project', projectID);
elseif status ~= 1
    return
else
    sessionID = sessionID{1};
end

% In this case, return the session ID
if isempty(acquisition), id = sessionID; return; end


%% Test for the acquisition label; does it exist on flywheel? If not create it
[status, acquisitionID] = obj.exist(acquisition, 'acquisitions', 'parentID', sessionID);

if ~status
    id = createPrivate(obj, 'acquisitions', acquisition, 'session', sessionID);
elseif status ~= 1
    return
else
    id = acquisitionID{1};
end
    

end

%% Private method that creates a single container
function id = createPrivate(obj, containerType, label, parentType, parentID)
    payload.(parentType) = parentID;
    payload.label = label;
    payload = jsonwrite(payload);
    cmd = obj.createCmd(containerType, payload);
    [status, result] = system(cmd);
    if status
        error(result);
    end
    % result = loadjson(result);
    result = jsonread(result);
    id = result.x0x5F_id;
end
