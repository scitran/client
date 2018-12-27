function [objectType, searchType] = stObjectType(object)
% Estimate the type (class) of object 
%
%  [oType, sType] = stObjectType(object)
%
% Description
%   See the discussion in scitran.objectParse.  This function is used
%   there at a key step.
%
%   The object type (project, session, acquisition, file ... search)
%   is returned.  If the object type is a search, then a search type
%   (sType) is also returned (e.g., file, project, ...)
%
% Inputs:
%   object:  A Flywheel object, usually a container
%
% Optional key/value pairs
%   N/A
% 
% Returns
%   oType:  Object type (project, session, or returned by a search)
%   sType:  Search type (file, project, ...)
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

project = st.search('project','project label exact','VWFA')
[oType, sType] = stObjectType(project{1})

c = st.fw.getContainer(h.project.id);
[oType, sType] = stObjectType(c)

c = st.fw.getContainer(h.sessions{1}.id);
[oType, sType] = stObjectType(c)

c = st.fw.getContainer(h.acquisitions{2}{1}.id);
[oType, sType] = stObjectType(c)

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
        warning('How did we get a fileentry type?')
        objectType = 'file';
        
    case 'searchresponse'
        % We should be getting a return_type parameter some day, in which case
        % this can be replaced.
        objectType = 'search';
        searchType = object.returnType;
        
    % Probably never happens.  Depreciate, I think.    
    case 'searchsessionresponse'
        warning('searchsessionresponse is deprecated.  I think.');
        objectType = 'search';
        searchType = 'session';
    
    % fw.getContainer returns.  Somehow, JE didn't put a returnType in for
    % this case.  So, we figure it out from the class.
    case 'containerprojectoutput'
        % Returned by a fw.getContainer
        objectType = 'getcontainer';
        searchType = 'project';
    case 'containersessionoutput'
        objectType = 'getcontainer';
        searchType = 'session';
    case 'containeracquisitionoutput'
        objectType = 'getcontainer';
        searchType = 'acquisition';
    case 'containeranalysisoutput'
        objectType = 'getcontainer';
        searchType = 'analysis';
    case 'containercollectionoutput'
        % Not sure this exists.
        objectType = 'getcontainer';
        searchType = 'collection';
end

end