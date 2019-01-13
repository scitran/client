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
%
% See also
%   scitran.fileDelete, scitran.fileDownload

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

%%
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
