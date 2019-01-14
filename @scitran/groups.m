function group = groups(obj,varargin)
% Find the user's group
%
% Syntax:
%     group = scitran.groups
%
% Description
%   Returns a list of the user's groups.  If you just want the
%   properties of a particular group, use the 'label' option.
%
% Inputs
%   N/A
%
% Optional key/value pairs
%   'label' - string defining a particular group to return
%
% Outputs:
%   group:  Either a list of all the user's groups or a specific group
%           object matching 'label'
%
% BW, SCITRAN Team, 2018

%{
  allGroups = st.groups;
  stPrint(allGroups,'label')
%}
%{
  % Find a label this way
  allGroups = st.groups('list',true);
  g = st.groups('label',allGroups{1}.label,'list',true)
%}

%%
p = inputParser;

p.addParameter('label','',@ischar);     % Look for a particular group label
p.addParameter('list',false,@logical);  % List all the group labels

p.parse(varargin{:});

label = p.Results.label;
list  = p.Results.list;


%%  All of the groups the person belongs to

allGroups = obj.fw.getAllGroups;
if list
    stPrint(allGroups,'label')
end

if ~isempty(label)
    % Squeeze out spaces and force lower case on the match
    label = stParamFormat(label);
    for ii=1:length(allGroups)
        if strcmpi(label,stParamFormat(allGroups{ii}.label))
            group = allGroups{ii};
            return;
        end
    end
    warning('No matching group found %s\n',label);
    group = [];
else
    group = allGroups;
end

end

