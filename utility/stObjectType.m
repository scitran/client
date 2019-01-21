function [objectType, searchType] = stObjectType(object)
% Return the object type and the search type
%
%  [oType, sType] = stObjectType(object)
%
% Description
%   See the discussion in scitran.objectParse.  This function is used
%   there at a key step.  BUT, these functions may become unnecessary.
%   Just not sure yet.
%
%   The object type (project, session, acquisition, fileentry ... search)
%   is returned.  If the object type is a search, then a search type
%   (sType) is also returned (e.g., file, project, ...)
%
% Inputs:
%   object:  A Flywheel object, usually a container and sometimes a file.
%
% Optional key/value pairs
%   N/A
% 
% Returns
%   oType:  Object type (project, session, ... or a search)
%   sType:  Search type (the returnType on the searchResponse)
%
% Wandell, Vistasoft Team, 2018
%
% See also
%   scitran.objectParse
%

% Examples
%{
h = st.projectHierarchy('Graphics assets');
stObjectType(h.project)
stObjectType(h.sessions{1})
stObjectType(h.acquisitions{2}{1})
stObjectType(h.acquisitions{2}{1}.files{1})
%}
%{
project = st.search('project','project label exact','VWFA')
[oType, sType] = stObjectType(project{1})
%}
%{
project = st.search('project',...
        'project label exact','VWFA',...
        'fw',true);
[oType, sType] = stObjectType(project{1})
%}
%{
p = st.lookup('wandell/Graphics assets'); oType = stObjectType(p)
s = p.sessions.findFirst; oType = stObjectType(s)
a = s.acquisitions.findFirst; oType = stObjectType(a)
%}

%%  The Flywheel classes are flywheel.model.XXX

% Find the text after the last period.  That tells us the type of
% object this is in the flywheel.model world.
tmp = split(lower(class(object)),'.');
objectType = tmp{end};
searchType = '';

% Simplify these cases.
switch objectType
    case 'fileentry'
        objectType = 'fileentry';
        
    case 'searchresponse'
        % We should be getting a return_type parameter some day, in which case
        % this can be replaced.
        objectType = 'search';
        searchType = object.returnType;
        
      %{
        % Probably never happens.  Deprecate, I think.    
    case 'searchsessionresponse'
        warning('searchsessionresponse is deprecated.  I think.');
        objectType = 'search';
        searchType = 'session';
      %}
        
    % fw.get or fw.getContainer returns
    otherwise
        objectType = object.containerType;
        
end

end