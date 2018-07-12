classdef scicli < handle
    % Scitran object to manage the Flywheel CLI
    %
    %   cli = scicli(instance,'action',...)
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
    % See https://github.com/vistasoft/scitran/wiki
    %
    % Examples:
    %
    %    cli = scicli('stanfordlabs'); % Return CLI object
    %    cli.version
    %    cli.status
    %
    %    scicli('stanfordlabs','action','refresh');  % Update CLI key
    %
    % LMP/BW Scitran Team, 2016
    
    properties (SetAccess = private, GetAccess = public)
        
        url      = 'stanfordlabs.flywheel.io';  % Base url of the system
        instance = 'stanfordlabs';              % Name of the system
        cli      = '/usr/local/bin/fw';         % System cli command
        
    end    % Data stuff (public)

    properties (SetAccess = private, GetAccess = private)
        % This is the private token that is used to login on start
        token = '';
    end    

    % Methods (public)
    methods
        
        function obj = scicli(instance,varargin)
            % Command line interactions with a Flywheel instance.
            %
            % This constructor creates the scitran object and authorizes
            % secure interactions with the Flywheel instance. The url of
            % the instance and the user's security token for that instance
            % are stored locally.
            %
            % The constructor can be invoked using
            %
            %      st = scicli('instanceName');
            %
            % See https://github.com/scitran/client/wiki for installation
            % and usage
            %
            % Examples:
            %
            %   st = scicli('stanfordlabs','action','create');
            %   st = scicli('cni','action','refresh');
            %   st = scicli('cni','action','remove');
            %
            %   scitran('list');    % Lists the instances in your database
            % 
            % BW Copyright Vistasoft Team, 2017
            
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
                obj.fw = flywheel.Flywheel(obj.showToken);
            end
            
        end
        
        function val = showToken(obj)
            % If you really need to see it, use this.
            % The get.token syntax doesn't run now because get() is a
            % command to get a file from the site.  Maybe that should be
            % changed. 
            val = obj.token;
        end
        
        function API(obj,varargin)
            % Open up a web browser to the Flywheel API calls.
            p = inputParser;
            p.addRequired('obj',@(x)isa(x,'scitran'));
            p.addParameter('url',...
                'https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html',...
                @ischar);
            p.parse(obj,varargin{:});
            urlapi = p.Results.url;
            web(urlapi,'-browser');
        end
    end
    
    methods (Static)
        
        function val = listInstances
            % Show the Flywheel instances that are saved in .stclient
            stDir = fullfile(getenv('HOME'), '.stclient');
            tokenFile = fullfile(stDir, 'st_tokens');
            val = jsonread(tokenFile);
            
            names = fieldnames(val);
            for ii=1:length(names)
                if ~strcmp(names{ii},'url') && ~strcmp(names{ii},'token')
                    fprintf('\t%s \n',names{ii});
                end
            end
            
        end
            
    end   

end