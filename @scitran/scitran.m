classdef scitran < handle
    % Scitran object to interact with a scitran database
    %
    %   st = scitran('instance','action',...)
    %
    % Required
    %  'instance' -  String denoting the site to authorize
    %
    % Parameter/Value
    %  'action'  - {'create', 'refresh', 'remove'}
    %
    % See https://github.com/scitran/client/wiki
    %
    % LMP/BW Scitran Team, 2016
    
    properties (SetAccess = private, GetAccess = public)  

    url = '';
    instance = 'scitran';
    
    % Perhaps scitran should be a subclass of the @flywheel.  For now, we
    % are storing it as an object within the scitran object.
    fw = [];    % A flywheel SDK class.
    
    end    % Data stuff (public)

    properties (SetAccess = private, GetAccess = private)
        % Don't let people see the API token
        token = '';
    end    

    % Methods (public)
    methods
        
        function obj = scitran(instance,varargin)
            % Enables Matlab command line interactions with a Flywheel instance.
            %
            % This constructor creates the scitran object and authorizes
            % secure interactions with the Flywheel instance. The url of
            % the instance and the user's security token for that instance
            % are stored locally.
            %
            % The constructor can be invoked using
            %
            %      st = scitran('instanceName');
            %
            % See https://github.com/scitran/client/wiki for installation
            % and usage
            %
            % Examples:
            %
            %   st = scitran('scitran','action','create');
            %   st = scitran('scitran','action','refresh');
            %   st = scitran('scitran','action','remove');
            % 
            % BW Copyright Scitran Team, 2017
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.addRequired('instance', @ischar);
            actions = {'create','refresh','remove'};
            p.addParameter('action','create',@(x)(ismember(x,actions)));
            
            p.parse(instance,varargin{:});
            action = p.Results.action;
            
            authAPIKey(obj,instance,varargin{:});
            
            % Create the Flywheel SDK object
            % Flywheel uses a ':' where we have a space ' ' in the token.
            % Let's change that.
            if strcmp(action,'create')
                obj.fw = Flywheel(obj.showToken);
            end
            
        end
        
        function val = showToken(obj)
            % If you really need to see it, use this.
            % The get.token syntax doesn't run now because get() is a
            % command to get a file from the site.  Maybe that should be
            % changed. 
            val = obj.token;
        end
    end
    
    methods (Static)
        
        function val = listInstances
            % Show the instances you have saved
            stDir = fullfile(getenv('HOME'), '.stclient');
            tokenFile = fullfile(stDir, 'st_tokens');
            val = jsonread(tokenFile);
            
            % TODO Make a nicer print out of this
            disp(val)
        end
            
    end   

end