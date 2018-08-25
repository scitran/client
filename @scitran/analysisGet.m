function val = analysisGet(st,thisAnalysis,param)
% Retrieve value of gear parameters from an analysis object
%
%    val = analysisGet(st,thisAnalysis,param)
%
% Brief description
%  An analysis describes what happened when we run a Gear.  This includes
%  the inputs, outputs, and the configuration of the gear parameters.  The
%  analysis object is rather complex, and this function tries to simplify
%  how we access specific parameters that were set when the gear was run
%  (i.e., the job).
%
% Inputs
%  thisAnalysis:  SearchResponse to an analysis, or the
%       SearchAnalysisResponse, or an AnalysisOutput 
%  param:  
%   'all'
%   'list'
%   'param' - a string defining the a parameter in the gear configuration
%
% Optional
%   N/A
%
% Returns
%   Either the names ('list'), a struct of all the parameter ('all') or the
%   value of one of the parameters
%
% Examples
%
% Wandell, Vistasoft, August 25, 2018
%
% See also
%

%% Make sure we have the right parameters
%  In this case, thisAnalysis might be a search or the actual analysis
%  output.  If it is a search, we get the analysis output.

if notDefined('thisAnalysis'), error('analysis required');
elseif isa(thisAnalysis,'flywheel.model.SearchResponse')
    % Get the actual analysis output object based on the search.
    id = st.objectParse(thisAnalysis.analysis);
    thisAnalysis  = st.fw.getAnalysis(id);
elseif isa(thisAnalysis,'flywheel.model.SearchAnalysisResponse')
    id = st.objectParse(thisAnalysis);
    thisAnalysis  = st.fw.getAnalysis(id);
elseif isa(thisAnalysis,'flywheel.model.AnalysisOutput')
    % Nothing needed
else
    error('First argument must be a SearchResponse or AnalysisOutput');
end

% param is a string
if     notDefined('param'), error('param required.');
elseif ~ischar(param),      error('param must be a string.');
end

% We leave the actual parameter format in place
switchparam = stParamFormat(param);

%% Find the parameter

switch switchparam
    case {'config','all'}
        % Returns the whole struct of parameters
        val = thisAnalysis.job.config.config;
    case {'parameternames','names','list'}
        % This lists the parameter names
        % st.analysisGet(analysis,'paramnames');
        val = fieldnames(thisAnalysis.job.config.config);
    case {'job'}
        idJOB = st.objectParse(thisAnalysis.job);
        val = st.fw.getJob(idJOB);  % There is also a getJobConfig() ....
        % There is also a getJobConfig() .... but it I sent an error
        % message to Justin about this
        % j = st.fw.getJobConfig(id);  

    otherwise
        % A specific parameter value from the config structure
        try
            val = thisAnalysis.job.config.config.(param);
        catch
            fields = fieldnames(thisAnalysis.job.config.config);
            disp(fields);
            error('Parameter %s not found in config fields (above)',param);
        end    
end

end
