function [status, id, results] = exist(obj, label, containerType, varargin)
% Test whether a project, session, acquisition with a label exists
%
%   [status, id, results] = st.exist(label, containerType,[parentContainerID])
%
% Searches for a type of container with a specific label.  If the
% parent container ID is known, the search is faster.
%
% Returns:
%   status  - Number of returned matches (0, 1 or N)
%   id      - The id of the object(s) (acq, or session, or project)
%   results - Cell array of the matching search result
%
% N.B. We are thinking about collections
%
% RF/BW Scitran Team, 2016

% Example usage (case sensitive searches)
%{
  [~, id] = st.exist('VWFA FOV','projects')
  [status, gid] = st.exist('wandell', 'groups')
  [status, pid] = st.exist('VWFA', 'projects')
  [status, sid] = st.exist('20151128_1621', 'sessions', 'parentID', pid{1})
  [status, aid] = st.exist('Localizer', 'acquisitions', 'parentID', sid{1})
%}

error('Method exist is deprecated. Search for the object of interest.');

end

%%
% p = inputParser;
% p.addRequired('label',@ischar);
% allowableContainers = {'projects','sessions','acquisitions','groups'};
% p.addRequired('containerType',@(x)(ismember(x,allowableContainers)));
% p.addParameter('parentID',[], @ischar);
% p.parse(label, containerType, varargin{:});
% 
% status = []; id = [];
% 
% label             = p.Results.label;
% containerType     = p.Results.containerType;
% parentID          = p.Results.parentID;
% 
% %%
% srch.path = containerType;
% %% for groups search by _id 
% 
% if strcmp(containerType, 'groups')
%     srch.(containerType).match.x0x5Fid = label;
% else
%     srch.(containerType).match.exact_label = label;
% end
% 
% %% Add a search clause on the parentID (if it exists)
% if ~isempty(parentID)
%    switch containerType
%        case 'projects'
%            parentType = 'groups';
%        case 'sessions'
%            parentType = 'projects';
%        case 'acquisitions'
%            parentType = 'sessions';
%        otherwise
%            error('unknown parent container type for %s', containerType);
%    end 
%    srch.(parentType).match.x0x5Fid = parentID;
% end
% %% exec the search and create a list of ids matching the search
% 
% results = obj.search(srch, 'all_data', true);
% 
% if ~isempty(results)
%     id = cell(1,length(results));
%     for ii = 1:length(results)
%         id{ii} = results{ii}.id;
%     end
%     status = length(results);
% end
% 
% 
% end
