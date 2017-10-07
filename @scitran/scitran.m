classdef scitran < handle
    % Scitran object to interact with a scitran database
    %
<<<<<<< HEAD
    %   st = scitran(instance,'action',...,'verify',...)
    %
    %  'instance' -  String denoting the st instance to authorize
    %
    % Param/Value:
    %       
    %  'actions'  - {'create', 'refresh', 'remove'}
    %  'verify'   - performs a search to verify validity.
=======
    %   st = scitran('instance','action',...)
>>>>>>> a1ff6c219adaa2f736086412eef6bd391b3201d0
    %
    % Required
    %  'instance' -  String denoting the site to look up in your
    %                database and authorize.  In the special case that
    %                instance is set to 'list', the sites in your
    %                database are listed.
    %
    % Parameter/Value
    %  'action'  - {'create', 'refresh', 'remove'}
    %
    % See https://github.com/scitran/client/wiki
    %
    % Examples:
    %
    %    scitran('vistalab','action','refresh')
    %    scitran('vistalab','verify',true);
    %
    % LMP/BW Scitran Team, 2016
    
    properties (SetAccess = private, GetAccess = public)  

    url = '';
    instance = 'scitran';
    
    % We are storing the Flywheel object within the scitran object.
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
            %   st = scitran('vistalab','action','create');
            %   st = scitran('cni','action','refresh');
            %   st = scitran('cni','action','remove');
            %
            % % There is a special case for just listing the entries
            % % of your local scitran database.  Set instance to list.
            %
            %   scitran('list');    % Lists the instances in your database
            % 
            % BW Copyright Scitran Team, 2017
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.addRequired('instance', @ischar);
            actions = {'create','refresh','remove'};
            p.addParameter('action','create',@(x)(ismember(x,actions)));
            
            p.parse(instance,varargin{:});
            action = p.Results.action;
            
            if ismember(instance,{'dir','list','ls'})
                fprintf('\nStored Flywheel site names\n');
                fprintf('----------------------------\n');
                obj.listInstances;
                obj.instance = 'listing only';
                return;
            end
            
            authAPIKey(obj,instance,varargin{:});
            
            % Create the Flywheel SDK object
            % We do this for create or refresh, but not for remove.
            if strcmp(action,'create') || strcmp(action,'refresh')
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