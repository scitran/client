function [status, result] = put(obj,filename,container,varargin)
% Put a local file or analysis structure to a scitran site
%
%   [status, result] = put(obj,filename,container)
%
% We use this method to put files or analyses onto a scitran site
% Currently, we either attach a file to a location in the site, or we place
% an analysis onto the site.
%
% The analysis can be attached to a collection or session.
%   {'session analysis','collection analysis'}
%
% The file can be attached to several different container types.  That part
% of the code is not thoroughly tested yet, but we do put files up there
% anyway.
%
% Inputs:
%      filename   - A full path to a file
%      container  - Container
%
% Outputs:
%  status:  Boolean indicating success (0) or failure (~=0)
%  result:  The output of the verbose curl command
%
% Example:
%
% LMP/BW Vistasoft Team, 2015-16


%% Parse inputs
p = inputParser;

% Should have a vFunc here with more detail
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

curl_cmd = sprintf('curl -s -F "file=@%s;filename=%s" %s "%s/api/%s/%s/files" -H "Authorization":"%s" -k',...
    filename, fname, metadata, obj.url, containerType, containerID, obj.token);

% Execute the command
[status, result] = stCurlRun(curl_cmd);

% Let the user know if it worked
if ~status, fprintf('%s sucessfully uploaded.\n',fname); end

end