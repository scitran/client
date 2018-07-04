function val = stPrint(result, slot, field)
% Print and return the fields from a search or list result 
%
% Syntax
%  val = stPrint(result, slot, field)
%
% Description
%  Print out a list of the values from a cell array that is returned by a
%  scitran.search or a scitran.list method.
%
%  The slot and field refers to the first and second struct entries.
%  So, what is printed is a loop over ii for
%
%     result{ii}.slot.field
%
% Inputs:
%   result -  A cell array returned from the search or list method
%   slot   -  Main slot
%   field  -  Field within the slot
%
% Optional Key/vals
%   None
%
% Return
%   val - The printed strings
%
% HINT:  Print out one of the returned objects to see the
%        possibilities for that object. 
%
% Example
%   st = scitran('stanfordlabs');
%   projects = st.search('project');
%   stPrint(projects,'project','label');
%
% See examples in the source code
%
% BW, Vistasoft Team, 2017

% Examples:
%
% st = scitran('stanfordlabs');
%{
  % All project labels
  projects = st.search('project');
  val = stPrint(projects,'project','label');
%}
%{
  % Limited to make the example short.
  projects = st.search('project');
  sessions = st.search('session',...
      'project id',idGet(projects{1}), ...
      'limit',10);

  val = stPrint(sessions,'session','label');

  stPrint(sessions,'subject','code');
%}
%{
  % List example, no slot 
  % Notice the unfortunate difference in the returned object and thus
  % the stPrint arguments 
  projects = st.list('project','wandell');
  stPrint(projects,'label','')

  % Print metadata
  project = st.search('project','project label exact','VWFA');
  id = idGet(project{1});
  info = st.getContainerInfo('project',id);

  sessions = st.list('session',id);   % Parent id
  stPrint(sessions,'subject','code')
%}

%% Parse
p = inputParser;
p.addRequired('result',@iscell);
p.addRequired('slot',  @ischar);
p.addRequired('field', @ischar);

p.parse(result,slot,field);

% Return the values we print out
val = cell(length(result),1);

%% Start printing

fprintf('\n %s %s\n-----------------------------\n',slot,field);
        
if isempty(field)
    for ii=1:length(result)
        val{ii} = result{ii}.(slot);
        fprintf('\t%d - %s \n',ii,val{ii} );
    end
else
    for ii=1:length(result)
        val{ii} = result{ii}.(slot).(field);
        fprintf('\t%d - %s \n',ii,val{ii});
    end
end
        
end

