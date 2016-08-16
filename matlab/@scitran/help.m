function help(~,srchType)
% Print out the main fields and subfields for a search command
%
% This is designed to help us write correct searches.  Needs a lot more
% work.
%
%    st = scitran('action', 'create', 'instance', 'scitran');
%    st.help('sesions');
%
% RF/BW Vistasoft Team 2016

p = inputParser;

objects = {'files','acquisitions','sessions','projects','collections','analyses','subjects'};
p.addRequired(srchType,@(x) any(strcmp(x,objects)))
p.parse(srchType);

% Force to lower case and remove any spaces
srchType = mrvParamFormat(srchType);

fprintf('Remember that certain fields need to be hex (https://github.com/scitran/client/wiki/Search-examples)\n')
fprintf('There are some DOT fields that should be     _0x2E_ \n')
fprintf('Underscore at the start of a field should be x0x5F  \n\n')

fprintf('Possible returned objects:\n\t Files, Sessions, Acquisitions, Analyses,Subjects\n\n');

switch srchType
    case {'file','files'}
        fprintf('Search type:  Files\n');

    case {'acquisition','acquisitions'}
        fprintf('Search type:  Acquisitions\n');

    case {'session','sessions'}
        fprintf('Search type:  Sessions\n');
        fprintf('\tlabel \n');
        fprintf('\texact_label \n');
        fprintf('\tcreated_time \n');
        fprintf('\tmodified_time\n');
        fprintf('\tTimeStamp\n');
        fprintf('\tTag\n');
        fprintf('\tNote\n');

    case {'project','projects'}
        fprintf('Search type:  Projects\n');
        
    case {'collection','collections'}
        fprintf('Search type:  Collections\n');
        
    case {'analysis','analyses'}
        fprintf('Search type:  Analyses\n');
        
    case {'subject','subjects'}
        
    otherwise
        error('Unknown constraint %s\n',srchType);
end

end