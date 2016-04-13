classdef scitran(instance) < handles
    % Scitran object for interacting with a database
    %
    % st = scitran('scitran');
    %
    % 
    
    % Data stuff (public)    
    url
    token

    queryCmd
    queryResult
    
end

    % Methods (public)
    function scitran(obj,instance)
    % Constructor
        
    [token, url] = stAuth(instance);
    
    end
    
    function search
    end
    
    function get
    end
    
    function put
    end
    
    function printResult
    end
    
    function print
    end
%

end