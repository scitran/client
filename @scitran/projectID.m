function id = projectID(st,label)
% Return the id of a project with the specified label
%
% Wandell, Vistasoft 2018
%
% TODO:  We might try to figure out only the projects for this group?
%
% See also
%

% Examples:
%{
  st = scitran('stanfordlabs');
  label = 'SVIP Released Data (SIEMENS)';
  id = st.projectID(label);
%}

%% Parse

p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('label',@ischar);
p.parse(st,label)

%% Alternative code.
%{
% This is faster, but we would need to get the group (wandell) and the
% label (VWFA) sent in.  One thought is that the scitran class should always
% have the user's group attached to it (st.group).  At create time.
  tic
  tmp = st.fw.resolve('wandell/VWFA');
  id = tmp.path{2}.id
  toc
%}
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
elseif nFound == 0
    error('No project labeled %s found\n',label);
else
    error('More than one project found.\n');
end

end