function cmd  = searchCmd(obj,srch,varargin)
% Create the cURL command for a scitran elastic search query
%
%   cmd  = st.searchCmd(srch,varargin)
%
% Inputs (either as struct or parameter/value)
%  srch:  - A JSON struct with the search requirements
%
% Outputs:
%  cmd   - String for system curl command to do search
%
% Example
%    st.searchCmd(srch)
% 
% BW, Scitran Team, 2016

%% Decode input arguments
p = inputParser;
p.PartialMatching = false;
p.CaseSensitive   = true;

% Matlab struct
p.addRequired('srch',@ischar)

% Parse
p.parse(srch,varargin{:});
srch   = p.Results.srch;

% Output file name, must end with a .json extension
oFile = [tempname, '.json'];

%% Build the command

% Set the number of search results desired (does not work with collection
% searches)
% Ask LMP what to do about this issue
% num_results = 50;

cmd = sprintf('curl -XPOST "%s/api/search" -H "Authorization":"%s" -k -d ''%s'' > %s && echo "%s"',...
    obj.url, obj.token, srch, oFile, oFile);
    
    
end
