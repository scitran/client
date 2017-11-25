function result  = update(obj, data, varargin)
% Update the container returned by a search
% using the input data 
%
% Input:
%  data:            the data that will be included in the payload
%  srch:            the struct used to search for the target object to update,
%                   if more than one object is returned, the update is aborted
%  container:       as an alternative to the srch parameter, provide the target
%                   container directly
%  replaceMetadata: instead of adding to the existing metadata field on the 
%                   container, replace it completely with the one provided.
%
% Return:
%  result: result of the update operation
%% 
% The flag replaceMetadata allows to replace all the metadata 
% in the updated container.
%
% For example if the metadata on the existing container is:
% {
%   "foo":"bar"
% }
% and we send new metadata WITHOUT the flag:
% {
%   "bar":"foo"
% }
% the new metadata will be:
% {
%   "bar": "foo",
%   "foo": "bar"
% }
% WITH the flag instead the metadata will be just:
% {
%   "bar":"foo"
% }
% 
% RF 2016
%%
p = inputParser;
vFunc = @(x) (isstruct(x));
p.addRequired('data', vFunc);
p.addParameter('srch',[], vFunc);
p.addParameter('container', '', vFunc);
p.addParameter('replaceMetadata', 'false',@ischar);

p.parse(data, varargin{:});
data  = p.Results.data;
srch  = p.Results.srch;
targetContainer    = p.Results.container;
replaceMetadata    = p.Results.replaceMetadata;

if isempty(targetContainer) && ~isempty(srch)
    % if the target container is empty exec the search
    results = obj.search(srch);
    if isempty(results)
        error('Results of the search returned zero objects');
    elseif length(results) ~= 1
        error('Results of the search returned multiple or zero objects');
    end
    targetContainer = results{1};
elseif isempty(targetContainer)
    error('container and srch fields cannot be both empty');
end

%% update the targeContainer with the data provided
payload = savejson('', data);
cmd = obj.updateCmd(targetContainer.type, targetContainer.id, payload, 'replaceMetadata', replaceMetadata);
[~, result] = system(cmd);
end