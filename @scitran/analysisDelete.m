function status = analysisDelete(st,analysis)
% Create an analysis with its parameters
%
% Syntax:
%  status = scitran.analysisDelete(analysis)
%
% Description:
%  Delete an analysis that is part of a project or part of a session.
%
% Inputs
%  analysis:  A Flywheel analysis or cell array of analyses
%
% Optional Key/value pairs
%  N/A
%
% Outputs
%  
% 
% Wandell, SCITRAN Team, 2018
%
% See also
%   scitran.analysisUpload, scitran.analysisDownload,
%   scitran.analysisCreate

% TODO: Deal with the case of a cell array of analyses

%% Set up parameters
p = inputParser;
p.addRequired('analysis',...
    @(x)(isa(x,'flywheel.model.AnalysisOutput') || iscell(x)));
%%
if iscell(analysis)
    for ii=1:length(analysis)
        st.analysisDelete(analysis{ii});
    end
else
    parentID = analysis.parent.id;
    
    switch analysis.parent.type
        case 'session'
            status = st.fw.deleteSessionAnalysis(parentID,analysis.id);
        case 'project'
            status = st.fw.deleteProjectAnalysis(parentID,analysis.id);
        otherwise
            error('Unknown parent type %s\n',analysis.parent.type);
    end
end

end