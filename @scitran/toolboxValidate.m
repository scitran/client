function [valid, lst] = toolboxValidate(~,tbx,varargin)
% Validate that the toolboxes are on the user's Matlab path
%
% Syntax
%   lst = st.toolboxValidate(tbx,...);
%
% Input (required)
%   tbx - An array of toolboxes 
% 
% Input (optional)
%   verbose - boolean.  Print out some information.
%
% Return
%   valid - Boolean.  If true, all pass.  Otherwise false.
%   lst   - Binary pass/fail list.
%
% Wandell, Vistasoft Team, 2017
%
% See also scitran.toolbox

% st = scitran('stanfordlabs');
% Example
%{
 tbx = st.toolboxGet('dti-error.json','project name','DEMO');
 [v,l] = st.toolboxValidate(tbx)
%}
%{
 tbx = st.toolboxGet('aldit-toolboxes.json','project name','ALDIT');
 [v,l] = st.toolboxValidate(tbx)
%}
%{
 tbx = st.toolboxGet('toolboxes.json','project name','SOC ECoG (Hermes)');
 [v,l] = st.toolboxValidate(tbx,'verbose',true);
%}

%%
p = inputParser;
p.addRequired('tbx',@(x)(isa(x,'toolboxes')));
p.addParameter('verbose',false,@islogical);

varargin = stParamFormat(varargin);

p.parse(tbx,varargin{:});
verbose = p.Results.verbose;

%% Check that each toolbox passes the test

n = numel(tbx);
lst = zeros(n,1);
for ii=1:numel(tbx)
    lst(ii) = tbx(ii).test;
end

valid = true;
if sum(lst) < n, valid = false; end

if verbose
    fprintf('Tested %d toolboxes\n',n)
    for ii=1:n
        name = tbx(ii).gitrepo.project;
        cmd  = tbx(ii).testcmd;
        if lst(ii) == 1
            fprintf('* %s toolbox passed on command %s\n',name,cmd);
        else
            fprintf('* %s toolbox failed on command %s\n',name,cmd);
        end    
    end 
end

end