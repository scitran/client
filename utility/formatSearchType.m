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
valid = {'group','project','session','acquisition','file',...
    'analysis','analysessession','analysesproject', ...
    'collection','collectionsession','collectionacquisition',...
    'modality','acquisitionfile','subject'};

if ismember(srch,valid)
    % Already valid, so return
    return;
end

% Maybe it is plural.
if     strcmp(srch,'files'),         srch = 'file';        return;
elseif strcmp(srch,'sessions'),      srch = 'session';     return;
elseif strcmp(srch,'acquisitions'),  srch = 'acquisition'; return;
elseif strcmp(srch,'projects'),      srch = 'project';     return;
elseif strcmp(srch,'collections'),   srch = 'collection';  return;
elseif strcmp(srch,'analyses'),      srch = 'analysis';    return;
elseif strcmp(srch,'groups'),        srch = 'group';       return;
elseif strcmp(srch,'modalities'),    srch = 'modality';    return;
elseif strcmp(srch,'subjects'),      srch = 'subject';    return;
elseif strcmp(srch,'collectionsessions')
    srch = 'collectionsession'; return;
elseif strcmp(srch,'collectionacquisitions')
    srch = 'collectionacquisition'; return;
elseif strcmp(srch,'acquisitionfiles')
    srch = 'acquisitionfile'; return;
else
    % Complain.
    error('Unknown srch string %s\n',srch);
end

end
