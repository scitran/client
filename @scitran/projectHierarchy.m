function [project, sessions, acquisitions] = projectHierarchy(obj, projectLabel, varargin)
% PROJECTHIERARCHY -  Returns the project hierarchy (sessions and
% acquisitions) 
%
%   scitran.projectHierarchy(projectLabel)
%
% Input:
%   projectLabel: value of the project label used in the search.  The
%                 search is for 'project label exact'
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

% Example
%{
 st = scitran('vistalab');
 [p,s,a]= st.projectHierarchy('VWFA','print',true);
%}

%% Read parameters

p = inputParser;
p.addRequired('projectLabel',@ischar);
p.addParameter('print',false,@islogical);

p.parse(projectLabel,varargin{:});

%% Find the project 
project = obj.search('projects','project label exact',projectLabel);

% Check that there is exactly one project returned
if length(project) > 1
    error('More than one project with label %s returned',projectLabel)
elseif isempty(project)
    error('No project found with label %s\n',projectLabel);
end

% Good to go
projectID = project{1}.project.x_id;
projectLabel = project{1}.project.label;

%% Get the project sessions

sessions = obj.fw.getProjectSessions(projectID);
% sessions = obj.search('sessions','project id',projectID);
if length(sessions) < 1
    error('No sessions for project %s found',projectLabel);
end

%% for each session search its acquisitions
acquisitions = cell(1,length(sessions));
for ii = 1:length(sessions)
    acquisitions{ii} = obj.fw.getSessionAcquisitions(sessions{ii}.id); 
end

%% Print flag
if p.Results.print
    nSessions = numel(sessions);
    nAcquisitions = numel(acquisitions);
    fprintf('\n--------\n');
    fprintf('Project: %s (%d sessions and %d acquisitions)', ...
        projectLabel,nSessions,nAcquisitions);
    fprintf('\n--------\n');
    for ss=1:length(sessions)
        fprintf('\t%s\n',sessions{ss}.label);
        for aa=1:length(acquisitions{ss})
            fprintf('\t\t%s\n',acquisitions{ss}{aa}.label);
        end
    end
end
