function setFileInfo(obj,file,metadata, varargin)
% Set the information field of a file
%
% Syntax
%  scitran.setFileInfo(file,metadata,varargin)
%
% Description
%   Information fields are attached to many Flywheel containers,
%   including projects, sessions, acquisitions, files and collections.
%   This method takes the data in metadata and sets it to be the
%   information fields of a file in one of these container types.
%
% Inputs
%   file - A file struct as returned from a search.  It must contain the
%          fields file.file.name and file.parent.x_id
%   metadata - A struct containing the metadata
%
% Optional parameter/val
%
% See also: s_stInfoCreate.m
%
% LMP/BW Vistalab 2017

% Example
%{
%}

%%

p = inputParser;
p.addRequired('file',@isstruct)
p.addRequired('metadata',@isstruct);

p.parse(file,metadata,varargin{:});

%% Perform the setInfo operation

fw  = obj.fw;
containerType = file.parent.type;
fname    = file.file.name;
parentID = file.parent.x_id;

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
