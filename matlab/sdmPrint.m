function lst = sdmPrint(d,pField,varargin)
% Print a parameter field to the command window
%
%   lst = sdmPrint(d,'subject code');
%   lst = sdmPrint(d,'file name');

%
% BW/LMP Scitran Team, 2016

%% Parse inputs
p = inputParser;
p.addRequired('d',@iscell);
p.addRequired('pField',@isstr);
p.addParameter('show',false,@islogical);

% We may add additional options.  None here yet.
p.parse(d,pField,varargin{:});
pField = mrvParamFormat(p.Results.pField);

%% For each element in the data array, find and print the parameter field

n = length(d);
lst = cell(1,n);

switch pField
    case 'subjectcode'
% Switch through the conditions
for ii=1:n
    lst{ii} = d{ii}.session.subject.code;
        if ii==1, fprintf('\n**Subject codes**\n'); end
        fprintf('   %d  %s\n',ii,lst{ii});
end
    case 'filename'
for ii=1:n
    lst{ii} = d{ii}.name;
        if ii==1, fprintf('\n**File name**\n'); end
        fprintf('   %d  %s\n',ii,lst{ii});
end
    otherwise
        error('Unknown parameter field %s\n',pField);
end

end