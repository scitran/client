classdef scitran < handle
    % Scitran object to interact with the Flywheel instance via the SDK
    %
    %   st = scitran(instance,'action',...)
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
    %    scitran('stanfordlabs','action','refresh')
    %    scitran('stanfordlabs','verify',true);
    %
    % LMP/BW Vistasoft Team, 2016
    
    properties (SetAccess = private, GetAccess = public)  

    url = '';              % URL to the website
    instance = 'scitran';  % Name of the instance
    
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
            %   st = scitran('stanfordlabs','action','create');
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
                try
                    obj.fw = flywheel.Flywheel(obj.showToken);
                catch
                    % If the rest-client.jar was already on the path, you
                    % receive a warning that the RestClient class exists
                    % and java will not be cleared.  That shouldn't happen
                    % here, however.
                    disp('Adding rest-client.jar to java path')
                    apiPath = fileparts(fileparts(which('flywheel.Flywheel')));
                    apiFile = fullfile(apiPath,'api','rest-client.jar');
                    javaaddpath(apiFile);
                    obj.fw = flywheel.Flywheel(obj.showToken);
                end
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