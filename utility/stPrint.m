function stPrint(result,slot, field)
% Print the fields from a result to the command window
%
% Syntax 
%  stPrint(containerStruct, slot, field)
%
% Description
%  Print out a list of the values in a cell array, typically returned from
%  a search, of the structs defining an object.  The slot refers to the
%  first struct entry (e.g., session or subject) and the field refers to
%  the second entry (e.g., label or code or ...).  Print out an object to
%  see the possibilities.  
%
% Example
%   st = scitran('vistalab');
%   projects = st.search('project');
%   stPrint(projects,'project','label');
%   
% See more examples in the source code
%
% BW, Vistasoft Team, 2017

% Example
%{

  % All project labels
  st = scitran('vistalab');
  projects = st.search('project');
  stPrint(projects,'project','label');

  % Limited to make the example short.
  sessions = st.search('session',...
      'project id',idGet(projects{1}), ...
      'limit',10);
  stPrint(sessions,'session','label');

  stPrint(sessions,'subject','code');

%}

%% Parse
p = inputParser;
p.addRequired('result',@iscell);
p.addRequired('slot',@ischar);
p.addRequired('field',@ischar);
p.parse(result,slot,field);

fprintf('\n %s %s\n-----------------------------\n',slot,field);
for ii=1:length(result)
    fprintf('\t%d - %s \n',ii,result{ii}.(slot).(field)); 
end

end