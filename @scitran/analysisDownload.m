function thisAnalysis = analysisDownload(obj,id,varargin)
% Return the information a Flywheel analysis
%
%   thisAnalysis = scitran.analysisDownload(id, ...)
%
% Required Inputs
%  id  - The Flywheel analysis ID
%
% Optional key/value parameters
%  destination:  full path to file output location (default is a tempdir)
%
% Return
%  thisAnalysis:  Full path to the file object on disk
%
% LMP/BW Vistasoft Team, 2015-16
%
% See also: 
%   s_stDownloadContainer, s_stDownloadFile, scitran.search

% Examples
%{
  st = scitran('stanfordlabs');
  analysis = st.search('analysis',...
    'project label contains','SOC',...
    'session label exact','stimuli');
  id = idGet(analysis{1},'data type','analysis');
  thisAnalysis = st.analysisInfoGet(id);  
%}

%%

% We need to figure out how to download the whole analysis as a tar
% file, or individual input and output files. Examples are in
% FlywheelExamples.m
disp('Analysis download is not yet implemented')

end

%{
%% Parse inputs
varargin = stParamFormat(varargin);

p = inputParser;
p.addRequired('id',@ischar);
p.parse(id,varargin{:});

%% Make the flywheel sdk call

thisAnalysis = obj.fw.getAnalysis(id);

end
%}
