function [project, sessions, acquisitions] = projectHierarchy(obj, projectLabel, groupID)
% PROJECTHIERARCHY -  Returns the project hierarchy (sessions and
% acquisitions) 
%
%   scitran.projectHierarchy(projectLabel, groupID)
%
% Input:
%   projectLabel: the project label used in the search.  The
%                 search is for 'project label exact'
%   groupID:      group id because multiple groups may have the same
%                 project label.
%
% Output:
%   project:      the project retrieved by the search
%   sessions:     all the sessions contained in the project
%   acquisitions: all the acquisitions contained in the project
%
% Example:
%   
%   [project, sessions, acquisitions] = st.projectHierarchy('VWFA','wandell');
%
% this will return the project labeled 'foo', its sessions and its
% acquisitions.
%
%
% RF 2016, Scitran Team

%% search for a project 

p = inputParser;
p.addRequired('projectLabel',@ischar);
p.addRequired('groupID',@ischar);

p.parse(projectLabel,groupID);

%%
status = obj.exist(projectLabel,'projects','parentID',groupID); 
if ~status
    error('Project not found');
end

% Figure out why we can't get the projectID from 'exist' and use it here.
project = obj.search('projects','project label',projectLabel,'project group',groupID);

%% search the sessions
sessions = obj.search('sessions','project label',projectLabel);

%% for each session search its acquisitions
acquisitions = cell(1,length(sessions));
for ii = 1:length(sessions)
    acquisitions{ii} = obj.search('acquisitions',...
        'session id',sessions{ii}.id);
end

end
