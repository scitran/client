classdef scitran < handle
    % Scitran object to interact with a scitran database
    %
    % st = scitran('action','create','instance','scitran');
    % st = scitran('action','refresh');
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

    url = 'https://flywheel.scitran.stanford.edu';
    token = '';
    instance = 'scitran';
    
    end    % Data stuff (public)


    % Methods (public)
    methods
        
        function obj = scitran(varargin)
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
            %   st = scitran('action','create','instance','scitran');
            %
            %   'actions' - 'create', 'refresh', 'revoke'
            %  'instance' -  String denoting the st instance to authorize
            %
            auth(obj,varargin{:});
        end
        
    end
    
    

end