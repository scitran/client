function idS = create(obj, group, project, varargin)
% Create a project, session or acquisition on a Flywheel instance
%
% Syntax
%   idS = st.create(groupL, projectL,'session',sessionLabel,'acquisition',acquisitionLabel)
%
% How do we deal with groups?
%
% Check if the project exists.  If not, create it.
% Check if the session exists within the project.  If not, create it.
% Check if the acq exists within the session. If not, well you get the
% idea.
%
% Inputs
%  groupL   - Group Label
%  projectL - Project Label
%
% Parameters
%  session - Session label
%  acquisiton - Acquisition label
%
% Returns:
%   idS - Struct containiing the ids of the created objects, such as
%     idS.project, idS.session, idS.acquisition
%
% RF/BW Scitran Team, 2016

% Examples:
%{
  st = scitran('vistalab');

  %  Create a project
  gName = 'Wandell Lab';
  pLabel = 'deleteMe';
  id = st.create(gName, pLabel);
  status = st.exist('project',pLabel)

  st.fw.deleteProject(id.project);

  % Create a session within a project
  sLabel = 'deleteSession';
  id = st.create(gName, pLabel,'session',sLabel);

  st.fw.deleteSession(id.session);
  st.fw.deleteProject(id.project);

  % Create an acquisition within a session within a project
  aLabel = 'deleteAcquisition'
  id = st.create(gName, pLabel,'session',sLabel,'acquisition',aLabel);

  st.fw.deleteAcquisition(id.acquisition);
  st.fw.deleteSession(id.session);
  st.fw.deleteProject(id.project);

  % When you create an acquisition, you can use the returned id to put a
  % file, as in
  id = st.create(gName, pLabel,'session',sLabel,'acquisition',aLabel);
  st.uploadFile('file',filename,'id',id.acquisition);

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

%% Check whether the group exists

% Exits on error.  You have to have a group.
[status, groupId] = obj.exist('group',group);
if ~status
    error('No group found with label %s\n',group);
end

%% On to the project level

% Does the project exist? 
[status, idS.project] = obj.exist('project',project);
if ~status
    % If not, add it. Should we check with the user?
    idS.project = obj.fw.addProject(struct('label',project,'group',groupId));
end

% Maybe we are adding some project data?
if isfield(additionalData, 'project'), prjData = additionalData.project;
else,                                  prjData = struct;
end

% If no session is passed, then we are done and return the project ID
if isempty(session), return; end

%% Test for the session label; does it exist? If not create it

[status, idS.session] = obj.exist('session', session, 'parentID', idS.project);
if ~status
    % If not, add it. Should we check with the user?
    idS.session = obj.fw.addSession(struct('label', session, 'project', idS.project));
end

% Maybe we are adding some session data?
if isfield(additionalData, 'session'), sesData = additionalData.session;
else,                                  sesData = struct;
end

% If no session is passed, then we are done and return the project ID
if isempty(acquisition), return; end

%% Test for the acquisition label; does it exist? If not create it

[status, idS.acquisition] = obj.exist('acquisition', acquisition, 'parentID', idS.session);
if ~status
    idS.acquisition = obj.fw.addAcquisition(struct('label', acquisition,'session', idS.session));
end

% Maybe we are adding some acquisition data?
if isfield(additionalData, 'acquisition'), acqData = additionalData.acquisition;
else,                       acqData = struct;
end

end


%%
    %id = createPrivate(obj, 'acquisitions', acquisition, 'session', sessionID, acqData);

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
