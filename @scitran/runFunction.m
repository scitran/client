function destination = runFunction(obj,func,varargin)
% Search, download, and run a function stored at Flywheel
%
%    st.runFunction(func,'destination',destination,'params',params);
%
% Required inputs: 
%   func - Either a plink or struct to the function on the scitran site
%
% Optional inputs
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
p.addRequired('func');

% Specify a local directory for the script.
p.addParameter('destination',pwd,@ischar);
p.addParameter('params',[],@isstruct);

p.parse(func,varargin{:});

destination = p.Results.destination;
params      = p.Results.params; %#ok<NASGU>

%% Download the script.  What if it is a function?  

destination = obj.get(func,'destination',fullfile(destination,'localFunction.m'));
eval('localFunction(params);');

end




