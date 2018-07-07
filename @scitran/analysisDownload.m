function destination = analysisDownload(obj,id,varargin)
% Download a Flywheel object
%
%   tarFile = scitran.analysisDownload(id, ...)
%
%
% Required Inputs
%  id  - The Flywheel analysis ID
%
% Optional key/value parameters
%  destination:  full path to file output location (default is a tempdir)
%
% Return
%  destination:  Full path to the file object on disk
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
  fName = st.analysisDownload(id);  
%}


%% Parse inputs
varargin = stParamFormat(varargin);

p = inputParser;
p.addRequired('id',@ischar);

% Param/value pairs
p.addParameter('destination','',@ischar)
p.addParameter('inout','output',@ischar);

p.parse(id,varargin{:});

id            = p.Results.id;
destination   = p.Results.destination;

if isempty(destination)
    % Maybe we should get the analysis label
    destination = fullfile(pwd,sprintf('Flywheel-analysis-%s.tar',id));
end

%% Make the flywheel sdk call
% Guessing about the parameters
params = struct('optional', false, ...
    'nodes', ...
    { struct('level', 'analysis', 'id', id) });
        
summary = obj.fw.getAnalysisOutputDownloadTicket(id);

end

