function analysisInfo = analysisInfoGet(obj,id)
% Get the analysis information container
%
% BW Vistasoft 2019

% We might want to let the input be an analysis structure.
analysisInfo = obj.fw.getAnalysis(id);

end

