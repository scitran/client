function [oType, sType] = stObjectType(object)
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
% Wandell, Vistasoft Team, 2018
%
% See also
%   scitran.objectParse
%

%{
h = st.projectHierarchy('Graphics assets');
stObjectType(h.project)
stObjectType(h.sessions{1})
stObjectType(h.acquisitions{2}{1})
stObjectType(h.acquisitions{2}{1}.files{1})

project = st.search('project','project label exact','VWFA')
[oType, sType] = stObjectType(project{1})

%}

%%  The Flywheel classes are flywheel.model.XXX

% Find the text after the last period.  That tells us the type of
% object this is in the flywheel.model world.
tmp = split(lower(class(object)),'.');
oType = tmp{end};
sType = '';

% Simplify these cases.
switch oType
    case 'fileentry'
        oType = 'file';
        return;
    case 'searchresponse'
        % We should be getting a return_type parameter some day, in which case
        % this can be replaced.
        oType = 'search';
        if ~isempty(object.file)
            sType = 'file';
        elseif isempty(object.project)
            sType = 'group';
        elseif isempty(object.session)
            sType = 'project';
        elseif isempty(object.acquisition)
            sType = 'session';
        elseif isempty(object.file)
            sType = 'acquisition';
        else
            warning('Uncertain search classification');
            disp(object)
        end
    case 'searchsessionresponse'
        oType = 'search';
        sType = 'session';
end

end