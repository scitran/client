function [status, result] = createCollection(obj, label, acquisitionIds)
% Create a collection from a list of acquisitions
% 
% example:
% st = scitran('action', 'create', 'instance', 'scitran');
% acquisitions = {'58d470397c09ef001ceaa005', '58d46ff87c09ef001cea9fe3'};
% st.createCollections('myCollections', acquisitions);
% 
%
% RF 2017

p = inputParser;
p.addRequired('label', @ischar);
p.addRequired('acquisitionIds');
p.parse(label, acquisitionIds);

acquisitionIds  = p.Results.acquisitionIds;
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
for ii = 1:length(acquisitionIds)
    node.level = 'acquisition';
    node.x0x5Fid = acquisitionIds{ii};
    payload.contents.nodes{ii} = node;
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
end
end

