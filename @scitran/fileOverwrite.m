function status = fileOverwrite(st, filename, containerid, containertype)
% Overwrite (replace) a file in a container   
% 
%  status = scitran.fileOverwrite(st, filename, containerid, containertype)
%
% Required parameters
%   filename - local file name (string )
%   containerID   - From the container struct returned by a search
%   containerType - {'projects','sessions','acquisitions','collections'}
%
% Optional Key/value pairs
%   None.
%
%
% BW, Vistasoft Team, 2018

%%
p = inputParser;

% We should be able to deal with a cell array of FileEntry types.
% And maybe a cell array of filenames.
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('filename',@ischar);
p.addRequired('containertype',@ischar);
p.addRequired('containerid',@ischar);

% Parse
p.parse(st,filename,containertype,containerid);

%{
% Should we change to this format, where we make these parameters?

% Either a struct or a char string
vFunc = @(x)(isa(x,'flywheel.model.SearchResponse') || ...
             isa(x,'flywheel.model.FileEntry') || ...
             ischar(x));
p.addRequired('file',vFunc);

% Param/value pairs
p.addParameter('containertype','',@ischar); % If file is string, required
p.addParameter('containerid','',@ischar);   % If file is string, required

% Figure out what type of object this is.
[containerID, containerType, fileContainerType, fname] = ...
    st.objectParse(object,containerType,containerID);
%}

%%
%{
% This approach worked.  But I changed to the Flywheel way below.

switch containertype
    case 'acquisition'
        file = st.search('file',...
            'file name exact',filename,...
            'acquisition id',containerid);
        if ~isempty(file)
            st.fileDelete(filename,containertype,containerid);
        end
        status = st.fileUpload(filename,containertype,containerid);
    otherwise
        % Just lazy.  The switch would be on 'acquisition id' to other
        % container type id.
        disp('File overwrite only implemented for acquisition files.');
end
%}

switch containertype
    case 'project'
        status = st.fw.replaceProjectFile(containerid, filename);
    case 'session'
        status = st.fw.replaceSessionFile(containerid, filename);
    case 'acquisition'
        status = st.fw.replaceAcquisitionFile(containerid,filename);
    case 'collection'
        status = st.fw.replaceCollectionFile(containerid, filename);
    otherwise
        error('This container type not handled yet %s',containerTypes);
end

end
