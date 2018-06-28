function [status, userInfo] = verify(obj,varargin)
% Search for number of projects, mainly to verify that the APIkey works
%
%   [status, userInfo] = st.verify;
%
% Returns
%   status:   1 if verified, 0 otherwise.
%   userInfo: Structured returned by fw.getCurrentUser method
%
% BW Scitran team, 2017
%
% See also
%   scitran

% Examples:
%{
  st = scitran('stanfordlabs');
  if ~st.verify,  error('Bad scitran key, or no projects.'); 
  else, disp('verified');
  end
%}
%{
  st = scitran('stanfordlabs');
  st.verify('verbose',true);
%}

%%
p = inputParser;
p.addRequired('obj',@(x)(isa(x,'scitran')));
p.addParameter('verbose',false,@islogical);
p.parse(obj,varargin{:});
verbose = p.Results.verbose;

%%
try
    userInfo = obj.fw.getCurrentUser;
    if isempty(userInfo), status = 0; 
    else,                 status = 1;
    end
    
    if verbose && status == 1, fprintf('Verified\n');
    elseif verbose,            fprintf('Not verified\n');
    end

catch ME
    % It is possible status doesn't get returned in this case.
    rethrow(ME)

end


end
