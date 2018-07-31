function [containerType, containerID, fileContainerType, fileType] = ...
    stObjectParse(object,containerType, containerID)
% Returns information about an object  
%
% Syntax
%  [containerType, containerID, fileContainerType, fileType] = ...
%           stFileParse(object,[containerType],[containerID])
%
% Brief Description
% ...  Write me. ...
%   ...
%
%   This whole routine stinks.  Just trying to clean up the look of
%   the code at the front end of various other routines by hiding it
%   here.
%
% Inputs
%
% Optional key/value
%
% Returns
%
% Wandell, Vistasoft 2018
%

% Examples:
%{
h = st.projectHierarchy('Graphics assets');
[oType, id] = stObjectParse(h.project)
[oType, id] = stObjectParse(h.sessions{1})
[oType, id] = stObjectParse(h.acquisitions{1}{1})
[oType, id, cType, fType]= stObjectParse(h.acquisitions{1}{1}.files{1})
%}
%%
if notDefined('object'), error('Object required'); end
if notDefined('containerType'), containerType = ''; end
if notDefined('containerID'),   containerID = ''; end

fileContainerType = '';
fileType = '';

%%
if ischar(object)
    
    % User sent in a string.  So, this must be a file.  And the must
    % send the container type and id
    containerType = stParamFormat(containerType);  % Spaces, lower
    if ~isequal(containerType(1:4),'file')
        error('Char requires file container type.'); 
    end
    if isempty(containerID), error('container id required'); end

    % If containerType is fileX format, get the containerType from the
    % second half of the string
    if length(containerType) > 4
        fileContainerType = containerType(5:end);
    else
        % No fileX. We assume the user gave just the container file type
        fileContainerType = containerType;
    end
    % Did I mention this has to be a file?
    containerType     = 'file';

else
    % Either a list return or a search return. 
    
    % Figure out what type of object this is.
    [oType, sType] = stObjectType(object);
    
    % If it is a search, then ...
    if isequal(oType,'search')  && isequal(sType,'file') 
        % A file search object has a parent id included.
        containerType = 'file';
        % fname  = object.file.name;
        containerID       = object.parent.id;
        fileContainerType = object.parent.type;
        fileType          = object.file.type;
    elseif isequal(oType,'search')
        % Another type of search.  The id and type should be there.
        containerType = sType;
        containerID   = object.(sType).id;
    else   
        % It is a list , not a search 
        containerType = oType;
        containerID   = object.id;

        if isequal(oType, 'file')
            fileType = object.type;
            warning('File ids are not yet implemented by Flywheel');
        end
    end
end

end
