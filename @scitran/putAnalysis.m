function [status, result] = putAnalysis(obj,stData,varargin)
% Put a local file or analysis structure to a scitran site
%
%      st.putAnalysis(,stdata,'id',id)
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
%  upType - Specifies the type of upload data
%
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
%     'file' or 'files'    -
%      If a file, the structure is
%
%          stData  = struct('id','','containerType','','file','');
%
%      id            - the id of the container
%      containerType - project, session, collection, acquisition
%      file          - A full path to a file
%
% Outputs:
%  status:  Boolean indicating success (0) or failure (~=0)
%  result:  The output of the verbose curl command
%
% Example:
%    st.put('session analysis',stData,'id',collection{1}.id);
%    st.put('file',stData);
%
% LMP/BW Vistasoft Team, 2015-16


%% Parse inputs
p = inputParser;

% Should have a vFunc here with more detail
p.addRequired('stData',@isstruct);
p.addParameter('id','',@ischar);
p.parse(stData,varargin{:});

stData = p.Results.stData;
id     = p.Results.id;

%% Do relevant upload

% Analysis upload to a collection or session.
% In this case, the id needed to be set
if isempty(id), error('The container id must be set'); end

% We need a legitimate analysis object that we can check.  The
% definition here is implicit and should become explicit!  BW

% Construct the command to upload input and output files of any
% length % TODO: These should exist.
inAnalysis = '';
for ii = 1:numel(stData.inputs)
    inAnalysis = strcat(inAnalysis, sprintf(' -F "file%s=@%s" ', num2str(ii), stData.inputs{ii}.name));
end

outAnalysis = '';
for ii = 1:numel(stData.outputs)
    outAnalysis = strcat(outAnalysis, sprintf(' -F "file%s=@%s" ', num2str(ii + numel(stData.inputs)), stData.outputs{ii}.name));
end

% We have to pad the json struct or jsonwrite?? will not give us a list
if length(stData.inputs) == 1
    stData.inputs{end+1}.name = '';
end
if length(stData.outputs) == 1
    stData.outputs{end+1}.name = '';
end

% Remove full the full path, leaving only the file name, from input
% and output name fields.
for ii = 1:numel(stData.inputs)
    [~, f, e] = fileparts(stData.inputs{ii}.name);
    stData.inputs{ii}.name = [f, e];
end
for ii = 1:numel(stData.outputs)
    [~, f, e] = fileparts(stData.outputs{ii}.name);
    stData.outputs{ii}.name = [f, e];
end

% Jsonify the payload (assuming it is necessary)
if isstruct(stData)
    stData = jsonwrite(stData);
    % Escape the " or the cmd will fail.
    stData = strrep(stData, '"', '\"');
end

curlCmd = sprintf('curl %s %s -F "metadata=%s" %s/api/%s/%s/analyses -H "Authorization":"%s"', inAnalysis, outAnalysis, stData, obj.url, target, id, obj.token );

%% Execute the curl command with all the fields

[status,result] = stCurlRun(curlCmd);

end