classdef toolboxes < handle
    % Class to manage toolboxes and the Matlab path.
    %
    % Most Matlab functions or scripts on Flywheel rely on toolboxes. A
    % *toolboxes* object can be used in the Matlab script to automate the
    % download of the necessary repositories for the user.
    %
    % At this moment, all of the downloads are github downloads. But this
    % might become more general in the future.
    %
    % Information about the downloads of individual or groups of toolboxes
    % is stored in json files.  We expect that the json file will also be
    % stored on the Flywheel project as an attachment.
    %
    % Examples:
    %  tbx = toolboxes;   % An empty class.
    %  
    % Constructs from multiple toolboxes
    %  tbx = toolboxes({'vistasoft','jsonio','dtiError'});
    %  tbx.saveinfo;
    %
    % One file containing the multiple toolboxes
    %  tbx = toolboxes({'vistasoft_jsonio_dtiError'});
    %  tbx.install();
    %
    % See also:  s_tbxSave
    %
    % BW Scitran Team, 2017
    
    properties (SetAccess = public, GetAccess = public)
        
        names   = {};         % Names of toolboxes
        testcmd = {};      % Matlab command to test for presence on path
        
        % System command to pull the toolbox
        getcmd  = {};
        tbxdirectory = {}; % Destination directory for the toolbox
        
    end
    
    % Methods (public)
    methods
        
        %% Constructor
        function obj = toolboxes(varargin)
            % toolbox({'names', ...})
            %
            % Read the JSON files specifying the toolbox test and get
            % commands, loads them into the toolbox object.
            %
            % Example:
            %   tbx = toolbox({'scitranClient','jsonio','vistasoft'});
            %   tbx.install;
            %
            if isempty(varargin), return;
            else,                 names = varargin{1};
            end
            
            % Deal with the whole list.
            nTbx = length(names);
            for ii=1:nTbx
                fname = fullfile(stRootPath,'data',[names{ii},'.json']);
                info = jsonread(fname);
                for jj=1:length(info)
                    obj.names{end+1}        = info(jj).names;
                    obj.testcmd{end+1}      = info(jj).testcmd;
                    obj.getcmd{end+1}       = info(jj).getcmd;
                    obj.tbxdirectory{end+1} = info(jj).tbxdirectory;
                end
            end
        end
        
        %% Perform the installation
        function install(tbx)
            % Install all of the toolboxes
            nTbx = length(tbx.names);
            for ii=1:nTbx
                thisTestCmd = which(tbx.testcmd{ii});
                if isempty(thisTestCmd)
                    % This should be updated to a window that selects the
                    % directory, starting with the current directory.
                    fprintf('Installing in directory %s\n',pwd);
                    fprintf('<Return> to continue: ');     pause
                    fprintf('\n');
                    status = system(tbx.getcmd{ii});
                    if status
                        error('Get command for %s failed\n',tbx.name{ii});
                    end
                    addpath(genpath(tbx.tbxdirectory{ii}));
                    gitRemovePath;
                else
                    fprintf('Toolbox %s - found on path\n',tbx.names{ii});
                end
            end
        end
        
        %% Write out the json with instructions to load all the toolboxes
        function saveinfo(obj,varargin)
            
            p = inputParser;
            vFunc = @(x)(exist(x,'dir'));
            p.addParameter('savedir',fullfile(stRootPath,'data'),vFunc);
            p.parse(varargin{:});
            savedir = p.Results.savedir;
            
            % Create the struct for all the toolboxes
            info = struct('names',obj.names,...
                'testcmd',obj.testcmd,...
                'getcmd',obj.getcmd,...
                'tbxdirectory',obj.tbxdirectory);
            
            % Build the name
            name = obj.names{1};
            if length(obj.names) > 1
                for ii=2:length(obj.names)
                    name = [name,'_',obj.names{ii}]; %#ok<AGROW>
                end
            end
            
            % Write the struct as a JSON file
            jsonwrite(fullfile(savedir,[name,'.json']),info);
        end
    end
    
end
