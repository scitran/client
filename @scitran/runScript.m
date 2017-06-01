function destination = runScript(obj,script,varargin)
% DEPRECATED
% Search, download, and run a script stored at Flywheel
%
%    st.runScript(script,'destination',destination);
%
% Required inputs: 
%   script - Either a plink or struct of the script on the scitran site
%
% Optional inputs
%   destination - Full path to the script
%
% Examples:
%   See s_stRunScript;
%
% See also:  st.runFunction()
%
% Use runFunction when params needs to be set. (See s_stRunFunction)
%
% BW/RF

disp('Deprecated');
return;

%%
% p = inputParser;
% p.addRequired('script');
% 
% % Specify a local directory for the script.
% p.addParameter('destination',pwd,@ischar);
% p.addParameter('params',[],@isstruct);
% 
% p.parse(script,varargin{:});
% 
% destination = p.Results.destination;
% params      = p.Results.params; %#ok<NASGU>
% 
% %% Download the script.  What if it is a function?  
% 
% destination = obj.get(script,'destination',fullfile(destination,'localScript.m'));
% run(destination);

end




