function [gears, gNames] = gears(st,varargin)
% Find the gears, or the gear that matches a name
%
% Syntax:
%     gears = scitran.gears
%
% Description
%   Returns a list of the gears.  If you just want the
%   properties of a particular group, use the 'label' option.
%
% Inputs
%   N/A
%
% Optional key/value pairs
%   'name' - string defining a particular group to return
%   'list' - print out a list of the gear names
%
% Outputs:
%   group:  Either a list of all the user's groups or a specific group
%           object matching 'label'
%
% BW, SCITRAN Team, 2018

%{
  [allGears, gearNames] = st.gears;
%}
%{
  % Find a gear with a particular name this way
  [allGears, gNames] = st.gears('list',false);

  % Print out the list, but return only the one gear
  g = st.gears('name',gNames{1},'list',true)
%}

%%
p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('st',@(x)isa(x,'scitran'));
p.addParameter('name','',@ischar);   % Look for a particular gear name
p.addParameter('list',false);        % List all the gear labels

p.parse(st,varargin{:});

name = p.Results.name;
list = logical(p.Results.list);

gNames = '';

%%  All of the groups the person belongs to

allGears = st.fw.gears.find;
if list || nargout == 2
    gears = cellfun(@(x)(x.gear),allGears,'UniformOutput',false);
    if list
        gNames = stPrint(gears,'name');
    else
        gNames = stCarraySlot(gears,'name');
    end
    
end

if ~isempty(name)
    % Squeeze out spaces and force lower case on the match
    name = stParamFormat(name);
    for ii=1:length(allGears)
        if strcmpi(name,stParamFormat(allGears{ii}.gear.name))
            gears = allGears{ii};
            return;
        end
    end
    warning('No matching group found %s\n',name);
    gears = [];
else
    gears = allGears;
end

end

