function analysisID = analysisUpload(st,containerid,analysis,varargin)
% Upload a local analysis to a Flywheel site
%
% Syntax:
%    analysisID = st.analysisUpload(st,containerid,analysis,varargin)
%
% Brief description:
%  Upload an analysis to a session or to a project. If the analysis already
%  exists, you can just upload a cell array of output files, a note, or an
%  info struct. 
%
% Inputs
%   containerID  - Container for the analysis; if the id is already the
%                  analysis of an existing ID, then can add the outputs,
%                  note or info without creating a new analysis
%   analysis     - A struct comprising
%                    analysis.label  - a string
%                    analysis.inputs - a cell array of Flywheel file
%                    descriptions 
%                      inputs{}.id   - The id of the file's container
%                      inputs{}.type - The type of container
%                      inputs{}.name - The file name
%
% Optional key/value pairs
%   outputs - Cell array of local file names (full path)
%   note    - Text string for a note
%   info    - Key/value struct
%
% Outputs:
%  analysisID
%
% BW SCITRAN Team, 2018
%
% See also
%    oeFluorescenceAnalysis

% Examples:
%{
  % See oeFluorescenceAnalysis.m
%}

%% Parse inputs
p = inputParser;

p.addRequired('st',@(x)(isequal(class(x),'scitran')));
p.addRequired('containerid',@ischar);

% Can be empty when id is an analysis
p.addRequired('analysis',@(x)(isstruct(x) || isempty(x))); 

p.addParameter('outputs',[],@iscell);  % Cell array of local files
p.addParameter('note',[],@ischar);     % Text string for a note
p.addParameter('info',[],@isstruct);   % Text string for a note

p.parse(st, containerid, analysis, varargin{:});
outputs = p.Results.outputs;
note    = p.Results.note;
info    = p.Results.info;

%% Invoke the proper upload call

% Maybe this should be a new method:
%
% containerType = st.getType(containerid)
%
container         = st.fw.getContainer(containerid);
[~,containerType] = st.objectParse(container);

% Create and upload the analysis structure with its inputs
% I wonder if we have analysis.outputs that would work?
switch containerType
    case 'project'
        analysisID = st.fw.addProjectAnalysis(containerid, analysis);
    case 'session'
        analysisID = st.fw.addSessionAnalysis(containerid, analysis);
    case 'analysis'
        % ID was an analysis, so the user is modifying the note, outputs,
        % or info.
        analysisID = containerid;
    otherwise
        error('Analyses can be attached only to projeccts or sessions');
end

%% If there are local files to place in the outputs, do it here
% This may not be the proper way to do it. 
if isempty(outputs)
else
    st.fw.uploadOutputToAnalysis(analysisID, outputs);
    fprintf('Uploading output files .\n');
end

if isempty(note)
else
    st.fw.addAnalysisNote(analysisID, note);
    fprintf('Uploading note.\n');
end

if isempty(info)
else
    st.fw.setAnalysisInfo(analysisID, info);
    fprintf('Setting info.\n');
end
    
end

%{
% Analysis upload to a collection or session.
% In this case, the id needed to be set

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

curlCmd = sprintf('curl %s %s -F "metadata=%s" %s/api/%s/%s/analyses -H "Authorization":"%s"', inAnalysis, outAnalysis, analysis, st.url, target, id, st.token );

%% Execute the curl command with all the fields

[status,result] = stCurlRun(curlCmd);

end
%}
