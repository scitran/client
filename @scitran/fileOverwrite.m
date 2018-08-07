function status = fileOverwrite(st, filename, containertype, containerid)
% Overwrite a file in an acquisition container   
% 
%  status = scitran.fileOverwrite(obj, file, containerid, containertype)
%
% Required parameter
%  file - string or flywheel.model.FileEntry
%    if a string, we need the containerID and type, see below.
%
% Optional parameters for string ** ONLY FOR ACQUISITION FILES AT THIS TIME
%   containerType - {'projects','sessions','acquisitions','collections'}
%   containerID   - From the container struct returned by a search
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

%%
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

end
