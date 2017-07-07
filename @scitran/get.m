function [destination, curl_cmd] = get(obj,pLink,varargin)
% Retrieve a file from a scitran instance
%
%   [fName, curl_cmd] = get(obj,pLink,'destination',filename,'size',size)
%
% Required Inputs
%  pLink:  Either a permalink or a files{} struct containing a permalink
%  token:  Authorization token for download
%
% Optional Inputs
%  destination:  full path to file output location (default is a tempdir)
%  size:         File size in bytes (if known) used for checking
%
% Return
%  fName:  Full path to the file saved on disk
%
% Example:
%   fw = scitran('vistalab');
%   file = fw.search('files','project label contains','SOC','filename','toolboxes.json');
%   fName = fw.get(file{1});
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

p.parse(pLink,varargin{:});

pLink = p.Results.pLink;
destination = p.Results.destination;
size = p.Results.size;

%% Should use stPlink2Destination() here

% If we sent in a files{} struct, then get the plink slot out now.
if isstruct(pLink), pLink = pLink.plink; end
    
% Combine permalink and username to generate the download link

% Handle permalinks which may have '?user=' elements
pLink = strsplit(pLink, '?');
pLink = pLink{1};

%% Parse fName from the permalink if 'fName' was not provided.
if ~exist('destination', 'var') || isempty (destination) 
    [~, f, e] = fileparts(pLink);
    t_e = strsplit(e, '?');
    out_dir = tempname;
    mkdir(out_dir);
    destination = fullfile(out_dir, [ f, t_e{1}]);
end


%% Download the data

% First call gets us the ticket
curl_cmd = sprintf('/usr/bin/curl -v -k "%s" -H "Authorization":"%s" -o %s\n', pLink, obj.token, destination);
[status, result] = stCurlRun(curl_cmd);

if status > 0
    destination = '';
    error(result); 
end

% Verify file size
if ~isempty(size)
    dlf = dir(destination);
    if ~isequal(dlf.bytes, size)
        error('File size mismatch: %d (file) %d (expected).\n',dlf.bytes,size);
    end
end

end

