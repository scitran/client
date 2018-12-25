function hierarchy = projectHierarchy(obj, projectLabel, varargin)
% Returns the hierarchy (project, sessions and acquisitions) in a struct
%
% Syntax
%   scitran.projectHierarchy(projectLabel)
%
% Description
%   A project includes sessions and and session includes acquisitions.
%   The information about the project hierarchy is returned to be stored in
%   a convenient place.  You can address the sessions or acquisitions from
%   this structure without multiple calls to search or list.
%
% Input:
%   projectLabel: value of the project label used in the search.  The
%                 search is for 'project label exact'
%
% Optional key/value
%   print - Print a list of the session and acquisition labels
%   limit - Only return the hierarchy for up to 'limit' number of sessions
%
% Output:
%   A struct is returned with these slots
%
%    h.project   -  flywheel.model.project (not a cell array)
%    h.sessions  -  N x 1 cell array of flywheel.model.Session
%    h.acquisition - N cell arrays, one for each session.
%                  Each cell array is length M for the number of
%                  acquisitions. 
%
% Example:
%   h = st.projectHierarchy('VWFA','print',true);
%   h = st.projectHierarchy('VWFA FOV');
%
% BW 2016, Scitran Team

% Example
%{
 % A listing for a pretty small project
 st = scitran('stanfordlabs');
 hierarchy = st.projectHierarchy('VWFA','print',true);
%}
%{
 % A bigger project
 hierarchy = st.projectHierarchy('VWFA FOV');
 nAcquisitions = 0;
 for ii=1:length(hierarchy.sessions)
    nAcquisitions = nAcquisitions + length(hierarchy.acquisitions{ii});
 end
%}

%% Read parameters

p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('projectLabel',@ischar);
p.addParameter('print',false,@islogical);
p.addParameter('projectid','',@ischar);
p.addParameter('limit',-1,@isnumeric);
p.addParameter('verbose',false,@islogical);

p.parse(projectLabel,varargin{:});

verbose = p.Results.verbose;

%% Find the project 

if verbose, fprintf('Reading %s project hierarchy ...',projectLabel); end

projectID = p.Results.projectid;

if isempty(projectID)
    project = obj.search('projects','project label exact',projectLabel);
    
    % Check that there is exactly one project returned
    if length(project) > 1
        error('More than one project with label %s returned',projectLabel)
    elseif isempty(project)
        error('No project found with label %s\n',projectLabel);
    end
    % projectID = idGet(project{1},'data type','project');
    projectID = obj.objectParse(project{1});
end

% Get the project object.
project   = obj.fw.getProject(projectID);
%% Get the project sessions

sessions = obj.fw.getProjectSessions(projectID);
nSessions = numel(sessions);
if nSessions < 1
    error('No sessions for project %s found',projectLabel);
end

% User can ask for a smaller number of sessions
limit = min(p.Results.limit,nSessions);
if limit > 0, sessions = sessions(1:limit); nSessions = limit; end

%% for each session search its acquisitions
acquisitions = cell(1,length(sessions));
nAcquisitions = 0;
for ii = 1:length(sessions)
    acquisitions{ii} = obj.fw.getSessionAcquisitions(sessions{ii}.id);
    nAcquisitions = nAcquisitions + length(acquisitions{ii});
end

hierarchy.project = project;
hierarchy.sessions = sessions;
hierarchy.acquisitions = acquisitions;

%% Print flag
if p.Results.print
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

if verbose, fprintf('done.\n'); end

end