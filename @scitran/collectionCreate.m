function id = collectionCreate(obj, label, varargin)
% Create a collection
%
% Syntax
%   id = collectionCreate(obj, labels)
%
% Create a collection with a specific label within the specified
% group.
% 
% BW 2017
%
% See also
%

%%

% Examples:
%{
 st = scitran('stanfordlabs');
 id = st.collectionCreate('deleteCollection'); 
%}
%{
 collection = st.search('collection',...
                        'collection label exact','deleteCollection');
 id = idGet(collection{1},'data type','collection');
 st.fw.deleteCollection(id);
%}

%% Parse inputs
p = inputParser;

p.addRequired('obj',@(x)(isa(x,'scitran')));
p.addRequired('label', @ischar);

p.parse(obj, label, varargin{:});

label = p.Results.label;
% if ~obj.exist('group',groupID)
%     error('No group label %s\n',groupID);
% end  

%% Create the collection
%{
collection = struct('public', true, 'label','Tesing Collection Public');
fw.addCollection(collection)
%}

params = struct('public',true,'label',label);
id.collection = obj.fw.addCollection(params);

end

