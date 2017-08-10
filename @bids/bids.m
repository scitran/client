classdef bids < handle
    % Brain Imaging Data Structure
    %
    % Bids class to read and validate the directory tree and files, and
    % then the file contents.  
    %
    % The BIDS data themselves need to be organized in place by the user on
    % the local disk.  If they are BIDS compliant, then we can upload them
    % to a Flywheel database.  If they are on a Flywheel database, we can
    % download them to a BIDS compliant directory tree.
    %
    % Example:
    %   thisBids = bids(fullfile(stRootPath,'local','BIDS-examples','ds001'));
    %   thisBids.participants;
    %
    % DH/BW Scitran Team, 2017
     
    properties (SetAccess = public, GetAccess = public)

        directory = '';        % Root directory
        nParticipants = 0;     % Number of participants
        nSessions = [];        % Vector of nSessions for each participant

        % All files and folders are specified relative to the root directory
        %
        % These are paths to files.  We store these paths relative to the
        % root directory.  So to see the fullpath we would use, as an
        % example
        %
        %    fullfile(directory,projectMeta{1});
        %    fullfile(directory,subjectData(1).session(1).anat);
        %    fullfile(directory,projectMeta{1});
        %

        % Cell array of relative paths to each subject folder.  Subject
        % folders always start with sub-
        subjectFolders = '';   % Cell array full paths of subject folder names
        
        % Struct array with format
        %
        %   subjectData(ss).session(nn).<dataType> 
        %
        % is a cell array to the dataType files in the nn^th session for
        % the ss^th subject.  
        subjectData = '';      
        
        % Cell arrays with the relative file paths to these project,
        % subject or session level metadata.  
        projectMeta = '';      % Cell array with metadata at the project level
        subjectMeta = '';      % Cell array with metadata for each participant
        sessionMeta = '';      % Cell array with metadata for each participant/session
        
    end
    
    % Methods (public)
    methods
        
        function obj = bids(directory,varargin)
            % The constructor - builds the bids object
            p = inputParser;
            p.addRequired('directory',@(x)(exist(x,'dir')));
            p.parse(directory,varargin{:});
            
            chdir(directory);
            obj.directory = directory;
            
            % Read the directory through and store the stuff we will need
            % for uploading
            %
            obj.participants;

            % Add folder for each participant
            obj.subjFolders;
            
            obj.checkSessions([]);
            
            % Add data directories and files for each subject
            obj.subjData;
           
            % To see the allowable data types
            % b.dataTypes
            
            % Auxiliary files in the root directory
            % JSON and TSV files
            obj.metaDataFiles;

            % Test whether data exist
            obj.doDataExist;

            % We need one of these
            % obj.validate
            
        end
        
    end
    
    methods (Static)
        
        function val = dataTypes
            % Maintain the list of allowable folder names for different data
            % types.
            val = {'anat','func','eeg','meg','dwi','ieeg','derivatives','pet','fmap'};
        end
    end
    
    
end

