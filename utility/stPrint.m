function val = stPrint(result, slot, field)
% Print and return the fields from a search or list result 
%
% Syntax
%  val = stPrint(containerStruct, slot, field)
%
% Description
%  Print out a list of the values in a cell array or a struct array.
%  Typically these are cell arrays returned from a search, or structs
%  returned from a list.  The slot refers to the first struct entry (e.g.,
%  session or subject) and the field refers to the second entry (e.g.,
%  label or code or ...).  
%
%  Print out a returned object to see the possibilities.
%
% Example
%   st = scitran('stanfordlabs');
%   projects = st.search('project');
%   stPrint(projects,'project','label');
%
% See more examples in the source code
%
% BW, Vistasoft Team, 2017

% Examples
%
% st = scitran('stanfordlabs');
%{
  % All project labels
  projects = st.search('project');
  val = stPrint(projects,'project','label');
%}
%{
  % Limited to make the example short.
  sessions = st.search('session',...
      'project id',idGet(projects{1}), ...
      'limit',10);
  val = stPrint(sessions,'session','label');

  stPrint(sessions,'subject','code');
%}
%{
  % List example, no slot 
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
p.addRequired('result',@(x)(iscell(x) || isstruct(x)));
p.addRequired('slot',@ischar);
p.addRequired('field',@ischar);

p.parse(result,slot,field);

% Return the values we print out
val = cell(length(result),1);

%%
if isempty(field)
    if iscell(result)
        % Typically from a search
        fprintf('\n %s %s\n-----------------------------\n',slot,field);
        for ii=1:length(result)
            val{ii} = result{ii}.(slot);
            fprintf('\t%d - %s \n',ii,val{ii} );
        end
        
    elseif isstruct(result)
        % Typically from a list
        for ii=1:length(result)
            val{ii} = result(ii).(slot);
            fprintf('\t%d - %s \n',ii,val{ii});
        end
    end
else
    if iscell(result)
        % Typically from a search
        fprintf('\n %s %s\n-----------------------------\n',slot,field);
        for ii=1:length(result)
            val{ii} = result{ii}.(slot).(field);
            fprintf('\t%d - %s \n',ii,val{ii});
        end
        
    elseif isstruct(result)
        % Typically from a list
        for ii=1:length(result)
            val{ii} = result(ii).(slot).(field);
            fprintf('\t%d - %s \n',ii, val{ii});
        end
    end

end