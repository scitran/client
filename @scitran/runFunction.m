function [destination,val] = runFunction(st,func,varargin)
% Search, download, and run a function stored at Flywheel
%
%  [destination,val] = st.runFunction(func,'project',...,'destination',...,'params',...);
%
% Required inputs: 
%   func - Either a scitran struct of the function or a filename (string)
%
% Optional inputs
%   project     - Project label (string)
%   destination - Full path to the local script
%   params      - Struct of parameters for the function
%
% Examples:
%  see s_stRunFunction.m
%
% See also: st.runScript()
%
% BW, Scitran Team, 2017

%%
p = inputParser;
vFunc = @(x)(isstruct(x) || ischar(x));
p.addRequired('func',vFunc);

% Specify a local directory for the script.
p.addParameter('project',[],@ischar);
p.addParameter('destination',pwd,@ischar);
p.addParameter('params',[],@isstruct);

p.parse(func,varargin{:});
project     = p.Results.project;
destination = p.Results.destination;
params      = p.Results.params; %#ok<NASGU>

%% Download the function 

if ischar(func)
    if isempty(project)
        error('Project label required when func is a string');
    else
        funcS = st.search('files',...
            'project label',project,...
            'filename',func,...
            'summary',true);
    end
else
    funcS = func;
end

%% Download to localFunction and evaluate with params

destination = st.get(funcS{1},...
    'destination',fullfile(destination,'localFunction.m'));

val = eval('localFunction(params);');

end




