function analysisInfo = analysisInfoSet(obj,id,info)
% Get the analysis information container
%
% Syntax
%    analysisInfo = analysisInfoSet(obj,id,info)
%    st.analysisInfoSet(id,info);
%
% Description
%
% Inputs
%
% Optional key/value pairs
%
% Outputs
%
%
% BW Vistasoft 2019
%
% See also
%  

%% Simple call, just some parameter checking
p = inputParser;
p.addRequired('obj',@(x)(isa(obj,'scitran')));
p.addRequired('id',@ischar);
p.addRequired('info',@isstruct);

%{
info = struct('some_key', 'somevalue', 'another_key', 10);
fw.setAnalysisInfo(analysisId, info);
%}
%%
analysisInfo = obj.fw.setAnalysis(id,info);

end

