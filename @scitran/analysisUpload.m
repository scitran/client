function [status, result] = analysisUpload(obj,analysis,container,varargin)
% Put a local file or analysis structure to a scitran site
%
% Synopsis
%    st.analysisUpload(stAnalysis,container)
%
% Brief description:
%  Upload an analyses to a Flywheel site. We can attach the
%  analysis to a session or to a project.  Not sure whether we will be able
%  to upload to a collection.  ASK.
%
% Inputs
%   obj - scitran object
%   analysis   - a struct formated with scitran analysis fields
%   container  - where we put the analysis
%
% Optional key/value pairs
%
% Outputs:
%  status:  Boolean indicating success (0) or failure (~=0)
%  result:  The output of the verbose curl command
%
% BW Vistasoft Team, 2018
%
% See also
%   s_stAnalysis

% Examples:
%{
  st.analysisUpload(stData,'id',collection{1}.id);
%}


%% Parse inputs
p = inputParser;

% Should have a vFunc here with more detail
p.addRequired('stData',@isstruct);
p.addRequired('container','',@(x)(ischar(x) || isstruct(x)));
p.parse(analysis,varargin{:});

analysis = p.Results.stData;
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
for ii = 1:numel(analysis.inputs)
    inAnalysis = strcat(inAnalysis, sprintf(' -F "file%s=@%s" ', num2str(ii), analysis.inputs{ii}.name));
end

outAnalysis = '';
for ii = 1:numel(analysis.outputs)
    outAnalysis = strcat(outAnalysis, sprintf(' -F "file%s=@%s" ', num2str(ii + numel(analysis.inputs)), analysis.outputs{ii}.name));
end

% We have to pad the json struct or jsonwrite?? will not give us a list
if length(analysis.inputs) == 1
    analysis.inputs{end+1}.name = '';
end
if length(analysis.outputs) == 1
    analysis.outputs{end+1}.name = '';
end

% Remove full the full path, leaving only the file name, from input
% and output name fields.
for ii = 1:numel(analysis.inputs)
    [~, f, e] = fileparts(analysis.inputs{ii}.name);
    analysis.inputs{ii}.name = [f, e];
end
for ii = 1:numel(analysis.outputs)
    [~, f, e] = fileparts(analysis.outputs{ii}.name);
    analysis.outputs{ii}.name = [f, e];
end

% Jsonify the payload (assuming it is necessary)
if isstruct(analysis)
    analysis = jsonwrite(analysis);
    % Escape the " or the cmd will fail.
    analysis = strrep(analysis, '"', '\"');
end

curlCmd = sprintf('curl %s %s -F "metadata=%s" %s/api/%s/%s/analyses -H "Authorization":"%s"', inAnalysis, outAnalysis, analysis, obj.url, target, id, obj.token );

%% Execute the curl command with all the fields

[status,result] = stCurlRun(curlCmd);

end