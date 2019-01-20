function analysis = stAnalysisCreate(varargin)
% Create an analysis struct that can be filled and uploaded
%
% Syntax:
%   analysis = stAnalysisCreate(varargin)
%
% Description:
%
% Inputs:
%   N/A
%
% Optional key/value pairs:
%   label
%   container type
%   container id
%   input file names
%
% Outputs:
%
% BW, SCITRAN Team, 2018
%
% See also
%  

% Examples
%{
  proj = st.list('projects','wandell');
  ctype = 'project';
  cid   = proj{1}.id
  fname = 'helpme';
  analysis = stAnalysisCreate('label','string example','container type',ctype,'container id',cid,'input file names',fname);
%}
%{
  inputs{1}.type = 'acquisition'; 
  inputs{1}.id   = 'xxxx'; 
  inputs{1}.name  ='help';

  inputs{2}.type = 'acquisition'; 
  inputs{2}.id   = 'yyy'; 
  inputs{2}.name  ='help2';

  analysis = stAnalysisCreate('label','cell array example','input file names',inputs);
%}

%% Parse
p = inputParser;
varargin = stParamFormat(varargin);

p.addParameter('label','Default analysis label',@ischar);

vFunc = @(x)(iscell(x) || ischar(x));
p.addParameter('containertype','',vFunc);
p.addParameter('containerid','',vFunc);
p.addParameter('inputfilenames','',@iscell);

p.parse(varargin{:});

label          = p.Results.label;
containerType  = p.Results.containertype;
containerId    = p.Results.containerid;
inputFileNames = p.Results.inputfilenames;

%%
clear analysis
% analysis = flywheel.model.AnalysisInput;

analysis.label = label;

if ~iscell(inputFileNames)
    analysis.inputs{1} = struct('type', containerType, ...
        'id',   containerId,...
        'name', inputFileNames);
else
    % In this case, inputFileNames must be a cell array, with each cell
    % being a struct with the fields type, id and name
    analysis.inputs = inputFileNames;
end

end