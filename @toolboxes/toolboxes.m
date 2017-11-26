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
        
        testcmd = '';      % Matlab function to test for presence on path 
        
        % The information needed to build the clone or zip download command
        % The fields should be
        %  user, project, commit {sha, or 'master'}
        gitrepo    = struct('user','','project','','commit','master');

    end
    
    % Methods (public)
    methods
        
        %% Constructor
        function obj = toolboxes(file)
            % Create a toolboxes object and initialize with local JSON file
            % or as empty.
            %
            % BW, Scitran Team, 2017
            
            %% file is either a local JSON file or empty
            
            p = inputParser;
            p.addRequired('file',@(x)(isempty(x) || exist(x,'file')));
            p.parse(file);
            
            %% Fill the object with the file information or return empty
            if isempty(file),  return;
            else,              obj.read(file);
            end   

        end
        
        %% Read JSON files
        function read(obj,file)
            
            % Read the json file and return it to a struct array
            tbxStruct = jsonread(file);
            if numel(tbxStruct) > 1
                error('Initialize multiple toolboxes using stToolbox(file);');
            else
                obj.testcmd = tbxStruct.testcmd;
                obj.gitrepo = tbxStruct.gitrepo;
            end
            
        end
        
        %% Write json file with toolbox information
        
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
