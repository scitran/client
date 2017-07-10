function [project, sessions, acquisitions] = projectHierarchy(obj, projectLabel)
% PROJECTHIERARCH -  Returns the project hierarchy (sessions and
% acquisitions) 
%
%   scitran.projectHierarchy(projectLabel)
%
% Input:
%   projectLabel: value of the project label used in the search.  The
%   search is for 'project label exact'
%
% Output:
%   project:      the project retrieved by the search
%   sessions:     all the sessions contained in the project
%   acquisitions: all the acquisitions contained in the project
%
% Example:
%   [project, sessions, acquisitions] = st.projectHierarchy('VWFA');
%   [project, sessions, acquisitions] = st.projectHierarchy('VWFA FOV');
%
% this will return the project labeled 'foo', its sessions and its
% acquisitions.
%
% RF 2016, Scitran Team

%% search for a project 

p = inputParser;
p.addRequired('projectLabel',@ischar);
p.parse(projectLabel);

%%
project = obj.search('projects','project label exact',projectLabel);

%% Check that there is exactly one project returned

if length(project) > 1
    error('More than one project with label %s returned',projectLabel)
elseif isempty(project)
    error('No project found with label %s\n',projectLabel);
end

% Good to go
projectID = project{1}.id;

% search the sessions
sessions = obj.search('sessions',...
    'project id',projectID);

%% for each session search its acquisitions
acquisitions = cell(1,length(sessions));
for ii = 1:length(sessions)
    acquisitions{ii} = obj.search('acquisitions',...
        'session id',sessions{ii}.id);
end

end
