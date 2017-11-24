function destination = downloadFile(obj,file,varargin)
% Retrieve a file from a Flywheel site
%
%   outfile = scitran.downloadFile(file,'destination',filename,'size',size)
%
% We use the iFlywheel SDK to download a file.  This routine differs from
% the other Flywheel download methods because files do not have an id.
% They have a parent and a filename, which we use to get them.
%
% Required Inputs
%  file - Struct defining the file. The struct must contain these fields
%           file.parent.type
%           file.parent.x_id
%           file.file.name
%         The struct returned by a search has this information.
%
% Optional Inputs
%  destination:  full path to file output location (default is a tempdir)
%  size:         File size in bytes; used for checking
%
% Return
%  destination:  Full path to the file saved on disk
%
% See also: scitran.search, scitran.deleteFile
%
% LMP/BW Vistasoft Team, 2015-16

% Examples
%{
  st = scitran('vistalab');
  file = st.search('file','project label contains','SOC','filename','toolboxes.json');
  fName = st.downloadFile(file{1});  
  edit(fName)
  delete(fName);
%}

%% Parse inputs
p = inputParser;

vFunc = @(x)(isstruct(x));
p.addRequired('file',vFunc);

% Param/value pairs
p.addParameter('destination','',@ischar)
p.addParameter('size',[],@isnumeric);

p.parse(file,varargin{:});

file        = p.Results.file;
destination = p.Results.destination;
size        = p.Results.size;

%% Set up the Flywheel SDK call

% Get the Flywheel commands
fw = obj.fw;

% Set up the download variables
parentType = file.parent.type;
parentID   = file.parent.x_id;
filename   = file.file.name;
if isempty(destination)
    destination = fullfile(pwd,filename);
end

% Call the Flywheel SDK download method
switch lower(parentType)
    case 'acquisition'
        fw.downloadFileFromAcquisition(parentID,filename,destination);
    case 'project'
        fw.downloadFileFromProject(parentID,filename,destination);
    case 'session'
        fw.downloadFileFromSession(parentID,filename,destination);  
    case 'collection'
        fw.downloadFileFromCollection(parentID,filename,destination);
    case 'analysis'
        fw.downloadFileFromAnalysis(parentID,filename,destination);
    otherwise
        error('Unknown parent type %s\n',file{1}.parent.type);
end


%% Verify file size
if ~isempty(size)
    dlf = dir(destination);
    if ~isequal(dlf.bytes, size)
        error('File size mismatch: %d (file) %d (expected).\n',dlf.bytes,size);
    end
end

end

