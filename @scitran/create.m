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
% Required Inputs
%  group     - group name
%  project   - project label
%
% Input parameter/values
%  'session'        - session label
%  'acquisition'    - acquisition label
%  'additionalData' - Struct of additional data is unclear to me ????.
%                     There is an example in desFMRI/uploadDES.m
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
% When you create an acquisition, you can use the returned acquisition id,
% idA, to put a file 
%
%     st.put('file',filename,'id',idA);
%
% For example, we can add an acquisition to the Logothetis_DES project
% inside of folderName, with a specific acquisition label
%
%   idA = st.create('Logothetis_DES','session','folderName','acquisition','FMRI');
%   st.put('file',fullFmriFileName,'id',idA);
%
% or
%   idA = st.create('Logothetis_DES','session','folderName','acquisition','Anatomical');
%   st.put('file',fullAnatomicalFileName,'id',idA);
%
% RF/BW Scitran Team, 2016

%% Programming TODO
%
%   1. We should allow sending the projectID or sessionID rather than the
%   label. This could speed things up a bit.
%

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
[status, groupID] = obj.exist(group, 'groups');

% If the group doesn't exist, we should report back that we can't do
% anything.
if isempty(status), error('No group with name %s was found\n',group); end

%% OK, we have a group.  Now look for the project data.
if isfield(additionalData, 'project'),  prjData = additionalData.project;
else,                                   prjData = struct;
end

% If the project does not exist, we check with the user and then create it.
[status, projectID] =  obj.exist(project, 'projects', 'parentID', groupID{1});

% If it does not exist, we check with the user and then create it.
if ~status
    projectID = createPrivate(obj, 'projects', project, 'group', groupID{1}, prjData);
elseif status ~= 1
    error('Multiple projects with the label <%s> were found\n',project);
else
    projectID = projectID{1};
end

% We now have a project id


%% Test for the session label; does it exist on flywheel? If not create it

% If no session is passed, then we are done and return the project ID
if isempty(session), id = projectID; return; end

if isfield(additionalData, 'session'),     sesData = additionalData.session;
else,                                      sesData = struct;
end

[status, sessionID] = obj.exist(session, 'sessions', 'parentID', projectID);

if ~status
    sessionID = createPrivate(obj, 'sessions', session, 'project', projectID, sesData);
elseif status ~= 1
    error('Multiple sessions labeled <%s> were found\n',session)
else
    sessionID = sessionID{1};
end


%% Test for the acquisition label; does it exist on flywheel? If not create it

% If no acquisition is passed, then we are done and return the session ID
if isempty(acquisition), id = sessionID; return; end

[status, acquisitionID] = obj.exist(acquisition, 'acquisitions', 'parentID', sessionID);

if isfield(additionalData, 'acquisition'), acqData = additionalData.acquisition;
else,                                      acqData = struct;
end

if ~status
    % Doesn't exist.  Create it.
    id = createPrivate(obj, 'acquisitions', acquisition, 'session', sessionID, acqData);
elseif status ~= 1
    error('Multiple acquisitions labeled <%s> exist.',acquisition.source.id);
else
    % One exists.  That's good.  We are done.
    id = acquisitionID{1};
end

end

%% Creates a single container
function id = createPrivate(obj, containerType, label, ...
    parentType, parentID, additionalContent)
% This routine issues the command to create the container on Flywheel
% We are creating 

% The containerType can be
%
% Check this list with LMP
%
%     {'projects','sessions','acquisitions'} 
%
% What is in the payload?  It seems to be a struct that we convert into a
% JSON file.  What are the allowable fields in the payload?
%

payload.(parentType) = parentID;
payload.label = label;
additionalFields = fieldnames(additionalContent);

for ii = 1:length(additionalFields)
    payload.(additionalFields{ii}) = additionalContent.(additionalFields{ii});
end

% Turn it into json and then the curl command
payload = jsonwrite(payload,struct('indent','  ','replacementstyle','hex'));
cmd = obj.createCmd(containerType, payload);

% Execute the curl command
[status, result] = stCurlRun(cmd);
if status, error(result); end

% Returned OK.  Pass back the result
result = jsonread(result);

% Not sure this is correction with the new jsonio, but maybe.
id = result.x_id;

end
