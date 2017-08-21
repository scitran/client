function [status, id, results] = exist(obj,label, containerType, varargin)
% Tests whether a project, session, acquisition label exists in FW
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
% Example usage (case sensitive searches)
%
%  [~, id] = st.exist('VWFA FOV','projects')
%  [status, gid] = st.exist('Wandell Lab', 'groups')
%  [status, pid] = st.exist('VWFA', 'projects')
%  [status, sid] = st.exist('20151128_1621', 'sessions', 'parentID', pid{1})
%  [status, aid] = st.exist('Localizer', 'acquisitions', 'parentID', sid{1})
%
% RF/BW Scitran Team, 2016

%%
p = inputParser;
p.addRequired('label',@ischar);
allowableContainers = {'projects','sessions','acquisitions','groups'};
p.addRequired('containerType',@(x)(ismember(x,allowableContainers)));
p.addParameter('parentID',[], @ischar);
p.parse(label, containerType, varargin{:});

status = 0;   % Number of objects found
id = [];      % Cell array with the id of the objects

label             = p.Results.label;
containerType     = p.Results.containerType;
parentID          = p.Results.parentID;

srch.path = containerType;

% Because we don't trust elastic, we always pause here.
disp('Elastic 3 sec pause.  When the SDK updates, remove this')
pause(3);

%% Special case for groups

if strcmp(containerType, 'groups')
    % If a group, then first try if it is an id
    srch.groups.match.x0x5Fid = label;
    results = obj.search(srch, 'all_data', true);
    
    % If not empty, it was an id.  So return
    if ~isempty(results)
        id = cell(1,length(results));
        for ii = 1:length(results)
            id{ii} = results{ii}.id;
        end
        status = length(results);
        return;
    end
    
    % True for a group label
    clear srch
    srch.path = containerType;
    srch.groups.match.name = label;
    results = obj.search(srch, 'all_data', true);
    if ~isempty(results)
        id = cell(1,length(results));
        for ii = 1:length(results)
            id{ii} = results{ii}.id;
        end
        status = length(results);
        return;
    end
    
    % If we are here, it wasn't a group id or a label
    
end

%% Results was empty, so it wasn't a group id.  

% Figure that it might be a label
srch.(containerType).match.exact_label = label;

%% Add a search clause on the parentID (if it exists)
if ~isempty(parentID)
    switch containerType
        case {'projects'}
            parentType = 'groups';
        case 'sessions'
            parentType = 'projects';
        case 'acquisitions'
            parentType = 'sessions';
        otherwise
            error('unknown parent container type for %s', containerType);
    end
    srch.(parentType).match.x0x5Fid = parentID;
end
%% exec the search and create a list of ids matching the search

results = obj.search(srch, 'all_data', true);

if ~isempty(results)
    id = cell(1,length(results));
    for ii = 1:length(results)
        id{ii} = results{ii}.id;
    end
    status = length(results);
end


end
