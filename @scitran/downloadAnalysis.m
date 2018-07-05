function destination = downloadAnalysis(obj,id,varargin)
% Download a Flywheel object
%
%   tarFile = scitran.downloadAnalysis(id, ...)
%
%
% Required Inputs
%  containertype  - The Flywheel container type (project,session,acquisition ...)
%  containerid    - The Flywheel container ID, usually obtained from a search
%
% Optional Inputs
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
  acq = st.search('analysis',...
    'project label contains','SOC',...
    'session label exact','stimuli');
  id = idGet(acq{1});
  fName = st.downloadAnalysis('acquisition',id);  
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

% Guessing about the parameters
params = struct('optional', false, ...
    'nodes', ...
    { struct('level', 'analysis', 'id', id) });
        
%% Make the flywheel sdk call
summary = obj.fw.getAnalysisOutputDownloadTicket(id);

end

