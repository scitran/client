function val = analysisGet(st,thisAnalysis,param)
% Read values from an analysis
%
% Syntax:
%
%    val = analysisGet(st,thisAnalysis,param)
%
% Brief description:
%  An analysis describes the inputs and outputs and parameters of a process
%  Gear or a user-specific analysis. When the analysis is executed as a
%  Gear, it also includes the Job parameters, such as the job state.
%
%  This function simplifies how we read analysis parameters.
%
% Inputs
%  thisAnalysis:  A Flywheel object describing the analysis.  
%           This could be a SearchResponse, a SearchAnalysisResponse, or an
%           ContainerAnalysisOutput, ...
%  param:
%   'container'  - The container metadata
%   'parameters' - parameter names and values
%   'parameter names' - just the names
%   'state' - Complete, or error or something
%   'label - 
%   'id' -  Analysis id
%   'inputs'
%   'outputs'
%   
% Optional key/value pairs
%   N/A
%
% Outputs:
%   The value of the specified parameter
%
% Wandell, Vistasoft, August 25, 2018
%
% See also
%

% Examples:
%{
  st = scitran('stanfordlabs');
  analysisSearch = st.search('analysis',...
    'project label exact','Brain Beats',...
    'session label exact','20180319_1232');

  thisAnalysis = st.analysisGet(analysisSearch{1},'container')
  st.analysisGet(analysisSearch{1},'label')
  st.analysisGet(analysisSearch{1},'job')
  st.analysisGet(analysisSearch{1},'outputs')

%}
%{
  thisAnalysis = st.analysisGet(analysisSearch{1},'container')
  st.analysisGet(thisAnalysis,'job')
%}

%% Make sure we have the right parameters
%  In this case, thisAnalysis might be a search or the actual analysis
%  output.  If it is a search, we get the analysis output.

p = inputParser;
p.addRequired('thisAnalysis');
p.addRequired('param',@ischar);
p.parse(thisAnalysis,param);

%% Make sure thisAnalysis is the full analysis metadata.
fwModel = stModel(thisAnalysis);
switch stParamFormat(fwModel)
    case 'searchresponse'
        % Get the whole analysis output object; the search only returns an
        % abbreviated version because of speed.  Not sure that is a great idea,
        % but ..
        id = st.objectParse(thisAnalysis.analysis);
        thisAnalysis  = st.fw.get(id);
    case 'searchanalysisresponse'
        id = st.objectParse(thisAnalysis);
        thisAnalysis  = st.fw.get(id);
    case {'containeranalysisoutput'}
        thisAnalysis  = st.fw.get(thisAnalysis.id);
    case {'analysisoutput'}
        % This has everything.  Nothing needed.
    otherwise
        error('Could not parse thisAnalysis input type %s.\n',class(thisAnalysis)); 
end


%% Find the parameter

% We leave the actual parameter format in place
switch stParamFormat(param)
    case {'all','container'}
        % This is the whole analysis container
        val = thisAnalysis;
    case {'label'}
        val = thisAnalysis.label;
    case {'id'}
        val = thisAnalysis.id;
        
        % Gear/Jobs related parameters
    case {'job'}
        try    val = thisAnalysis.job;  % There is also a getJobConfig() ....
        catch, disp('The analysis was not run as a Gear (job)');
        end
    case {'parameters','config'}
        % Returns the whole struct of parameters
        try    val = thisAnalysis.job.config.config;
        catch, disp('The analysis was not run as a Gear (job)');
        end
    case {'parameternames','names'}
        % This lists the parameter names
        % st.analysisGet(analysis,'paramnames');
        try val = fieldnames(thisAnalysis.job.config.config);
        catch, disp('The analysis was not run as a Gear (job)');
        end
    case 'inputs'
        try val = thisAnalysis.job.inputs;
        catch, disp('The analysis was not run as a Gear (job)');
        end
    case 'outputs'
        try val = thisAnalysis.job.savedFiles;
        catch, disp('The analysis was not run as a Gear (job)');
        end
    case {'state'}
        % Did the job run correctly?
        try     val = thisAnalysis.job.state;
        catch,  disp('The analysis was not run as a Gear (job)');
        end

    otherwise
        % Check for a analysis-specific parameter value from the config
        % structure 
        try val = thisAnalysis.job.config.config.(param);
        catch
            fields = fieldnames(thisAnalysis.job.config.config);
            disp(fields);
            error('%s  - not found in config parameters (above)',param);
        end
end

end
