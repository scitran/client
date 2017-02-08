function result  = update(obj, data, srch, varargin)
% Update the container returned by a search
% using the input data 
%
% Input:
%  srch:  the struct used to search for the target object to update.
%         if more than one object is returned, the update is aborted
%  data:  the data that will be included in the payload
%
% Return:
%  result: result of the update operation
%
% RF
p = inputParser;
vFunc = @(x) (isstruct(x));
p.addRequired('data', vFunc);
p.addRequired('srch', vFunc);

p.parse(data, srch, varargin{:});
data  = p.Results.data;
srch  = p.Results.srch;
% exec the search
results = obj.search(srch);
if length(results) ~= 1
    error('Results of the search returned multiple objects');
end
targetContainer = results{1};

% update the targeContainer with the data provided
payload = savejson('', data);
cmd = obj.updateCmd(targetContainer.type, targetContainer.id, payload);
[~, result] = system(cmd);
end