classdef scitran < handle
    % Scitran object for interacting with a database
    %
    % st = scitran('action','create','instance','scitran');
    %
    % 
    
    properties (SetAccess = private, GetAccess = public)  

    url = 'https://flywheel.scitran.stanford.edu';
    token = '';
    instance = 'scitran';
    
    end    % Data stuff (public)


    % Methods (public)
    methods
        
        function obj = scitran(varargin)
            % Creates the object by authorizing the instance
            % The url and the token are stored in the object.
            %
            % Example:
            %   st = scitran('action','create','instance','scitran');
            auth(obj,varargin{:});
        end
        
    end
    
    

end