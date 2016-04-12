function idx = stSearch(d,varargin)
% Searching through the json file
%
%  Is it possible for RF to make it such that the json file always has
%  multiple copies of the same template, but with fields missing sometimes?
%  In that case we could use data(1) instead of data{1}.
%
%   idx = sdmSearch(d,'pField','subject code','value','ex8403')
%
% Functions to consider:
%   
% cell2struct:  In case we want to simplify the json file and create an
% array of structs.
%
% Should we create a class for the search results?
%  sdmData = sdmDataCreate;
%  sdmData.search('')
%  sdmData.print('')
%  sdmData.otherFunctions
%
% BW/LMP Scitran Team, 2016

%% Parse inputs
p = inputParser;
p.addRequired('d',@iscell);
p.addParameter('pField','',@isstr);
p.addParameter('value',[]);

p.parse(d,varargin{:});
pField = p.Results.pField;
value  = p.Results.value;

%% For each element in the data array, find and print the parameter field

n = length(d);
lst = cell(1,n);

switch mrvParamFormat(pField)
    case 'subjectcode'
        % Switch through the conditions
        for ii=1:n, lst{ii} = d{ii}.session.subject.code; end
    case 'filename'
        for ii=1:n, lst{ii} = d{ii}.name; end
    otherwise
        error('Unknown parameter field %s\n',pField);
end

% http://www.mathworks.com/matlabcentral/answers/2015-find-index-of-cells-containing-my-string
idx = find(strcmp(lst,value));

end

