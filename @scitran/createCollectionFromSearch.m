function [status, result] = createCollectionFromSearch(obj, label, searchResults)
% Create a collection from a list of acquisition searchResults
%
% example:
% st = scitran('action', 'create', 'instance', 'scitran');
% clear srch;
% srch.path = 'acquisitions';
% srch.projects.match.label = 'HCP';
% srch.acquisitions.match.label = 'T1w';
% searchResults = st.search(srch);
% [status, result] = st.createCollectionFromSearch('HCP T1s', searchResults);
%
% RF 2017
%

%%
p = inputParser;
p.addRequired('label', @ischar);
p.addRequired('searchResults');
p.parse(label, searchResults);

searchResults  = p.Results.searchResults;
label = p.Results.label;
%% create the collection
clear payload;
payload.label = label;
payload = jsonwrite(payload, struct('indent','  ','replacementstyle','hex'));
payload = regexprep(payload, '\n|\t', ' ');
payload = regexprep(payload, ' *', ' ');
curlCMD = sprintf('curl -s -XPOST "%s/api/collections" -H "Authorization":"%s" -k -d ''%s''', ...
                    obj.url, obj.token, payload);
[status, result] = stCurlRun(curlCMD);
result = jsonread(result);

if status
    warning('Error creating collection: ');
    disp(result)
    return;
else
    collectionId = result.x_id;
end


%% add nodes to the collection

% prepare the payload with the nodes
clear payload;
payload.contents.operation = 'add';
payload.contents.nodes = {};
jj = 1;
for ii = 1:length(searchResults)
    if ~isempty(regexp(searchResults{ii}.type, 'projects|sessions|acquisitions', 'once'))
        clear node;
        node.level = searchResults{ii}.type(1:end-1);
        node.x0x5F_id = searchResults{ii}.id;
        payload.contents.nodes{jj} = node;
        jj = jj + 1;
    end
end

% prepare and send the curl command
payload = jsonwrite(payload,struct('indent','  ','replacementstyle','hex'));
payload = regexprep(payload, '\n|\t', ' ');
payload = regexprep(payload, ' *', ' ');
% hack to make this work on linux
% TODO ask for a fix on jsonIO
payload = regexprep(payload, '__', '_');
curlCMD = sprintf('curl -s -XPUT "%s/api/collections/%s" -H "Authorization":"%s" -k -d ''%s''', ...
                    obj.url, collectionId, obj.token, payload);
[status, result] = stCurlRun(curlCMD);

if status
    warning('Error adding object to collection: ');
    disp(result)
else
    result = jsonread(result);
    fprintf('Collection created\n');
end
end

