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
        
        st      = [];   % Scitran object to use for put/get
        label   = {};   % Label for this analysis
        
        % Structure describing the method used for analysis.  Could be a
        % docker object.  Or it could be an m-file object describing the
        % code.
        method  = [];   
        
        inputs  = {}    % Cell array of files used as inputs
        params  = [];   % Structure of parameters provided to input
        outputs = {};   % Cell array of output files
        
    end
    
    % Methods (public)
    methods
        
        %% Constructor
        function obj = stanalysis(varargin)
            % stanalysis Constructor
            %  
            %   stan = stanalysis({'name','scitran',...,
            %       'inputs',...,'outputs',...,
            %       'function',...,'params',...)
            %
            % Parameters
            %   label
            %   scitran
            %   inputs
            %   outputs
            %   
            %
            % Example:
            %  Ultimately:
            %   stanalysis = st.runFunction(funcName,params);
            %   st.put('analysis',stanalysis,'project',...,'session',...,'collection',...)
            %
            % BW, Scitran Team, 2017
            
            p = inputParser;
            
            p.addParameter('scitran',[],@(x)(isequal(class(x),'scitran')));
            p.addParameter('label','stanalysis',@ischar);
            p.addParameter('method',[],@isstruct);
            p.addParameter('inputs',{},@iscell);
            p.addParameter('outputs',{},@iscell);

            p.parse(varargin{:});
            
            obj.st      = p.Results.scitran;
            obj.label   = p.Results.label;
            obj.method  = p.Results.method;
            obj.inputs  = p.Results.inputs;
            obj.outputs = p.Results.outputs;

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
