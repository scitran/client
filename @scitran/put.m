function [status, result] = put(obj,filename,container,varargin)
% Put a local file or analysis structure in a scitran site
%
%   [status, result] = scitran.put(filename,container)
%
% We use this method to put files or analyses onto a scitran site
% Currently, we either attach a file to a location in the site, or we
% upload an analysis. 
%
% A file can be attached to several different container types.  That part
% of the code is not thoroughly tested yet, but we do put files up there
% anyway.
%
% An analysis can be attached to a collection or session. 
% 
%   {'session analysis','collection analysis'}
%
% Inputs:
%      filename   - A full path to a file
%      container  - Struct defining the container of the file, a project,
%         session, acquisition, or collection
%
% Optional:
%       metadata - Not yet implemented, but this will be a json struct that
%                  can be uploaded.  More details to follow.
%
% Outputs:
%  status:  Boolean indicating success (0) or failure (~=0)
%  result:  The output of the verbose curl command
%
% Example:
%   fw = scitran('vistalab');
%  % Full file path
%   fullFilename = fullfile(stRootPath,'data','WLVernierAcuity.json');
%  % Get the container
%    project = fw.search('projects','project label contains','SOC');
%  % Go.
%    fw.put(fullFilename,project);
%
% See also:  stCurlRun
%
% LMP/BW Vistasoft Team, 2015-16


%% Parse inputs
p = inputParser;

p.addRequired('filename',@(x)(exist(x,'file')));
p.addRequired('container', @iscell);
p.addParameter('metadata','',@isstruct);

p.parse(filename,container,varargin{:});

container     = p.Results.container;
containerID   = container{1}.id;
containerType = container{1}.type;

if ~ismember(containerType,{'projects','sessions','acquisitions','collections'})
    error('Bad container type %s\n',containerType);
end

metadata = p.Results.metadata;

%% The meta data should be a json file. 
%  We need to develop this bit again with LMP
%
% if isfield(stData, 'metadata')
%     metadata = jsonwrite(stData.metadata);
%     
%     % Escape the " or the cmd will fail.
%     metadata = strrep(metadata, '"', '\"');
%     metadata = sprintf('-F "metadata=%s"', metadata);
% else
%     metadata = '';
% end

%% Build and execute the curl command

[~, fname, ext] = fileparts(filename);
fname = [fname, ext];

% New method, not including metadata or -s (silent) switch
% Not sure how to put a file.  So for now, sticking with the old curl
% method.
%  options = weboptions;
%  options.RequestMethod = 'POST';
%  options.HeaderFields = {'Authorization',obj.token};
%  fwURL = sprintf('%s/api/%s/%s/files',obj.url,containerType,containerID);
%  files = sprintf('file=@%s;filename=%s',filename, fname);
%  response = webwrite(fwURL,'-F',files,options);

curl_cmd = sprintf('curl -s -F "file=@%s;filename=%s" %s "%s/api/%s/%s/files" -H "Authorization":"%s" -k',...
    filename, fname, metadata, obj.url, containerType, containerID, obj.token);

% Execute the command
[status, result] = stCurlRun(curl_cmd);

% Let the user know if it worked
if ~status, fprintf('%s sucessfully uploaded.\n',fname); end

end