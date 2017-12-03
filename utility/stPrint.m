function stPrint(result,slot, field)
% Print the fields from a result to the command window
%
% Syntax
%  stPrint(containerStruct, slot, field)
%
% Description
%  Print out a list of the values in a cell array or a struct array.
%  Typically these are cell arrays returned from a search, or structs
%  returned from a list.  The slot refers to the first struct entry (e.g.,
%  session or subject) and the field refers to the second entry (e.g.,
%  label or code or ...).  Print out an object to see the possibilities.
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

  st = scitran('vistalab');

  % All project labels
  projects = st.search('project');
  stPrint(projects,'project','label');

  % Limited to make the example short.
  sessions = st.search('session',...
      'project id',idGet(projects{1}), ...
      'limit',10);
  stPrint(sessions,'session','label');

  stPrint(sessions,'subject','code');

  % List example, no slot 
  projects = st.list('project','wandell');
  stPrint(projects,'label','')

  % Print metadata
  project = st.search('project','project label exact','VWFA');
  id = idGet(p{1});
  info = st.getContainerInfo('project',id);

  sessions = st.list('session',id);   % Parent id
  stPrint(sessions,'subject','code')

%}

%% Parse
p = inputParser;
p.addRequired('result',@(x)(iscell(x) || isstruct(x)));
p.addRequired('slot',@ischar);
p.addRequired('field',@ischar);

p.parse(result,slot,field);

%%
if isempty(field)
    if iscell(result)
        % Typically from a search
        fprintf('\n %s %s\n-----------------------------\n',slot,field);
        for ii=1:length(result)
            fprintf('\t%d - %s \n',ii,result{ii}.(slot));
        end
        
    elseif isstruct(result)
        % Typically from a list
        for ii=1:length(result)
            fprintf('\t%d - %s \n',ii,result(ii).(slot));
        end
    end
else
    if iscell(result)
        % Typically from a search
        fprintf('\n %s %s\n-----------------------------\n',slot,field);
        for ii=1:length(result)
            fprintf('\t%d - %s \n',ii,result{ii}.(slot).(field));
        end
        
    elseif isstruct(result)
        % Typically from a list
        for ii=1:length(result)
            fprintf('\t%d - %s \n',ii,result(ii).(slot).(field));
        end
    end

end