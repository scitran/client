function val = stPrint(objects, slot1, slot2)
% Print and return the fields from a search or list result 
%
% Syntax
%  val = stPrint(objects, slot1, [slot2])
%
% Description
%  Print out a list of the values from a cell array of objects,
%  returned by a scitran.search or a scitran.list method.
%
%  The slot1 and field refers to the first and second struct entries.
%  So, what is printed is a loop over ii for
%
%     objects{ii}.slot1.slot2
%
% The specified slots must be consistent with the type of object. If the
% objects are returned by a list or a search, even though they are the same
% type of object, the slot names differ.
%
% Inputs:
%   result -  A cell array returned from the search or list method
%   slot1   - Main slot1
%   slot2  -  Field within the slot1
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
  id = st.objectParse(projects{1})
  sessions = st.search('session',...
      'project id',id, ...
      'limit',10);

  val = stPrint(sessions,'session','label');

  stPrint(sessions,'subject','code');
%}
%{
  % List example 
  projects = st.list('project','wandell');
  stPrint(projects,'label')

  % Print metadata
  project = st.search('project','project label exact','VWFA');
  info = st.infoGet(project{1});

  id = st.objectParse(project{1});
  sessions = st.list('session',id);   % Parent id
  stPrint(sessions,'subject','code');

  val = stPrint(sessions,'subject','code');
%}

%% Parse
if notDefined('objects'), error('objects are required'); end
if notDefined('slot1'),   error('Main slot is required'); end
if notDefined('slot2'),   slot2 = ''; end

% We will return the values as well as print them
val = cell(length(objects),1);

%% Start printing

fprintf('\nEntry: %s.%s\n-----------------------------\n',slot1,slot2);
        
if isempty(slot2)
    for ii=1:length(objects)
        val{ii} = objects{ii}.(slot1);
        fprintf('\t%d - %s \n',ii,val{ii} );
    end
else
    for ii=1:length(objects)
        if iscell(objects{ii}.(slot1))
            for jj=1:length(objects{ii}.(slot1))
                val{ii}{jj} = objects{ii}.(slot1){jj}.(slot2);
                fprintf('cell (%d), entry (%d) - %s \n',ii,jj,val{ii}{jj});
            end
        else
            val{ii} = objects{ii}.(slot1).(slot2);
            fprintf('\t%d - %s \n',ii,val{ii});
        end
    end

end
