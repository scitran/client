function [project, sessions, acquisitions] = projectHierarchy(obj, field, value)
% Create a basic search for a project and return the project hierarchy
% including its sessions and acquisitions
%
% Input:
%   field: field on which the search is performed
%   value: value of the field used in the search
% Output:
%   project: the project retrieved by the search
%   sessions: all the sessions contained in the project
%   acquisitions: all the acquisitions contained in the project
% example:
%     
%   [project, sessions, acquisitions] = st.projectHierarchy('label', 'foo')
%
% this will return the project labeled 'foo', its sessions and its
% acquisitions.

%% WARNING WARNING WARNING 
% this is used in the eraseProject method.
% if you modify it be sure to test it throughly after.

% RF 2016
%% search the project
srch.path = 'projects';
srch.projects.match.(field) = value;
projects = obj.search(srch);
%% check that there is exactly one result returned
if length(projects) ~= 1
    error('more than 1 project matched the query')
end
project = projects{1};
projectID = project.id;
%% search the sessions
clear srch;
srch.path = 'sessions';
srch.projects.match.x0x5Fid = projectID;
sessions = obj.search(srch);
%% for each session search its acquisitions
acquisitions = cell(1,length(sessions));
for ii = 1:length(sessions)
    clear srch;
    srch.path = 'acquisitions';
    srch.sessions.match.x0x5Fid = sessions{ii}.id;
    acquisitions{ii} = obj.search(srch);
end

end