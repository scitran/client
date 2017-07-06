classdef toolboxes < handle
    % Class to manage toolboxes and the Matlab path.
    %
    % Most Matlab functions or scripts rely on a set of toolboxes. A
    % *toolboxes* object automates the process of downloading and
    % installing the toolboxes on the user's path.
    %
    % Information about the downloads of individual or groups of toolboxes
    % is stored in JSON files.  The JSON file can be stored on the Flywheel
    % (scitran) project as an attachment. At this moment, all of the
    % scitran downloads are github downloads.
    %
    % Examples:
    %
    %  tbx = toolboxes;   % An empty toolboxes class.
    %  
    % Set up the toolboxes object from a file on a scitran site
    %   st = scitran('vistalab');
    %   tbxFile = st.search('files','project label','SOC ECoG (Hermes)','filename','toolboxes.json');
    %   tbx = toolboxes('scitran',st,'file',tbxFile{1});
    % 
    % Read a local file
    %   tbx = toolboxes('file','vistasoft.json');
    %
    % A simple method using only the scitran client object.
    %
    %   tbxFile = st.search('files',...
    %     'project label','EJ Apricot',...
    %     'file name','toolboxes.json');
    %
    % This method downloads and installs if the repository is not already on
    % the path. The default method is download, but you can clone by
    % setting this flag
    %
    %    st.toolbox(tbxFile{1},'clone',true);
    %
    % See also:  s_tbxSave
    %
    % BW Scitran Team, 2017
    
    properties (SetAccess = public, GetAccess = public)
        
        name    = '';      % Name of the toolbox
        testcmd = '';      % Matlab command to test for presence on path
        
        % The type of download.  Clone or zip.
        getcmd  = 'zip';      
        
        % The information we need to build the clone or zip download command
        % The fields should be
        %  user, project, commit {sha, or 'master'}
        gitrepo    = struct('user','','project','','commit','master');

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
                % Read a local file and fill the entries
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
                obj.name      = info.name;
                obj.testcmd   = info.testcmd;
                obj.getcmd    = info.getcmd;
                obj.gitrepo   = info.gitrepo;  % User and archive
            end
            
        end
        
        %% Write out the json with instructions to load all the toolboxes
        function outfile = saveinfo(obj,varargin)
            % savedir  - Default is scitran/data
            % filename - Such as toolboxes
            
            p = inputParser;
            vFunc = @(x)(exist(x,'dir'));
            p.addParameter('savedir',fullfile(stRootPath,'data'),vFunc);
            p.addParameter('filename',[],@ischar);
            p.parse(varargin{:});
            savedir  = p.Results.savedir;
            filename = p.Results.filename;
            
            % Create the struct for all the toolboxes
            info = struct('name',obj.name,...
                'testcmd',obj.testcmd,...
                'getcmd',obj.getcmd,...
                'gitrepo',obj.gitrepo);
            
            % Build the output filename
            if isempty(filename)
                filename = obj.name;
            end
            
            % Write the struct as a JSON file
            outfile = fullfile(savedir,[filename,'.json']);
            jsonwrite(outfile,info);
        end
    end
    
end
