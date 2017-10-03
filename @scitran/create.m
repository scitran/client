function id = create(obj, groupName, projectLabel, varargin)
% Create a project, session or acquisition on a flywheel instance
%
%   st.create(groupName, projectLabel,'session',sessionLabel,'acquisition',acquisitionLabel)
%
% This is analogous to mkdir, without any chdir
%
% Check if the acquisitionLabel is non-empty.  In that case, we are making
% an acquisition and we expect the session and project to exist.
%
% Check if the sessionLabel is non-empty.  In that case we are making a
% session, and we expect the project to exist.
%
% Otherwise, we are making a project entry.
%
% Required Inputs
%  groupName      - group name
%  projectLabel   - project label
%
% Input parameter/values
%  'sessionLabel'        - session label
%  'acquisitionLabel'    - acquisition label
%  'additionalData'      - Struct of additional data is unclear to me ????.
%                          There is an example in desFMRI/uploadDES.m
%
% Returns:
%   ID of the created object
%
% Examples:
%
%  Create a project
%    groupName = 'wandell'; projectLabel = 'DeleteMe';
%    idP = st.create(groupName, groupName);
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
p.addRequired('groupName',@ischar);
p.addRequired('projectLabel',@ischar);
p.addParameter('sessionLabel',[],@ischar);
p.addParameter('acquisitionLabel',[],@ischar);
p.addParameter('additionalData', struct, @isstruct);

p.parse(groupName,projectLabel,varargin{:});

groupName        = p.Results.groupName;
projectLabel     = p.Results.projectLabel;   % All labels
sessionLabel     = p.Results.sessionLabel;
acquisitionLabel = p.Results.acquisitionLabel;
additionalData   = p.Results.additionalData;

% Make sure the group exists
[status, groupID] = obj.exist(groupName, 'groups');
if isempty(status), error('No group with name %s was found\n',groupName); end

%% Test for the acquisition label

% If no acquisitionLabel is passed, then we move up to sessionLabel 
if ~isempty(acquisitionLabel)
    % The session and project must exist.
    
    % We create the acquisition, but first check whether it exists.
    thisSession = obj.search('sessions',...
        'project label',projectLabel,...
        'sessionLabel',sessionLabel);
    
    sessionID = thisSession{1}.id;
    [status, acquisitionID] = obj.exist(acquisitionLabel, 'acquisitions', ...
        'parentID', sessionID);
        
    if isfield(additionalData, 'acquisition'), acqData = additionalData.acquisition;
    else,                                      acqData = struct;
    end
    
    if ~status
        % Doesn't exist.  Create it.
        id = createPrivate(obj, 'acquisitions', acquisitionLabel, 'session', sessionID, acqData);
        return;
    else
        error('Acquisition with id %s labeled <%s> exists.',acquisitionID,acquisitionLabel);
    end
    
elseif ~isempty(sessionLabel) 
    % Acquisition is empty. We assume the project exists and create the
    % session 
    % We create the acquisition, but first check whether it exists.
    
    % Add the groupName here!
    thisProject = obj.search('projects',...
        'project label',projectLabel);
    
    projectID = thisProject{1}.id;
    [status, sessionID] = obj.exist(sessionLabel, 'sessions', ...
        'parentID', projectID);
    
    if isfield(additionalData, 'session'),     sesData = additionalData.session;
    else,                                      sesData = struct;
    end
    
    if ~status
        % Doesn't exist.  Create it.
        id = createPrivate(obj, 'sessions', sessionLabel, 'project', projectID, sesData);
        return;
    else
        error('Session with id %s labeled <%s> exists.',sessionID,sessionLabel);
    end
    
else
    % Empty acquisition and session.  
    % Create the project
    
    if isfield(additionalData, 'project'),  prjData = additionalData.project;
    else,                                   prjData = struct;
    end
    
    % If the project does not exist, we check with the user and then create it.
    [status, projectID] =  obj.exist(projectLabel, 'projects', 'parentID', groupID{1});
    
    % If it does not exist, we check with the user and then create it.
    if ~status
        id = createPrivate(obj, 'projects', projectLabel, 'group', groupID{1}, prjData);
    else
        error('Project id %s labeled <%s> exists.',projectID,projectLabel);
    end
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
