classdef scitran < handle
    % Scitran object to interact with a scitran database
    %
    %   st = scitran('scitran','action',...,'verify',...)
    %
    % Methods include:
    %   auth    - Authorize interaction with database
    %   search  - Search
    %   docker  - Run a docker container (Gear)
    %   browser - Browse to a page in the Flywheel instance
    %   get     - Get a file
    %   put     - Put a file
    %
    % LMP/BW Scitran Team, 2016
    
    properties (SetAccess = private, GetAccess = public)  

    url = '';
    token = '';
    instance = 'scitran';
    
    end    % Data stuff (public)


    % Methods (public)
    methods
        
        function obj = scitran(instance,varargin)
            % Creates the object and authorizes the instance The url and
            % the token are stored in the object. 
            %
            % To set up the software environment for creating a scitran
            % client object and obtaining authorization, see the scitran
            % client wiki page
            % 
            %   <https://github.com/scitran/client>
            %
            % Example:
            %   st = scitran('scitran','action','create');
            %
            %  'instance' -  String denoting the st instance to authorize
            %  'actions'  - {'create', 'refresh', 'remove'}
            %  'verify'   - performs a search to verify validity.
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.addRequired('instance', @ischar);
            p.parse(instance,varargin{:});
            
            authAPIKey(obj,instance,varargin{:});
        end
        
    end

end