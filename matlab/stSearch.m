function idx = stSearch(d,varargin)
% Search through the data returned from a scitran search
%
% INPUTS:  Parameter/Value pairs, or slots in a single structure
%   parameter field
%   value to match
%   
% RETURN
%   idx:  List of indices where the parameter matches the value
%
% Known Parameter fields (case and space insensitive)
%   subject code
%   filename
%
% Multiple parameter/value pairs can be 
%   idx = stSearch(d,'pField','subject code','value','ex8403')
%
% Notes:
% Is it possible for RF to make it such that the json file always has
% multiple copies of the same template, but with fields missing sometimes?
% In that case we could use data(1) instead of data{1}.
%
% Functions to consider:
%   
% cell2struct:  In case we want to simplify the json file and create an
% array of structs.
%
% Should we create a class for the search results?
%  stData = stDataCreate;
%  stData.search('')
%  stData.print('')
%  stData.otherFunctions
%
% BW/LMP Scitran Team, 2016

%% Parse inputs
if ~exist('d','var') || ~iscell(d)
    error('First argument must be cell array of scitran search data');
end
if mod(length(varargin),2)
    error('Even number of parameter/value pairs required');
end

%% For each element in the data array, find and print the parameter field

nData   = length(d);
nSrch   = (nargin-1)/2;
lst = cell(1,nData);
idx = zeros(nSrch,nData);

% For each parameter in the parameter/value list
for pp=1:nSrch
    pField = varargin{1 + 2*(pp-1)};  % This is the parameter
    value  = varargin{2 + 2*(pp-1)};  % This is the value
    switch mrvParamFormat(pField)     % Force lower, no space
        
        % Make a list of all the values for that parameter
        case 'subjectcode'
            for ii=1:nData, lst{ii} = d{ii}.session.subject.code; end
        case 'filename'
            for ii=1:nData, lst{ii} = d{ii}.name; end
        otherwise
            error('Unknown parameter field %s\n',pField);
    end
    
    % Find the indices that match that parameter
    % idx(pp,:) = strcmp(lst,value);
    foo = regexp(lst,value);
    for jj=1:nData
        if ~isempty(foo{jj}), idx(pp,jj) = 1; end
    end 
end

% Now, we could find the intersection of all the indices.  Or we could just
% return the cell array of all the indices.

% http://www.mathworks.com/matlabcentral/answers/2015-find-index-of-cells-containing-my-string

end

