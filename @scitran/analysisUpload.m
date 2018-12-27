function analysisID = analysisUpload(st,containerid,analysis,varargin)
% Upload a local analysis to a Flywheel site
%
% Syntax:
%    analysisID = st.analysisUpload(st,containerid,analysis,varargin)
%
% Brief description:
%  Upload an analysis to a session or to a project. This creates the
%  analysis.  It does not appear possible to add outputs to the analysis
%  after it is already created (ask Justin).
%
% Inputs
%   containerID  - Create an analysis, with defined inputs and outputs,
%                  note and info
%   analysis     - A struct comprising
%                    analysis.label  - string
%                    analysis.inputs - cell array of Flywheel file info 
%                      inputs{}.id   - The id of the file's container
%                      inputs{}.type - The type of container
%                      inputs{}.name - The file name
%
% Optional key/value pairs
%   outputs - Cell array of local file names (full path) to upload
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

% When containerid is an analysis, we are adding a file to an existing
% analysis.  In that case, this can be empty.
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
    otherwise
        error('Analyses can be attached only to projeccts or sessions');
end

%% If there are local files to place in the outputs, do it here
% This may not be the proper way to do it. 
if isempty(outputs)
else
    % Test more whether we can add outputs after analysis already exists.
    fprintf('Uploading output files.\n');
    st.fw.uploadOutputToAnalysis(analysisID, outputs);
end

if isempty(note)
else
    fprintf('Uploading note.\n');
    st.fw.addAnalysisNote(analysisID, note);
end

if isempty(info)
else
    fprintf('Setting info.\n');
    st.fw.setAnalysisInfo(analysisID, info);
end
    
end


