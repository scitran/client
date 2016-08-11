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
p.addParameter('all_data',false,@islogical);

% Parse
p.parse(srch,varargin{:});
srch   = p.Results.srch;

% Convert logical to string
all_data = p.Results.all_data;
if   all_data, all_data = 'true';
else           all_data = 'false';
end

% Output file name, must end with a .json extension
oFile = [tempname, '.json'];

%% Build the command
cmd = sprintf('curl -s -XPOST "%s/api/search?all_data=%s" -H "Authorization":"%s" -k -d ''%s'' > %s && echo "%s"',...
    obj.url, all_data, obj.token, srch, oFile, oFile);
    

end
