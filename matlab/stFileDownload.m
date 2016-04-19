function dl_file = stFileDownload(url,token,srchResult,varargin)
% Download a file attached to an acquisition on a scitran site
%
%   dl_file = stFileDownload(url,token,srchResult,varargin)
%
% If the file is attached somewhere else, say a Project or Session, we need
% to figure that out.  Perhaps by another parameter or perhaps another
% functions.
%
% LMP/BW Vistasoft Team, 2016

%%
p = inputParser;

vFunc = @(x)(strcmp(x(1:5),'https'));
p.addRequired('url',vFunc);
p.addRequired('token',@ischar);
p.addRequired('srchResult',@isstruct);
p.addParameter('destination','',@ischar);
p.parse(url,token,srchResult,varargin{:});

destFile = p.Results.destination;
if isempty(destFile)
    destFile   = fullfile(pwd,srchResult{idx}.name);
end

%%
plink = sprintf('%s/api/acquisitions/%s/files/%s',...
    url, srchResult.acquisition.x0x5F_id, srchResult.name);

% Do the download
dl_file = stGet(plink, token, 'destination', destFile,'size',srchResult.size);
end
