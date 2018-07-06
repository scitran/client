function id = collectionCreate(obj, groupID, label, varargin)
% Create a collection
%
% Syntax
%   id = collectionCreate(obj, groupID, label, varargin{:})
%
% Create a collection with a specific label.  The acquisitions parameter
% will add a list (cell array) of acquisitions to the collection.
% 
% BW 2017

%{
 % Example:
 st = scitran('stanfordlabs');
 id = st.createCollection('Wandell Lab','deleteCollection');
 st.deleteObject(id.collection);

 collection = st.search('collection',...
       'collection label exact','deleteCollection',...
       'acquisition',);

 % Make a list of acquisition IDs from somewhere
 acq = st.search('acquisition','project label exact','VWFA','limit',3);
 for ii=1:3
   acqID{ii} = acq{ii}.acquisition.x_id;
 end
  id = st.createCollection('Wandell Lab','deleteCollection','acquisition',acqID);

%}

%% Parse inputs
p = inputParser;
p.addRequired('label', @ischar);
p.addRequired('groupID',@ischar);
p.addParameter('acquisition',[],@iscell);

p.parse(label, groupID,varargin{:});
 
label        = p.Results.label;
acquisition  = p.Results.acquisition;
if ~obj.exist('group',groupID)
    error('No group label %s\n',groupID);
end  

%% Create the collection
id.collection = obj.fw.addCollection(struct('label',label,'group',groupID));

if isempty(acquisition), return; end

disp('Acquisition part not yet implemented.  Needs debugging.')

return;

% DEBUG with Michael and/or Jen.  I am just guessing on the format and
% testDrive has no example.
%
% Add the list of acquisition (based on their IDs) to the collection.
% for ii=1:numel(acquisition)
%     acq = obj.search('acquisition','acquisition id',acquisition{ii});
%     acqStruct = struct('label',acq{1}.acquisition.label,'group',groupID);
%     obj.fw.addAcquisitionsToCollection(id.collection,acqStruct);
% end

end

%% create the collection
% clear payload;
% payload.label = label;
% payload = jsonwrite(payload, struct('indent','  ','replacementstyle','hex'));
% payload = regexprep(payload, '\n|\t', ' ');
% payload = regexprep(payload, ' *', ' ');
% curlCMD = sprintf('curl -s -XPOST "%s/api/collections" -H "Authorization":"%s" -k -d ''%s''', ...
%                     obj.url, obj.token, payload);
% [status, result] = stCurlRun(curlCMD);
% result = jsonread(result);
% 
% if status
%     warning('Error creating collection: ');
%     disp(result)
%     return;
% else
%     collectionId = result.x_id;
% end
% 
% 
% %% add nodes to the collection
% 
% % prepare the payload with the nodes
% clear payload;
% payload.contents.operation = 'add';
% payload.contents.nodes = {};
% for ii = 1:length(acquisitionIds)
%     node.level = 'acquisition';
%     node.x0x5Fid = acquisitionIds{ii};
%     payload.contents.nodes{ii} = node;
% end
% 
% % prepare and send the curl command
% payload = jsonwrite(payload,struct('indent','  ','replacementstyle','hex'));
% payload = regexprep(payload, '\n|\t', ' ');
% payload = regexprep(payload, ' *', ' ');
% % hack to make this work on linux
% % TODO ask for a fix on jsonIO
% payload = regexprep(payload, '__', '_');
% curlCMD = sprintf('curl -s -XPUT "%s/api/collections/%s" -H "Authorization":"%s" -k -d ''%s''', ...
%                     obj.url, collectionId, obj.token, payload);
% [status, result] = stCurlRun(curlCMD);
% 
% if status
%     warning('Error adding object to collection: ');
%     disp(result)
% else
%     result = jsonread(result);
% end
% end

