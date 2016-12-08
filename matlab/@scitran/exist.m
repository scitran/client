function [status, id] = exist(obj,label, containerType, varargin)
% Tests whether a project, session, acquisition label exists in FW
%
%   [status, id] = st.exist(label,'containerType',[parentContainerID])
%
% Searches for a container of particular type with the given label.  If the
% parent container ID is known, the search is faster.
%
% If multiple 
%
% Returns:
%   status - Number of returned matches (0, 1 or N)
%   id     - The id of the object(s) (acq, or session, or project)
%
% N.B. We are thinking about collections
%
% Example usage:
% [status, gid] = st.exist('wandell lab', 'groups')
% [status, pid] = st.exist('vwfa', 'projects', 'parentID', gid{1})
% [status, pid] = st.exist('vwfa_nims', 'projects', 'parentID', gid{1})
% [status, sid] = st.exist('20151128_1621', 'sessions', 'parentID', pid{1})
% [status, aid] = st.exist('localizer', 'acquisitions', 'parentID', sid{1})
% RF/BW Scitran Team, 2016

%%
p = inputParser;
p.addRequired('label',@ischar);
p.addRequired('containerType',@ischar);
p.addParameter('parentID',[], @ischar);
p.parse(label, containerType, varargin{:});

label             = p.Results.label;
containerType     = p.Results.containerType;
parentID          = p.Results.parentID;

srch.path = containerType;
if strcmp(containerType, 'groups')
    srch.(containerType).match.name = label;
else
    srch.(containerType).match.exact_label = label;
end
if ~isempty(parentID)
   switch containerType
       case 'projects'
           parentType = 'groups';
       case 'sessions'
           parentType = 'projects';
       case 'acquisitions'
           parentType = 'sessions';
       otherwise
           error('unknown parent container type for %s', containerType);
   end
   srch.(parentType).match.x0x5F_id = parentID;
end
results = obj.search(srch);
id = cell(1,length(results));
for ii = 1:length(results)
    id{ii} = results{ii}.id;
end
status = length(results);


end
