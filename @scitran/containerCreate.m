function idS = containerCreate(obj, group, project, varargin)
% Create a project, session or acquisition on a Flywheel instance
%
% Syntax
%   idS = st.containerCreate(groupL, projectL,...
%                 'session',sessionLabel,...
%                 'acquisition',acquisitionLabel)
%
% Description:
%   Make a container. Top level is a project; then a session, and then
%   an acquisition.  In each case we check if the object already
%   exists, and if not, we create it. We return a struct with the
%   Flywheel id value of the objects that we create.
%
%   There is a separate function (collectionCreate) for collections.
%
% Required Inputs
%  groupL   - Group Label
%  projectL - Project Label
%
% Optional Parameters
%  subject       - Make sure the project has a subject with this name 
%  session       - Session label
%  acquisition   - Acquisition label
%
% Returns:
%   idS - Struct containing the ids of the containers created, such as
%         idS.project, idS.session, idS.acquisition
%
% BW Scitran Team, 2016
%
% See also:  
%  deleteContainer
%

% Examples:
%{
  st = scitran('stanfordlabs');

  %  Create a project
  gName  = 'Wandell Lab';
  pLabel = 'deleteMe';
  id = st.containerCreate(gName, pLabel);
  status = st.exist('project',pLabel)

  st.fw.deleteProject(id.project);
%}
%{
  % Create a session within a project
  pLabel = 'deleteSubject';
  subject = 'noone';
  sLabel = 'deleteSession';
  id = st.containerCreate(gName, pLabel,...
                'subject',subject,...
                'session',sLabel);
  st.fw.deleteSession(id.session);
  st.fw.deleteProject(id.project);
%}
%{
  % Create an acquisition within a session within a project
  % No subject for the session this time. 
  pLabel = 'deleteSubject';
  sLabel = 'deleteSession';
  aLabel = 'deleteAcquisition'
  id = st.containerCreate(gName, pLabel,...
       'session',sLabel,...
       'acquisition',aLabel);

  st.fw.deleteAcquisition(id.acquisition);
  st.fw.deleteSession(id.session);
  st.fw.deleteProject(id.project);

  % When you create an acquisition, you can use the returned id to put a
  % file, as in
  id = st.create(gName, pLabel,'session',sLabel,'acquisition',aLabel);
  st.uploadFile('file',filename,'id',id.acquisition);

%}

%% Input arguments are the project/session/acquisition labels

varargin = stParamFormat(varargin);

p = inputParser;
p.addRequired('group',@ischar);
p.addRequired('project',@ischar);
p.addParameter('session',[],@ischar);
p.addParameter('subject',[],@ischar);

p.addParameter('acquisition',[],@ischar);

% Not yet implemented.  But we may permit attaching data here to add to the
% newly created objects.
% p.addParameter('additionalData', struct, @isstruct);

p.parse(group,project,varargin{:});

group       = p.Results.group;
project     = p.Results.project;
session     = p.Results.session;
acquisition = p.Results.acquisition;
subject     = p.Results.subject;

% additionalData = p.Results.additionalData;  % NYI

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
    % If not, add it.
    idS.project = obj.fw.addProject(struct('label',project,'group',groupId));
end

% Always get the project because we will probably need it either for the
% subject or adding a session.  
project = obj.fw.get(idS.project);

%% Did the person want a subject  created?

if isempty(subject)
    % User believes the subject is already part of the project
    idS.subject = '';
else
    % User says create a subject for this project with this label
    subject = project.addSubject('label',subject,'code',subject);
    idS.subject = subject.id;
end

%% If no session is passed, then we are done and return the project ID
if isempty(session), return; end

% Create a new session for this subject.
if exist('subject','var') && ~isempty(subject)
    session = subject.addSession('label',session);
else
    session = project.addSession(struct('label', session, 'project', idS.project));
end

idS.session = session.id;

%% Test for the acquisition label; does it exist? If not create it
if isempty(acquisition), return; end

acq = session.addAcquisition('label', acquisition);
idS.acquisition = acq.id;

end

