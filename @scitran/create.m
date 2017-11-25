function id = create(obj, group, project, varargin)
% Create a project, session or acquisition on a Flywheel instance
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
% RF/BW Scitran Team, 2016

% Examples:
%{
  st = scitran('vistalab');

  %  Create a project
  gName = 'Wandell Lab';
  pLabel = 'deleteMe';
  idP = st.create(gName, pLabel);

  % Create a session within a project
  idS = st.create(gName, pLabel,'session',sLabel);

  % Create an acquisition within a session within a project
  idA = st.create(gName, pLabel,'session',sLabel,'acquisition',aLabel);

  % When you create an acquisition, you can use the returned idA to put a
  % file, as in
  st.uploadFile('file',filename,'id',idA);

  % For example, we add an acquisition to the Logothetis_DES
  st.create('Logothetis_DES','session','folderName','acquisition','FMRI');

% or

  st.create('Logothetis_DES','session','folderName','acquisition','Anatomical');
%}

%% Input arguments are the project/session/acquisition labels

p = inputParser;
p.addRequired('group',@ischar);
p.addRequired('project',@ischar);
p.addParameter('session',[],@ischar);
p.addParameter('acquisition',[],@ischar);
p.addParameter('additionalData', struct, @isstruct);

p.parse(group,project,varargin{:});

group       = p.Results.group;
project     = p.Results.project;
session     = p.Results.session;
acquisition = p.Results.acquisition;
additionalData = p.Results.additionalData;

% Returned value is only empty on an error
id = [];

%% Check whether the group exists

% Exits on error.  You have to have a group.
if ~obj.exist('group',group)
    error('No group with the label %s\n',group);
end

%% On to the project level

if isfield(additionalData, 'project'), prjData = additionalData.project;
else,                                  prjData = struct;
end

% Does the project exist? 
[status, id] = obj.exist('project',project);
if ~status
    % If not, add it.  Not sure how it knows about the group.
    obj.fw.addProject(project);
end



% If it does not exist, we check with the user and then create it.
if ~status
elseif status ~= 1
    return
else
    projectID = projectID{1};
end

% We now have a project id

% If no session is passed, then we are done and return the project ID
if isempty(session), id = projectID; return; end



%% Test for the session label; does it exist on flywheel? If not create it



%% Test for the session label; does it exist on flywheel? If not create it

if isfield(additionalData, 'session')
    sesData = additionalData.session;
else
    sesData = struct;
end

[status, sessionID] = obj.exist(session, 'sessions', 'parentID', projectID);

if ~status
    sessionID = createPrivate(obj, 'sessions', session, 'project', projectID, sesData);
elseif status ~= 1
    return
else
    sessionID = sessionID{1};
end

%% Test for the acquisition label; does it exist on flywheel? If not create it
[status, acquisitionID] = obj.exist(acquisition, 'acquisitions', 'parentID', sessionID);

if isfield(additionalData, 'acquisition')
    acqData = additionalData.acquisition;
else
    acqData = struct;
end

if ~status
    id = createPrivate(obj, 'acquisitions', acquisition, 'session', sessionID, acqData);
elseif status ~= 1
    return
else
    id = acquisitionID{1};
end
    

end


%%

%% Private method that creates a single container
% function id = createPrivate(obj, containerType, label, parentType, parentID, additionalContent)
%     payload.(parentType) = parentID;
%     payload.label = label;
%     additionalFields = fieldnames(additionalContent);
%     for i = 1:length(additionalFields)
%         payload.(additionalFields{i}) = additionalContent.(additionalFields{i});
%     end
%     payload = jsonwrite(payload,struct('indent','  ','replacementstyle','hex'));
%     cmd = obj.createCmd(containerType, payload);
%     [status, result] = stCurlRun(cmd);
%     if status
%         error(result);
%     end
%     result = jsonread(result);
%     id = result.x_id;
%     
% end
