function id = create(obj,project, varargin)
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
%    idP = st.create(pLabel);
%
% Create a session within a project
%    idS = st.create(pLabel,'session',sLabel);
%
% Create an acquisition within a session within a project
%    idA = st.create(pLabel,'session',sLabel,'acquisition',aLabel);
%
% When you create an acquisition, you can use the returned idA to put a
% file, as in
%
%     st.put('file',filename,'id',idA);
%
% For example, we add an acquisition to the Logothetis_DES
% 
% There is a test session.  That's where we create the acquisition
%   srch.path = 'sessions';
%   srch.projects.match.label = 'Logothetis';
%   srch.sessions.match.label = 'Test';
%   sessions = st.search(srch);
%   if length(sessions) ~= 1
%     disp('Too hot or too cold')
%   end
%
% Note: The endpoint will not over-write existing data (until someday we
% write a 'force' option).
%
% RF/BW Scitran Team, 2016

%% Input arguments are the project/session/acquisition labels

p = inputParser;
p.addRequired('group',@ischar);
p.addRequired('project',@ischar);
p.addParameter('session',[],@ischar);
p.addParameter('acquisition',[],@ischar);

p.parse(group,project,varargin{:});

group     = p.Results.group;
project     = p.Results.project;
session     = p.Results.session;
acquisition = p.Results.acquisition;

% Returned value is only empty on an error
id = [];

%% Check whether the project exists

% If it does not exist, we check with the user and then create it.
[status, projectID] = st.exist(project);

if ~status
    cmd = st.createCmd(project);
    [status, result] = stCurlRun(cmd);
end

% We now have a project id

%% Test for the session label; does it exist on flywheel?

% If no session is passed, then we are done and return the project ID
if isempty(session), id = projectID; return; end

if ~stExist(project,'session',session)
    % If not, create it
    
end

%% Test for the acquisition label; does it exist on flywheel

% This is an example call for an acquisition
%
%   st.create('Logothetis','session','folderName','acquisition','FMRI');
% or
%   st.create('Logothetis','session','folderName','acquisition','Anatomical');

% In this case, return the session ID
if isempty(acquisition), return; end

if ~stExist(project,'session',session,'acquisition',acquisition)
    % If not, create it
    
    % In this case, return the acquisition id
    % We build the curl command for creating an acquisition in a session
    make.label = 'FMRI';
    make.session = sessions{1}.id;
    jsonData = savejson('',make);
    
    cmd = sprintf('curl -s -XPOST "%s/api/acquisitions" -H "Authorization":"%s" -k -d ''%s'' ',...
        obj.url, obj.token, jsonData);
    
    [status, result] = stCurlRun(cmd);

end
    

end

%% A method for building the curl command







%%