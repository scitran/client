function id = create(obj,varargin)
% Create a project, session or acquisition on a flywheel instance
%
%  st.create('project,project,'session',session,'acquisition',acquisition)
%
% We use this to build a project, session or acquisition in a Flywheel
% instance. 
%  
% Inputs
%  object-name pairs
%
% Returns:
%   ID of the created object
%
% Examples:
%
% Create a project
%
%    idP = st.create('project',pName);
%
% Create a session within a project
%
%    idS = st.create('project',pName,'session',sName);
%
% Create an acquisition within a session within a project
%
%    idA = st.create('project',pName,'session',sName,'acquisition',aName);
%
% The returned id is for the acquisition in this case.  When it is an
% acquisition, you can use the returned idA to put a file
%
%     st.put('file',filename,'id',idA);
%
% The endpoint will not over-write existing data (until someday we write a
% 'force' option).  
%
%
% RF/BW Scitran Team, 2016

%% Input arguments
p = inputParser;


id = [];


%%  To get started we will add an acquisition to the Logothetis_DES

% There is a test session.  That's where we create the acquisition
srch.path = 'sessions';
srch.projects.match.label = 'Logothetis';
srch.sessions.match.label = 'Test';
sessions = st.search(srch);
if length(sessions) ~= 1
    disp('Too hot or too cold')
end

%% We build the curl command for creating an acquisition in that session

make.label = 'FMRI';
make.session = sessions{1}.id;
jsonData = savejson('',make);

cmd = sprintf('curl -s -XPOST "%s/api/acquisitions" -H "Authorization":"%s" -k -d ''%s'' ',...
    obj.url, obj.token, jsonData);

[status, result] = stCurlRun(cmd);









%%