function srch = formatSearchType(srch)
% Validate the search and list string, allowing for plural to singular
%
% We allow plural and upper case variants of the for the return type. The
% lower case and conversion to singular from are done here.
%
% Wandell, 2017
%
% See also
%   scitran.search, scitran.list

srch = lower(srch);
if ismember(srch,{'file','session','acquisition','project','collection','analysis'})    
    return;
end

% Maybe it is plural.
if     strcmp(srch,'files'),         srch = 'file';        return;
elseif strcmp(srch,'sessions'),      srch = 'session';     return;
elseif strcmp(srch,'acquisitions'),  srch = 'acquisition'; return;
elseif strcmp(srch,'projects'),      srch = 'project';     return;
elseif strcmp(srch,'collections'),   srch = 'collection';  return;
elseif strcmp(srch,'analyses'),      srch = 'analysis';    return;
else
    % Not fine and not plural.  Complain.
    error('Unknown srch string %s\n',srch);
end

end
