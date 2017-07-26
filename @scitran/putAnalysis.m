function [status, result] = putAnalysis(obj,stAnalysis,container,varargin)
% Put a local file or analysis structure to a scitran site
%
%  NOT FULLY IMPLEMENTED YET
%
%      st.putAnalysis(stAnalysis,container)
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
%  stAnalysis
%     'collection analysis'
%     'session analysis'   -
%          An analysis is a collection of files defined in stData. We are
%          currently defining an analysis class.  At present stData is a
%          struct
%
%          stData  = struct('inputs','','name','','outputs','');
%
%     When uploading an analysis the id of the container must be set!  This
%     seems to be a session at this point.  I am not sure if projects or
%     collections have analyses yet.  They will, some day.
%
% Outputs:
%  status:  Boolean indicating success (0) or failure (~=0)
%  result:  The output of the verbose curl command
%
% Example:
%    st.putAnalysis(stData,'id',collection{1}.id);
%
% See also:  s_stAnalysis
%
% LMP/BW Vistasoft Team, 2015-16


%% Parse inputs
p = inputParser;

% Should have a vFunc here with more detail
p.addRequired('stData',@isstruct);
p.addRequired('container','',@(x)(ischar(x) || isstruct(x)));
p.parse(stAnalysis,varargin{:});

stAnalysis = p.Results.stData;
container  = p.Results.container;

%% Do relevant upload

% Analysis upload to a collection or session.
% In this case, the id needed to be set
if isempty(id), error('The container id must be set'); end

% We need a legitimate analysis object that we can check.  The
% definition here is implicit and should become explicit!  BW

% Construct the command to upload input and output files of any
% length % TODO: These should exist.
inAnalysis = '';
for ii = 1:numel(stAnalysis.inputs)
    inAnalysis = strcat(inAnalysis, sprintf(' -F "file%s=@%s" ', num2str(ii), stAnalysis.inputs{ii}.name));
end

outAnalysis = '';
for ii = 1:numel(stAnalysis.outputs)
    outAnalysis = strcat(outAnalysis, sprintf(' -F "file%s=@%s" ', num2str(ii + numel(stAnalysis.inputs)), stAnalysis.outputs{ii}.name));
end

% We have to pad the json struct or jsonwrite?? will not give us a list
if length(stAnalysis.inputs) == 1
    stAnalysis.inputs{end+1}.name = '';
end
if length(stAnalysis.outputs) == 1
    stAnalysis.outputs{end+1}.name = '';
end

% Remove full the full path, leaving only the file name, from input
% and output name fields.
for ii = 1:numel(stAnalysis.inputs)
    [~, f, e] = fileparts(stAnalysis.inputs{ii}.name);
    stAnalysis.inputs{ii}.name = [f, e];
end
for ii = 1:numel(stAnalysis.outputs)
    [~, f, e] = fileparts(stAnalysis.outputs{ii}.name);
    stAnalysis.outputs{ii}.name = [f, e];
end

% Jsonify the payload (assuming it is necessary)
if isstruct(stAnalysis)
    stAnalysis = jsonwrite(stAnalysis);
    % Escape the " or the cmd will fail.
    stAnalysis = strrep(stAnalysis, '"', '\"');
end

curlCmd = sprintf('curl %s %s -F "metadata=%s" %s/api/%s/%s/analyses -H "Authorization":"%s"', inAnalysis, outAnalysis, stAnalysis, obj.url, target, id, obj.token );

%% Execute the curl command with all the fields

[status,result] = stCurlRun(curlCmd);

end