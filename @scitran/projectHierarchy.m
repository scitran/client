function [project, sessions, acquisitions] = projectHierarchy(obj, field, value)
% PROJECTHIERARCH -  Returns the project hierarchy (sessions and
% acquisitions) 
%
%   scitran.projectHierarchy('label',...)
%
% Input:
%   field: Typically the project label ('label')
%   value: value of the field used in the search
%
% Output:
%   project: the project retrieved by the search
%   sessions: all the sessions contained in the project
%   acquisitions: all the acquisitions contained in the project
%
% Example:
%    
%   [project, sessions, acquisitions] = st.projectHierarchy('label', 'VWFA')
%
% this will return the project labeled 'foo', its sessions and its
% acquisitions.
%
% TODO:  This needs to parse the arguments.  To make cvhanges we need to
% understand the comment below from RF about eraseProject.

%% WARNING WARNING WARNING 
% this is used in the eraseProject method.
% if you modify it be sure to test it throughly after.

% RF 2016
%% search for a project 

% I think the match should be on the project label, nothing else.  The
% warning (BW) above, however, prevented me from changing it.
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