function destination = stGet(pLink,token,varargin)
% Retrieve a file from an scitran instance
%
%   fName = stGet(pLink,token,'destination',filename,'size',size)
%
% Required Inputs
%  pLink:  Permalink from the SDM
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
%   token = stAuth('instance', 'snisdm');
%   fName = stGet('https://sni-sdm.stanford.edu/api/acquisitions/55adf6956c6e/file/9999.31469779911316754284_nifti.bval', ...
%                  'lmperry@stanford.edu', '/tmp/nifti.nii.gz', token)
%
% LMP/BW Vistasoft Team, 2015-16


%% Parse inputs
p = inputParser;
p.addRequired('pLink',@ischar);
p.addRequired('token',@ischar);

% Param/value pairs
p.addParameter('destination','',@ischar)
p.addParameter('size',[],@isnumeric);

p.parse(pLink,token,varargin{:});

pLink = p.Results.pLink;
token = p.Results.token;
destination = p.Results.destination;
size = p.Results.size;

%% Combine permalink and username to generate the download link

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

curl_cmd = sprintf('/usr/bin/curl -v -X GET "%s" -H "Authorization":"%s" -o %s\n', pLink, token, destination);
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

