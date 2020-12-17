function idS = containerCreate(obj, group, project, varargin)
% Create a project, session or acquisition on a Flywheel instance
%
% Synopsis
%   idS = st.containerCreate(groupLabel, projectLabel,...)
%
% Brief description:
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
% Optional Parameters - these are a
%  subject       - Subject code
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
p.addParameter('subject','Unknown',@ischar);
p.addParameter('session','',@ischar);
p.addParameter('acquisition','',@ischar);

% Not yet implemented.  But we may permit attaching data here to add to the
% newly created objects.
% p.addParameter('additionalData', struct, @isstruct);

p.parse(group,project,varargin{:});

group            = p.Results.group;
projectLabel     = p.Results.project;
subjectCode      = p.Results.subject;
sessionLabel     = p.Results.session;
acquisitionLabel = p.Results.acquisition;

%% Check whether the group exists

% Exits on error.  You have to have a group.
[status, groupId] = obj.exist('group',group);
if ~status
    error('No group found with label %s\n',group);
end

%% On to the project level

% Does the project exist?
[status, idS.project] = obj.exist('project',projectLabel);
if ~status
    % If not, add it.
    idS.project = obj.fw.addProject(struct('label',projectLabel,'group',groupId));
end

% Always get the project because we will probably need it either for the
% subject or adding a session.
project = obj.fw.get(idS.project);

%% Does the subject exist?

subjects    = project.subjects();
thisSubject = stSelect(subjects,'code',subjectCode);
if isempty(thisSubject)    
    % Not there, so create the subject for this project with this label
    thisSubject = project.addSubject('label',subjectCode,'code',subjectCode);
end
if iscell(thisSubject)
    thisSubject = thisSubject{1};
end

% Add the subject ID to the output
idS.subject = thisSubject.id;

%% If no session label is passed, we are done and return the project ID

% Then, we check whether a session with the name 'session' already exists.
% If it does, we return
if isempty(sessionLabel), return; end

%% We have a session and a subject

sessions    = project.sessions();
thisSession = stSessionExists(sessions,sessionLabel,...
    'subject code',subjectCode);

% A session for this subject does not exist, so create it.
if isempty(thisSession)
    % Create it from the project level
    thisSession = project.addSession(struct('label', sessionLabel, ...
        'project', idS.project));
    obj.containerSet(thisSession,'timestamp',datetime('now'));
    obj.containerSet(thisSession,'subject',thisSubject);
end
idS.session = thisSession.id;

%% Test for the acquisition label; does it exist? If not create it
if isempty(acquisitionLabel), return; end

acquisitions = thisSession.acquisitions();
if isempty(acquisitions)
    % No acquisitions at all.
    thisAcquisition = thisSession.addAcquisition('label', acquisitionLabel);
else
    thisAcquisition = stAcquisitionExists(thisSession,acquisitionLabel);
    if isempty(thisAcquisition)
        % There are acquisitions, just not the one we want.
        thisAcquisition = thisSession.addAcquisition('label', acquisitionLabel);
    end
end

idS.acquisition = thisAcquisition.id;

end

