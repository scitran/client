function [id, project] = projectID(st,label)
% Return the id of a project with the specified label
%
% Syntax:
%   [id, project] = scitran.projectID('project label'.varargin)
%
% Brief description:
%   Get the project id.  You can further get the project metadata
%
% Inputs:
%   label - The project label
%
% Optional key/value pairs
%   N/A
%
% Outputs
%   id:       The project id (ischar)
%   project:  The project metadata
%s
% Wandell, Vistasoft 2018
%
% See also
%   scitran.containerGet
%

% Examples:
%{
  st = scitran('stanfordlabs');
  label = 'SVIP Released Data (SIEMENS)';
  [id,project] = st.projectID(label);
%}

%% Parse

p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('label',@ischar);

project = [];

%% Get all the project labels

allProjects = st.fw.getAllProjects;

% Find the one that matches the label parameter
allLabels = cellfun(@(x)(x.label),allProjects,'UniformOutput',false);
lst = strcmp(allLabels,label);

% If we get one, return the project ID.  Otherwise, wonder about the
% meaning of life.
nFound = sum(lst);
if nFound == 1
    thisProject = allProjects(lst);
    id = thisProject{1}.id;
    if nargout == 2
        % The user asked for the container metadata
        project = st.containerGet(id);
    end
elseif nFound == 0
    error('No project labeled %s found\n',label);
else
    error('More than one project labeled %s found.\n',label);
end

end