classdef toolboxes < handle
    % Class to manage toolboxes and the Matlab path.
    %
    % When we download a Matlab function from Flywheel, the function may
    % rely on toolboxes.  The toolbox object can be placed in the Matlab
    % script to automate the download of the necessary repositories.  We are
    % working with a general model, but for now all of the instances are
    % github downloads.
    %
    % Information about critical downloads should be stored in json files
    % on the user's path.  Maybe these should be stored on the Flywheel
    % site in parallel to the script, as part of the project?  TBD.
    %
    % Examples:
    %  tbx = toolboxes;
    %  tbx.saveinfo('vistasoft','vistaRootPath','git clone https://github.com/vistalab/vistasoft','/user/wandell/github');
    %  tbx = toolboxes({'vistasoft'});
    %  tbx.install();
    %
    %  tbx = toolboxes({'vistasoft','scitran','jsonio'});
    %  tbx.install;
    %
    % BW Scitran Team, 2017
    
    properties (SetAccess = private, GetAccess = public)
        
        names   = {''};      % Names of toolboxes
        testcmd = {''};      % Matlab command to test for presence on path
        getcmd  = {''};      % System command to pull the toolbox
        tbxdirectory = {''}; % Destination directory for the toolbox
        
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
            
            % Fill in the best we can.
            obj.names = names;
            nTbx = length(names);
            obj.testcmd = cell(1,nTbx);
            obj.getcmd  = cell(1,nTbx);
            for ii=1:nTbx
                fname = [names{ii},'.json'];
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
        
        function saveinfo(~,name,testcmd,getcmd,tbxdirectory)
            % Save the json file for a toolbox
            savedir = fullfile(stRootPath,'data');
            info.name = name; info.testcmd = testcmd;
            info.getcmd = getcmd; info.tbxdirectory = tbxdirectory;
            jsonwrite(fullfile(savedir,[name,'.json']),info);
        end
    end 
    
end
