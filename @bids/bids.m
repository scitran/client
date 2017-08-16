classdef bids < handle
    % Brain Imaging Data Structure
    %
    % Bids class to read and validate the directory tree and files, and
    % then the file contents.  We refer to a particular instance of a bids
    % class as @bids.
    %
    % The BIDS data need to be organized in place by the user on the local
    % disk prior to upload.  If they are BIDS compliant, then we can upload
    % them to a Flywheel database.  If they are on a Flywheel database, we
    % can download them to a BIDS compliant directory tree.
    %
    % Meta data files and folders are specified relative to the root directory
    %
    % These are paths to files.  We store these paths relative to the root
    % directory.  In general, to see the fullpath use something like
    %
    %    fullfile(directory,projectMeta{1});
    %    fullfile(directory,projectMeta{1});
    %
    % To find a specific data filename in a bids object use this syntax.
    % Note the array of structs () and the array of cells {}.
    %
    %   ii = subject, jj = session, and kk = file 
    %   fileName = @bids.subjectData(ii).session(jj).dataType{kk}
    %   fullfile(directory,fileName);
    %
    % To validate use: @bids.dataCheck;
    %
    % To see the allowable data types: @bids.dataTypes
    %
    % Example:
    %   thisBids = bids(fullfile(stRootPath,'local','BIDS-examples','ds001'));
    %   thisBids.participants;
    %
    % DH/BW Scitran Team, 2017
    
    properties (SetAccess = public, GetAccess = public)
        
        directory = '';        % Root directory
        nSessions = [];        % Vector of nSessions for each participant
        
        % Cell array of relative paths to each subject folder.  Subject
        % folders always start with sub-
        subjectFolders = '';   % Cell array of paths to subject folder names
        
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
            
            % chdir(directory);
            obj.directory = directory;
            
            % Add folder for each participant
            obj.subjFolders;
            
            obj.countSessions;
            
            % Add data directories and files for each subject
            obj.subjData;
            
            % Auxiliary files in the root directory
            % JSON and TSV files
            obj.metaDataFiles;
            
        end
    
        function n = nParticipants(obj)
            % Quality of life
            n = length(obj.subjectFolders);
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

