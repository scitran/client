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
    %  tbx = toolboxes('scitran',st,'file',fileStruct);
    %
    % One file containing the multiple toolboxes
    %  tbx = toolboxes({'vistasoft_jsonio_dtiError'});
    %  tbx.install();
    %
    % See also:  s_tbxSave
    %
    % BW Scitran Team, 2017
    %
    % PROGRAMMING TODO
    %   Change the install method a bit, see below
    
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
            % toolbox({'scitran',st,'fileStruct',fileS})
            %
            % Constructor
            %   Reads the JSON file specifying the toolbox either stored on
            %   the scitran set or locally. 
            %
            % Example:
            %   tbx = toolboxes('file',fullfile(stRootPath,'data','vistasoft.json'));
            %   tbx = toolboxes('file',fullfile(stRootPath,'data','vistasoft_jsonio_dtiError.json'));
            %   tbxFile = st.search('files','project label contains','Diffusion Noise', 'file name contains','toolboxes.json');
            %   tbx = toolboxes('scitran',st,'file',tbxFile{1});
            %
            %   tbx.install;
            %
            % BW, Scitran Team, 2017
            
            %% A local JSON file, a scitran JSON file, or empty
            
            p = inputParser;
            vFunc = @(x)(isequal(class(x),'scitran'));
            p.addParameter('scitran',[],vFunc);
            
            vFunc = @(x)(isstruct(x) || ischar(x));
            p.addParameter('file',[],vFunc);
            
            p.parse(varargin{:});
            file    = p.Results.file;
            scitran = p.Results.scitran;
            
            %% Fill the object with the file information
            if isempty(file)
                % No file, so return an empty structure
                return;
            elseif isempty(scitran) && ischar(file)
                % Read a local file
                obj.read(file);
            elseif ~isempty(scitran)
                % file is a cell or a plink, get it and read it
                destination = scitran.get(file);
                obj.read(destination);
                delete(destination);
            end
                        
        end
        
        %% Read JSON files
        function obj = read(obj,file)
        % Append JSON file data to the object
        
        % Read the file information
        info = jsonread(file);
        
        % Append the information to the object
        for jj=1:length(info)
            obj.names{end+1}        = info(jj).names;
            obj.testcmd{end+1}      = info(jj).testcmd;
            obj.getcmd{end+1}       = info(jj).getcmd;
            obj.tbxdirectory{end+1} = info(jj).tbxdirectory;
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
                    
                    % We should move the directory to its tbxdirectory name
                    % HERE, then change into it and add
                    % chdir(fullfile(pwd,tbxdirectory{ii}))
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
