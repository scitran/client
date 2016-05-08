classdef scitran < handle
    % Scitran object for interacting with a database
    %
    % st = scitran('action','create','instance','scitran');
    % st = scitran('action','create','instance','scitran');
    % 
    
    properties (SetAccess = private, GetAccess = public)  

    url = 'https://flywheel.scitran.stanford.edu';
    token = '';
    instance = 'scitran';
    
    end    % Data stuff (public)


    % Methods (public)
    methods
        
        function obj = scitran(varargin)
            % Creates the object and authorizes the instance
            % The url and the token are stored in the object.
            % To set up for authorization, see the wiki page, and some day
            % the comments at the top of this file!
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