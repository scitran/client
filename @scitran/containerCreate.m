function idS = containerCreate(obj, group, project, varargin)
% Create a project, session or acquisition on a Flywheel instance
%
% Syntax
%   idS = st.containerCreate(groupLabel, projectLabel,...
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
%  groupLabel   - Group Label
%  projectLabel - Project Label
%
% Optional Parameters (thes4e are a
%  subject       - Subject name
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
%  containerDelete
%

% Examples:
%{
  st = scitran('stanfordlabs');

  %  Create a project
  gName  = 'Wandell Lab';
  pLabel = 'deleteMe';
  id = st.containerCreate(gName, pLabel);
  status = st.exist('project',pLabel)

  % Also testing containerDelete here
  project = st.fw.get(id.project);
  st.containerDelete(project,'query',true);

  % Another way to do the deletion.  We use this below for session
  % and acquisition
  % st.fw.deleteProject(id.project);
%}
%{
  % Create a session within a project
  pLabel = 'deleteSubject';
  subject = 'noone';
  sLabel = 'deleteSession';
  id = st.containerCreate(gName, pLabel,...
                'subject',subject,...
                'session',sLabel);

  session = st.fw.get(id.session);
  st.containerDelete(session);

  % st.fw.deleteSession(id.session);
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

  acq = st.fw.get(id.acquisition);
  st.containerDelete(acq);

  % st.fw.deleteAcquisition(id.acquisition);
  st.fw.deleteSession(id.session);
  st.fw.deleteProject(id.project);
%}
%{
  % Create a new session within an existing project
  st = scitran('stanfordlabs');
  project = st.lookup('aldit/Recon Test');
  id = st.containerCreate(project.group,project.label,'session','deleteMe');
  st.fw.deleteSession(id.session);
%}

%% Input arguments are the project/session/acquisition labels

varargin = stParamFormat(varargin);

p = inputParser;
p.addRequired('group',@ischar);
p.addRequired('project',@ischar);
p.addParameter('subject','',@ischar);
p.addParameter('session',[],@ischar);

p.addParameter('acquisition',[],@ischar);

% Not yet implemented.  But we may permit attaching data here to add to the
% newly created objects.
% p.addParameter('additionalData', struct, @isstruct);

p.parse(group,project,varargin{:});

group       = p.Results.group;
project     = p.Results.project;
subject     = p.Results.subject;
session     = p.Results.session;
acquisition = p.Results.acquisition;

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

%% Did the user supply a subject or want one created?

subjectLabel = subject;
if isempty(subjectLabel)
    % This is still the subject label.
    % User believes the subject is already part of the project, so empty.
    % But we don't know what subject to assign, so it will be the default,
    % which is 'unknown'.
    idS.subject = '';
else
    % Subject label exists, so try to find the subject.
    str = sprintf('label=%s',subjectLabel);
    try
        % Should work.  ASK LMP.
        % subject = project.subjects.findOne(str);
        subjects = project.subjects();
        thisSubject = stSelect(subjects,'label',subjectLabel);
        subject = thisSubject{1};
    catch
        % Not there, so create the subject for this project with this label
        subject = project.addSubject('label',subjectLabel,'code',subject);
    end
    
    % Add the subject ID to the outpu
    idS.subject = subject.id;
end

%% If no session is passed, then we are done and return the project ID

% Then, we check whether a session with the name 'session' already exists.
% If it does, we return
if isempty(session), return; end
sessionLabel = session;
str = sprintf('label=%s',sessionLabel);

% The user passed a name and it does not exist.
% Create a new session for this subject, or if no subject with a
% default subject.
if exist('subject','var') && ~isempty(subject)
    % Subject exists
    try
        session = subject.sessions.findOne(str);
    catch
        session = subject.addSession('label',sessionLabel);
    end
else
    % No subject.  So find the session from within the project.
    try
        % This is a test if the session exists
        session = project.sessions.findOne(str);
    catch
        % Create it from the project level
        session = project.addSession(struct('label', sessionLabel, 'project', idS.project));
        
        % [status, idS.session] = obj.exist('session', session, 'parentID', idS.project);
        % if ~status
        % If not, add it. Should we check with the user?
        %
        % idS.session = obj.fw.addSession(struct('label', session, 'project', idS.project));
        %{
              % If the subject exists, we should also update the subject field when
              % we create a session
              if ~isempty(subjectLabel)
                thisSession = st.fw.get(idS.session);
                thisSubject = thisSession.subject;
                thisSubject.update('label',subjectLabel);
              end
        %}
        % end
    end
end

idS.session = session.id;

%% Test for the acquisition label; does it exist? If not create it
if isempty(acquisition), return; end
acquisitionLabel = acquisition;
str = sprintf('label=%s',acquisitionLabel);

try
    acq = session.acquisition.findOne(str);
catch
    acq = session.addAcquisition('label', acquisitionLabel);
end

idS.acquisition = acq.id;

end

