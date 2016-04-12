function fName = stGet(pLink,fName, token)
% Retrieve a file from an sdm instance
%
%   fName = stGet(pLink,[fName])
%
% Inputs
%  pLink:  Permalink from the SDM
%  fName:  Location and/or filename to write the file
%  token:  Authorization token for download
%
% Return
%  fName:  Path to file saved on disk
%
% Example:
%   token = stAuth('instance', 'snisdm');
%   fName = stGet('https://sni-sdm.stanford.edu/api/acquisitions/55adf6956c6e/file/9999.31469779911316754284_nifti.bval', ...
%                  'lmperry@stanford.edu', '/tmp/nifti.nii.gz', token)
%
% LMP/BW Vistasoft Team, 2015-16


%% Parse inputs
if ~exist('token', 'var') || isempty(token)
    error('A token is required for download. See: stAuth.')
end


%% Combine permalink and username to generate the download link

% Handle permalinks which may have '?user='
pLink = explode('?', pLink);
pLink = pLink{1};


%% Parse fName from the permalink if 'fName' was not provided.
if ~exist('fName', 'var') || isempty (fName) 
    [~, f, e] = fileparts(pLink);
    t_e = explode('?', e);
    out_dir = tempname;
    mkdir(out_dir);
    fName = fullfile(out_dir, [ f, t_e{1}]);
end


%% Download the data

% Use curl - works on any version of matlab
curEnv = configure_curl();

curl_cmd = sprintf('/usr/bin/curl -v -X GET "%s" -H "Authorization":"%s" -o %s\n', pLink, token, fName);
[status, result] = system(curl_cmd);

unconfigure_curl(curEnv);

if status > 0
    fName = '';
    warning(result); % warn - perhaps error?
end


return
