function fileInfoSet(obj,file,metadata, varargin)
% Set the information field of a file
%
% Syntax
%  scitran.fileInfoSet(file,metadata,varargin)
%
% Description
%   Information fields are attached to many Flywheel containers,
%   including projects, sessions, acquisitions, files and collections.
%   This method takes the data in metadata, which is a struct, and
%   sets it to be the information fields of a file in one of these
%   container types.
%
% Inputs (required)
%   file - A file struct as returned from a search.  It must contain the
%          fields file.file.name and file.parent.x_id
%   metadata - A struct containing the metadata
%
% Inputs (optional)
%
% LMP/BW Vistalab 2017
%
% See also: s_stInfoCreate.m

% Example
%{
See scitran/client wiki page
%}

%%

p = inputParser;
p.addRequired('file',@(x)(isa(x,'flywheel.model.SearchResponse')));
p.addRequired('metadata',@isstruct);

p.parse(file,metadata,varargin{:});

%% Perform the setInfo operation

fw  = obj.fw;

if isa(file,'flywheel.model.SearchResponse')
    containerType = file.parent.type;
    fname    = file.file.name;
    parentID = file.parent.id;
else
    error('Only managing search responses, not lists, for now.  Will update');
end

% We should understand when we want to use modify, set and replace.  I
% didn't understand Justin's response last time. (BW).
switch (containerType)
    case 'project'
        fw.setProjectFileInfo(parentID,fname,metadata);
    case 'session'
        fw.setSessionFileInfo(parentID,fname,metadata);        
    case 'acquisition'
        fw.setAcquisitionFileInfo(parentID,fname,metadata);
    case 'collecton'
        fw.setCollectionFileInfo(parentID,fname,metadata);
    otherwise
        error('Unknown container type %s\n',containerType);
end

end
