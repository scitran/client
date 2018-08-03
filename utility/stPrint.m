function [val, oType] = stPrint(objects, slot1, slot2)
% Print and return the fields from a search or list result 
%
% Syntax
%  [val, oType] = stPrint(objects, slot1, [slot2])
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
  [~,id] = st.objectParse(projects{1})
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

  [~,id] = st.objectParse(project{1});
  sessions = st.list('session',id);   % Parent id
  stPrint(sessions,'subject','code');

  [val, oType] =   stPrint(sessions,'subject','code');

%}

%% Parse
if notDefined('objects'), error('objects are required'); end
if notDefined('slot1'), error('Main slot is required'); end
if notDefined('slot2'), slot2 = ''; end

% Return the values we print out
val = cell(length(objects),1);

%% Start printing

fprintf('\n %s %s\n-----------------------------\n',slot1,slot2);
        
if isempty(slot2)
    for ii=1:length(objects)
        val{ii} = objects{ii}.(slot1);
        fprintf('\t%d - %s \n',ii,val{ii} );
    end
else
    for ii=1:length(objects)
        val{ii} = objects{ii}.(slot1).(slot2);
        fprintf('\t%d - %s \n',ii,val{ii});
    end
end

% Not sure this is a good idea.  Means we have to update
% stObjectParse.
if nargout > 1
    oType = stObjectParse(objects{1});
end

