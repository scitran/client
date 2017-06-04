classdef stanalysis < handle
    % Class to manage scitran analyses
    %
    % We store information about an analysis in this object.  We then
    % upload the result to the scitran site.  Maybe this way?
    %
    %    (st.put('analysis',stanalysis,'project',...,'session',...))
    %
    %
    % BW Scitran Team, 2017

    
    properties (SetAccess = public, GetAccess = public)
        
        name   = {};         % Names of toolboxes

        
    end
    
    % Methods (public)
    methods
        
        %% Constructor
        function obj = stanalysis(varargin)
            % Constructor for the stanalysis object
            %  
            %   stanalysis({'name','scitran',...,
            %       'inputs',...,'outputs',...,
            %       'function',...,'params',...)
            %
            % Parameters
            %   scitran
            %   inputs
            %   outputs
            %   
            %
            % Example:
            %   stanalysis = st.runFunction(funcName,params);
            %   st.put('analysis',stanalysis,'project',...,'session',...,'collection',...)
            %
            % BW, Scitran Team, 2017
            
            
                        
        end
        
        %% Read analysis file into this object
        function obj = read(obj,file)
            
            
        end
        
       
        %% Write out the analysis file as a JSON?
        function saveinfo(obj,varargin)
            % savedir  - Default is scitran/data
            % filename - Such as toolboxes
            
            
        end
    end
    
end
