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
% Optional parameters (not key/value)
%   containerType -  If a file name, then this is the file's container
%   container id  -  If a file name, this is the file's container id
%
% Returns
%   containerID       - ID of the container itself
%   containerType     - The container type of the object itself
%   fileContainerType - If file, its container type   (project, acq)
%   fname             - If a file, its name
%   fileType          - (Matlab data, source code ...)
%
% Wandell, Vistasoft 2018
%
% See also
%   stObjectType

% Examples:
%{
 st = scitran('stanfordlabs');
 project = st.lookup('wandell/Graphics assets');
 [id, oType] = st.objectParse(project)

 session = project.sessions.findFirst;
 [id, oType] = st.objectParse(session)

 acquisition = session.acquisitions.findFirst;
 [id, oType] = st.objectParse(acquisition)
 [id, oType, fileCType, fname, fType]= st.objectParse(acquisition.files{1})
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
    % I think this whole section should be deleted.  We should not allow
    % this type of object any more (fname, containerType, containerID)
    % We should only allow a fileEntry (BW).
    %
    % User sent in a string, so, the containerType must be a file.  
    % The user must might have sent in a container type and id.  Also, for
    % the case of a file  we expect a containerType like
    %     fileacquisition or filesession or ...
    % 
    % (At some point, file's will have an id and much of  this will go
    % away). 
    warning('String objectParse for a file');
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
        % acquisition and we search. We assume a file in an acquisition
        % because that is the most common.
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
    % Either a list return, a search return, or a get/getContainer return
    
    % Figure out which type of object this is.
    %
    %  oType is the object type, or search. 
    %  If oType is search, then sType is the object.returnType
    %
    [oType, sType] = stObjectType(object);
    
    % If it is a search, then ...
    if isequal(oType,'search')  && isequal(sType,'fileentry') 
        % A file search object has a parent id included.
        % In 4.4 this will be replaced because the file information
        % will be enough to let us download without the parent information. 
        containerType     = 'file';
        containerID       = object.parent.id;
        fileType          = object.file.type;
        fileContainerType = object.parent.type; % Container that contains the file

        fname  = object.file.name;

    elseif isequal(oType,'search')
        % Search for a container.  The id and type should be there.
        % The case of a file, however, is a little bit different.  In
        % that case we need to set the fileContainerType and the fileType
        containerType = object.returnType;
        switch containerType
            case 'file'
                fileContainerType = stObjectType(object.parent);
                fileType    = object.file.type;
                fname       = object.file.name;
                containerID = object.parent.id;
            otherwise
                containerID   = object.(containerType).id;
        end

        
    elseif isequal(oType,'getcontainer')
        % Returned by fw.getContainer(id)
        containerType = sType;
        containerID   = object.id;
        
    else   
        % A list return
 
        % This object
        containerType = oType;
        
        if isequal(oType, 'fileentry')
            % We no longer know the file container type, but that doesn't
            % matter because we have the file.download function, wherever
            % it is.
            %
            % And files do not yet have an id.
            %
            % warning('File "id" not yet implemented')
            fileContainerType = '';
            fileType = object.type;
            fname    = object.name;
            containerID = object.id;   % For files, this is bogus
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

