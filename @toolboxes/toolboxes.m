classdef toolboxes < handle
    % Class to manage Matlab toolbox dependencies
    %
    % Matlab functions and scripts typically rely on a set of toolboxes.
    % Most of these are provided by Matlab, but a typical project will also
    % build a toolbox of its own.
    %
    % This *toolboxes* object automates the process of downloading and
    % installing the user-specific toolboxes. 
    %
    % Information about the toolboxes is stored in JSON files.  The JSON
    % file can be stored on the Flywheel (scitran) project as an
    % attachment. At this moment, all of the scitran downloads are github
    % downloads.
    %
    % Examples:
    %
    %  tbx = toolboxes;   % An empty toolboxes class.
    %  
    % Set up the toolboxes object from a file on a scitran site
    %
    %   st = scitran('vistalab');
    %   tbxFile = st.search('files','project label','SOC ECoG (Hermes)','filename','toolboxes.json');
    %   tbx = toolboxes('scitran',st,'file',tbxFile{1});
    % 
    % Read a local file and download a shallow clone
    %
    %   tbx = toolboxes('file','WLVernierAcuity.json');
    %   tbx.clone('cloneDepth',1);
    %
    %  Or a particular commit as a zip file
    %   tbx.gitrepo.commit = '5a84c98e969633de853a470c9fa631ef8468b21d';
    %   tbx.install;
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
    % References:
    %   We might try to stay compatible with this
    %
    %   https://github.com/heroku/node-js-sample/blob/master/package.json
    %
    % BW Scitran Team, 2017
    
    properties (SetAccess = public, GetAccess = public)
        

        testcmd = '';      % Matlab command to test for presence on path 
        
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
            %   the scitran site or locally. 
            %
            % Example:
            %   tbx = toolboxes('file',fullfile(stRootPath,'data','vistasoft.json'));
            %
            %   tbxFile = st.search('files',...
            %       'project label contains','Diffusion Noise', ...
            %       'file name contains','toolboxes.json');
            %   tbx = toolboxes('scitran',st,'file',tbxFile{1});
            %
            % Then either
            %   tbx.install;
            % or
            %   tbx.clone( ... )
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
        function read(obj,file)
            
            % Read the json file and return it to a struct
            tbxStruct = tbxRead(file);
            
            % Copy the struct information into the toolbox object
            obj.testcmd = tbxStruct.testcmd;
            obj.gitrepo = tbxStruct.gitrepo;
                      
        end
        
        %% Write out the json with instructions to load the toolbox
        function outfile = saveinfo(obj,varargin)
            % savedir  - Default is scitran/data
            % gitrepo has 'user','project','commit' fields.
            
            p = inputParser;
            vFunc = @(x)(exist(x,'dir'));
            p.addParameter('savedir',fullfile(stRootPath,'data'),vFunc);
            p.parse(varargin{:});
            savedir  = p.Results.savedir;
            
            % Create the struct for all the toolboxes
            info = struct('testcmd',obj.testcmd,...
                'gitrepo',obj.gitrepo);
            info.testcmd = obj.testcmd;
            info.gitrepo = obj.gitrepo;
            
            % Build the output filename            
            outfile = fullfile(savedir,[obj.gitrepo.project,'.json']);
            
            % Write the struct as a JSON file
            jsonwrite(outfile,info);
        end
    end
    
end
