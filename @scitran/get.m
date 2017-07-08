function destination = get(obj,file,varargin)
% Retrieve a file from a scitran instance
%
%   outfile = get(obj,pLink,'destination',filename,'size',size)
%   outfile = scitran.get(pLink,'destination',filename,'size',size)

%
% Required Inputs
%  file:  Either a permalink or a files{} struct containing a permalink
%
% Optional Inputs
%  destination:  full path to file output location (default is a tempdir)
%  size:         File size in bytes; used for checking
%
% Return
%  fName:  Full path to the file saved on disk
%
% Example:
%   fw = scitran('vistalab');
%   file = fw.search('files','project label contains','SOC','filename','toolboxes.json');
%   fName = fw.get(file{1});  edit(fName)
%  Or
%   fName = fw.get(file{1}.plink);  edit(fName)
%
% See also: scitran.put, scitran.deleteFile
%
% LMP/BW Vistasoft Team, 2015-16


%% Parse inputs
p = inputParser;

% plink can either be a cell array of Matlab structs, a struct, or a plink
% string linking to a database file.
vFunc = @(x) (ischar(x) || isstruct(x));
p.addRequired('pLink',vFunc);

% Param/value pairs
p.addParameter('destination','',@ischar)
p.addParameter('size',[],@isnumeric);

p.parse(file,varargin{:});

file        = p.Results.pLink;
destination = p.Results.destination;
size        = p.Results.size;

%% Should use stPlink2Destination() here

% If we sent in a files{} struct, then get the plink slot out now.
if isstruct(file), file = file.plink; end
    
% Combine permalink and username to generate the download link

% Handle permalinks which may have '?user=' elements
file = strsplit(file, '?');
file = file{1};

%% Parse fName from the permalink if 'fName' was not provided.

if ~exist('destination', 'var') || isempty (destination) 
    destination = stPlink2Destination(file);
end

%% Download the data

% First call gets us the ticket
%  curl_cmd = sprintf('/usr/bin/curl -v -k "%s" -H "Authorization":"%s" -o %s\n', pLink, obj.token, destination);
%  [status, result] = stCurlRun(curl_cmd);

% New method
options = weboptions;
options.RequestMethod = 'GET';
options.HeaderFields = {'Authorization',obj.token};
websave(destination,file,options);

% if status > 0
%     destination = '';
%     error(result); 
% end

% Verify file size
if ~isempty(size)
    dlf = dir(destination);
    if ~isequal(dlf.bytes, size)
        error('File size mismatch: %d (file) %d (expected).\n',dlf.bytes,size);
    end
end

end

