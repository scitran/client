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
    % DH/BW Scitran Team, 2017
     
    properties (SetAccess = public, GetAccess = public)

        projectName = '';      
        
        % The information we need to build the clone or zip download command
        % The fields should be
        %  user, project, commit {sha, or 'master'}
        participants = '';
        
    end
    
    % Methods (public)
    methods
    end
    
end

