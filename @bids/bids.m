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

        directory = '';        % Home directory
        nParticipants = 0;     % Number of participants
        subjectFolders = '';   % Cell array full paths of subject folder names
        nSessions = [];        % Vector of nSessions for each participant
        subjectData = '';      % Struct array with dataType.fileNames for each subject/session
        projectMeta = '';      % Cell array with metadata at the project level
        subjectMeta = '';      % Cell array with metadata for each participant
        sessionMeta = '';      % Cell array with metadata for each participant/session
        url = '';
        
    end
    
    % Methods (public)
    methods
        
        function obj = bids(directory,varargin)
            % The constructor - builds the bids object
            p = inputParser;
            p.addRequired('directory',@(x)(exist(x,'dir')));
            p.addParameter('url',[],@ischar);
            p.parse(directory,varargin{:});
            
            chdir(directory);
            obj.directory = directory;
            obj.url = p.Results.url;
            
            % Read the directory through and store the stuff we will need
            % for uploading
            %
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

