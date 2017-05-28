classdef toolboxes < handle
    % Class to manage toolboxes and the Matlab path.
    %
    % When we download a Matlab function from Flywheel, the always relies
    % on toolboxes, at a minimum it relies on the scitranClient toolbx.  A
    % *toolboxes* object can be used in the Matlab script to automate the
    % download of the necessary repositories for the user.
    %
    % At this moment, all of the downloads are github downloads. But this
    % might be more general in the future.
    %
    % Information about the downloads are stored in json files.  For the
    % moment, these are kept inside of scitran/data. But this makes no
    % sense in the long run. These should be stored on the Flywheel site in
    % parallel to the script, as part of the project.  
    %
    % Examples:
    %  tbx = toolboxes;   % Always have the scitran toolbox
    %
    %  tbx.saveinfo('vistasoft','vistaRootPath','git clone https://github.com/vistalab/vistasoft','/user/wandell/github');
    %  tbx = toolboxes({'vistasoft'});
    %  tbx.install();
    %
    %  tbx = toolboxes({'vistasoft','jsonio'});
    %  tbx.install;
    %
    % BW Scitran Team, 2017
    
    properties (SetAccess = private, GetAccess = public)
        
        names   = {'scitranClient'};         % Names of toolboxes
        testcmd = {'stRootPath'};      % Matlab command to test for presence on path
        
        % System command to pull the toolbox
        getcmd  = {'git clone https://github.com/scitran/client'};      
        tbxdirectory = {pwd}; % Destination directory for the toolbox
        
    end

    % Methods (public)
    methods
        
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
            
            % Add the additional names
            newNames = cell(1,length(names)+1);
            newNames{1} = obj.names{1};
            for ii=1:length(names)
                newNames{ii+1} = names{ii};
            end
            obj.names = newNames;
            
            % Deal with the whole list.
            nTbx = length(obj.names);
            for ii=1:nTbx
                fname = fullfile(stRootPath,'data',[obj.names{ii},'.json']);
                info = jsonread(fname);
                
                obj.testcmd{ii}      = info.testcmd;
                obj.getcmd{ii}       = info.getcmd;
                obj.tbxdirectory{ii} = info.tbxdirectory;
            end
        end 
        
        % Perform the installation
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
        
        % Used to write out the json files in the right format.  See
        % s_tbxSave.m
        function saveinfo(~,name,testcmd,getcmd,tbxdirectory)
            % Save the json file for a toolbox
            savedir = fullfile(stRootPath,'data');
            info.name = name; info.testcmd = testcmd;
            info.getcmd = getcmd; info.tbxdirectory = tbxdirectory;
            jsonwrite(fullfile(savedir,[name,'.json']),info);
        end
    end 
    
end
