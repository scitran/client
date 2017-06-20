function lst = print(~,d,pField,varargin)
% Print a parameter field to the command window
%
%    st = scitran('scitran');
%   lst = st.print(projects,'label');
%   lst = sd.print(d,'file name');
%   sd.print(d,'group name');
%
% Not really worked out yet ...
%
% Printable fields for different objects (need to get checked)
% ---------------
%  subject code - session, ...
%  label        - group, ....
%  file name    - file, ...
%  group name   - session, ...
%
% BW/LMP Scitran Team, 2016

%% Parse inputs
p = inputParser;
p.addRequired('d',@iscell);               % Cell array of data returns
p.addRequired('pField',@isstr);           % Field name
p.addParameter('show',true,@islogical);   % Could turn it off

% We may add additional options.  None here yet.
p.parse(d,pField,varargin{:});

printLabel = p.Results.pField;
show   = p.Results.show;

%% For each element in the data array, find and print the parameter field

n = length(d);
lst = cell(1,n);

switch mrvParamFormat(printLabel);
    case 'subjectcode'
        % Switch through the conditions
        for ii=1:n            
            lst{ii} = d{ii}.session.subject.code;
        end
    case 'filename'
        for ii=1:n
            lst{ii} = d{ii}.name;
        end
    case 'label'
        for ii=1:n
            lst{ii} = d{ii}.source.label;
        end
    case 'groupname'
        for ii=1:n
            lst{ii} = d{ii}.source.group.name;
        end
    otherwise
        error('Unknown parameter field %s\n',pField);
end

% If print, make a table and print it with the label
if show
    fprintf('\n\n');
    eval(sprintf('%s = lst''; T = cell2table(%s);',printLabel,printLabel));
    disp(T)
end

end