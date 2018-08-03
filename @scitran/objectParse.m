function [containerType, containerID, fileContainerType, fname, fileType] = ...
    objectParse(~, object,containerType, containerID)
% Determine properties of a Flywheel SDK object.
%
% Syntax
%  [fname, containerType, containerID, fileType] = ...
%           st.objectParse(object,containerType, containerID)
%
% Brief Description
%   The Flywheel SDK provides information about objects in two main
%   formats: a return from a search or as a return from a list. Either
%   way, we often want to know properties such as the container type
%   and the container id.  
%
%   In addition, sometimes we want information from a file name and
%   its container and container id, such as the file type and the
%   file's container.
%   
%   This routine takes object information and does its best to return
%   critical information. We use this routine at the front end of
%   various methods.  
%
%   Hopefully, this routine will be replaced by a proper Flywheel SDK
%   routine based on the 'resolve' concept. For example, if we have an
%   object id we should be able to learn its type.
%
% Inputs
%   object:  A Flywheel list or search return, or a file name (char)
%
% Optional
%   containerType -  If a file name, then this is the file's container
%   container id  -  If a file name, this is the file's container id
%
% Returns
%   containerType
%   containerID
%   fileContainerType
%   fileType
%
% Wandell, Vistasoft 2018
%
% See also

% Examples:
%{
st = scitran('stanfordlabs');
h = st.projectHierarchy('Graphics assets');
[oType, id] = st.objectParse(h.project)
[oType, id] = st.objectParse(h.sessions{1})
[oType, id] = st.objectParse(h.acquisitions{2}{1})

acquisition = st.search('acquisition',...
    'project label exact','Graphics assets', ...
    'acquisition id',id); 

% oType = The object type       (search, project, ...)
% id  - the object id           (string)
% fileCType - If file, its container type   (project, acq)
% The file name
% The file type                             (Matlab data, source code ...)
[oType, id, fileCType, fname, fType]= st.objectParse(h.acquisitions{2}{1}.files{1})
%}

%%
if notDefined('object'), error('Object required'); end
if notDefined('containerType'), containerType = ''; end
if notDefined('containerID'),   containerID = ''; end

% Default returns
fileContainerType = '';
fname = '';

%%
if ischar(object)
    % User sent in a string, so, this must be a file.  
    % The user must also send the container type and id.  At some
    % point, files will become a genuine object.s
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
    
    % Figure out which type of object this is.  oType is the object
    % type itself, or search. If search, then sType is the type of
    % search.  At present, the sType estimate is not always accurate.
    % We hope that Justin will make it better.
    [oType, sType] = stObjectType(object);
    
    % If it is a search, then ...
    if isequal(oType,'search')  && isequal(sType,'file') 
        % A file search object has a parent id included.
        containerType     = 'file';
        containerID       = object.parent.id;
        fileType          = object.file.type;
        fileContainerType = object.parent.type; % Container that contains the file

        fname  = object.file.name;

    elseif isequal(oType,'search')
        % Search for a container.  The id and type should be there.
        containerType = sType;
        containerID   = object.(sType).id;
        
    else   
        % A list return
 
        % This object
        containerType = oType;
        
        if isequal(oType, 'file')
            % For a file, the containerID and containerType both refer
            % to the parent of the file.  We are defaulting to
            % acquisition until we can do better.
            warning('File "id" not yet implemented; file container defaults to "acquisition"');
            fileContainerType = 'acquisition';
            fileType = object.type;
            fname = object.name;
        else
            % Not a file.  So, we use the object ID.
            containerID   = object.id;
        end
    end
end

end

