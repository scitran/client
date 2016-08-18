RF and BW to fill in more detail on the possible searches.

### What can be searched on and returned

objects = {'files','acquisitions','sessions','projects','collections','analyses','subjects','notes'};

### Special characters

Remember that certain fields need to be hex (https://github.com/scitran/client/wiki/Search-examples)
There are some DOT fields that should be     _0x2E_ 
Underscore at the start of a field should be x0x5F

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
        
    case {'notes','note'}
