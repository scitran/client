function [containerID, containerType, fileContainerType, fname, fileType] = ...
    objectParse(~, object,containerType, containerID)
% Determine properties of a Flywheel SDK object.
%
% Syntax
%  [containerID, containerType, fileContainerType, fname, fileType] = ...
%           st.objectParse(object,containerType, containerID)
%
% Brief Description
%   The Flywheel SDK provides information about objects in two main
%   formats: a return from a search or a return from a list. Either way, we
%   may want to know the object properties such as the container type and
%   id.
%
%   In addition, sometimes we want information from a file name and
%   its container and container id, such as the file type and the
%   file's container.
%   
%   This routine takes object information and does its best to return
%   critical information. We use this routine at the front end of
%   various methods.
%
%   At some point in the next few months, this routine will be simplified
%   by using a new Flywheel SDK method based on the 'resolve' concept. The
%   proposal is that all objects and files will have an id, and Flywheel
%   will use the id to learn the object type and name or label.
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
[id, oType] = st.objectParse(h.project)
[id, oType] = st.objectParse(h.sessions{1})
[id, oType] = st.objectParse(h.acquisitions{2}{1})

acquisition = st.search('acquisition',...
    'project label exact','Graphics assets', ...
    'acquisition id',id); 

% oType = The object type       (search, project, ...)
% id  - the object id           (string)
% fileCType - If file, its container type   (project, acq)
% The file name
% The file type                             (Matlab data, source code ...)
[id, oType, fileCType, fname, fType]= st.objectParse(h.acquisitions{2}{1}.files{1})
%}

%%
if notDefined('object'), error('Object required'); end
if notDefined('containerType'), containerType = ''; end
if notDefined('containerID'),   containerID = ''; end

% Default returns
fileContainerType = '';
fname = '';
fileType = '';

%%
if ischar(object)
    % User sent in a string, so, the containerTYpe must be a file.  
    % The user must might have sent in a container type and id.  Also, for
    % the case of a file  we expect a containerType like
    %     fileacquisition or filesession or ...
    % 
    % (At some point, file's will have an id and much of  this will go
    % away). 
    if isempty(containerID)
        error('A string "object" means a file and requires the id of it''s container.'); 
    end
    
    fname = object;
    containerType = stParamFormat(containerType);  % Spaces, lower

    % Otherwise, the container type can be in one of two formats:
    % filecontainerType or just containerType.  If filecontainerType
    % format, get the containerType from the second half of the string.
    if isempty(containerType)
        % If there is no containerType, we assume this is a data file in an
        % acquisition and we search. 
        % We assume a file in an acquisition because that is the most
        % common.
        srch = st.search('file','file name exact',fname, ...
            'acquisition id',containerID);
        fileType = srch{1}.file.type;
        fileContainerType = 'acquisition';
    elseif strncmp(containerType,'file',4)
        % The user told us.  Hurray.
        fileContainerType = containerType(5:end);
    else
        % We assume the user correctly passed the file's container type and
        % forgot to put it in the format filecontainerType
        fileContainerType = containerType;
    end
    
    % This object itself is a file.  So, its container type "file".
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
            % warning('File "id" not yet implemented; file container defaults to "acquisition"');
            fileContainerType = 'acquisition';
            fileType = object.type;
            fname = object.name;
        else
            % Not a file.  So, we use the object ID.
            containerID   = object.id;
        end
    end
end

if isempty(fileType)
    % Try to determine the file type from the extension
    [~,~,ext] = fileparts(fname);
    switch ext
        case '.mat'
            fileType = 'MATLAB data';
    end
end

end

