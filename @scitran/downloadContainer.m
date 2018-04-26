function destination = downloadContainer(obj,objectID,varargin)
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
%  objectID - The Flywheel object ID, usually obtained from a search
%
% Optional Inputs
%  destination:  full path to file output location (default is a tempdir)
%  size:         File size in bytes; used for checking
%
% Return
%  destination:  Full path to the file object on disk
%
% See also: search, deleteFile, downloadFile
%
% LMP/BW Vistasoft Team, 2015-16

% Examples
%{
  st = scitran('stanfordlabs');
  acq = st.search('acquisition','project label contains','SOC','session label exact','stimuli');
  objectID = acq{1}.acquisition.x_id; 
  st.downloadContainer(objectID);  
  edit(fName)
  delete(fName);
%}

%%
error('Not implemented yet');

end

%{
% Use this when you are ready.
%% Parse inputs
p = inputParser;

p.addRequired('objectID',@ischar);

% Param/value pairs
p.addParameter('destination','',@ischar)
p.addParameter('size',[],@isnumeric);

p.parse(objectID,varargin{:});

destination = p.Results.destination;
size        = p.Results.size;

%%

% Get the Flywheel commands
fw = obj.fw;

if isempty(destination)
    destination = fullfile(pwd,'Flywheel.tar');
end

disp('Not sure what Flywheel SDK call will bring down the tar file.')

% fw.getAcquisition(objectID);


%% Verify file size
if ~isempty(size)
    dlf = dir(destination);
    if ~isequal(dlf.bytes, size)
        error('File size mismatch: %d (file) %d (expected).\n',dlf.bytes,size);
    end
end

end
%}
