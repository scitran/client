function destination = downloadContainer(obj,containertype, containerid,varargin)
% Download a Flywheel object
%
%   outfile = scitran.downloadContainer(objectID, ...)
%
% The Flywheel container will be downloaded as a tar file.  When it is
% unpacked, the directory structure is organized as
%
%    Group Name
%     Project Name
%      Session Name
%       Acquisiton Name
%        file list
%        ...
%
% Required Inputs
%  containertype  - The Flywheel container type (project,session,acquisition ...)
%  containerid    - The Flywheel container ID, usually obtained from a search
%
% Optional Inputs
%  destination:  full path to file output location (default is a tempdir)
%  size:         File size in bytes; used for checking
%
% Return
%  destination:  Full path to the file object on disk
%
% LMP/BW Vistasoft Team, 2015-16
%
% See also: 
%   scitran.search, scitran.deleteFile, scitran.sdownloadFile

% Examples
%{
  st = scitran('stanfordlabs');
  acq = st.search('acquisition','project label contains','SOC','session label exact','stimuli');
  objectID = acq{1}.acquisition.x_id; 
  st.downloadContainer(objectID);  
  edit(fName)
  delete(fName);
%}


%% Parse inputs
varargin = stParamFormat(varargin);

p = inputParser;
p.addRequired('containertype',@ischar);
p.addRequired('containerid',@ischar);

% Param/value pairs
p.addParameter('destination','',@ischar)
p.addParameter('size',[],@isnumeric);

p.parse(containertype,containerid,varargin{:});

containerType = p.Results.containertype;
id            = p.Results.containerid;
destination = p.Results.destination;
sz          = p.Results.size;

if isempty(destination)
    destination = fullfile(pwd,'Flywheel.tar');
end

%% Make the flywheel sdk call

switch(containerType)
    case 'project'
    case 'session'
        destination = obj.fw.downloadSession(id);
    case 'acquisition'
        
    case 'analysissession'
    case 'analysisacquisition'
    case 'analysiscollection'
        
    case 'collection'
    otherwise
        error('Unknown container type %s \n',containerType);
end


%% Verify file size
if ~isempty(sz)
    dlf = dir(destination);
    if ~isequal(dlf.bytes, sz)
        error('File size mismatch: %d (file) %d (expected).\n',dlf.bytes,sz);
    end
end

end

