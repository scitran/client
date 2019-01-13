function analysis = analysisCreate(~, label, inputs)
% Create an analysis with its parameters
%
%  analysis = scitran.analysisCreate(label,inputs)
%
% Wandell, SCITRAN Team, 2018
%
% See also
%   scitran.analysisUpload, scitran.analysisDownload
%

% Examples:
%{
  st = scitran('stanfordlabs');
  inputs = cell(2,1);  
  inputs{1} = 'filename1.mat'; inputs{2} = 'filename1.json';
  analysis = st.analysisCreate('insightfulAnalysis',inputs);
%}
%% Set up parameters
p = inputParser;

p.addRequired('label',@ischar)
p.addRequired('inputs',@iscell);

p.parse(label,inputs);

%% Set it, and forget it
analysis.label   = label;
analysis.inputs  = inputs;

end