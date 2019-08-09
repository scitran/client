function destination = containerDownload(st,container,varargin)
% Download a Flywheel container to a local tar-file
%
% Syntax
%  tarFile = scitran.containerDownload(container, varargin)
%
% Description
%  When the tar-file is unpacked, the directory structure reflects the
%  Flywheel organization.  The top directory is the group name, then
%  container directories.  Files are within the appropriate container.
%
%    Group Name
%     Project Name
%      Session Name
%       Acquisiton Name
%        file list
%        ...
%
% Inputs
%  containertype  - The Flywheel container type (project,session,acquisition ...)
%  containerid    - The Flywheel container ID, usually obtained from a search
%
% Optional Key/Val parameters
%  destination:  full path to tarfile location. The default is
%      
%       fullfile(pwd,sprintf('Flywheel-%s-%s.tar',containerType,id));
%
% Return
%  tarFile:  Full path to the file object on disk
%
% LMP/BW Vistasoft Team, 2015-16
%
% See also: 
%   s_stFileDownload, scitran.fileDelete, scitran.fileDownload
%
% TODO - Ask Justin E about the struct for analysis and collection params
% for download. We need examples for analysis-acquisition,
% analysis-collection, stuff like that.

% Examples:
%{
  st = scitran('stanfordlabs');
  acq = st.search('acquisition',...
      'project label contains','SOC',...
      'session label exact','stimuli');
  st.containerDownload(acq{1});
%}
%{
  project = st.lookup('wandell/SOC ECoG (Hermes)');
  session = project.sessions.findOne('label=stimuli');
  acq = session.acquisitions();
  st.containerDownload(acq{1});
%}

%% Parse

varargin = stParamFormat(varargin);

p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
vFunc = @(x)(strncmp(class(x),'flywheel',8));
p.addRequired('container',vFunc);
p.addParameter('destination','',@ischar);

p.parse(st,container,varargin{:});

cType = strsplit(class(container),'.');

if strncmp(cType{3},'Search',6)
    containerC{1} = container;
    containerC = st.search2container(containerC);
    container = containerC{1};
end

destination = p.Results.destination;
if isempty(destination)
    destination = fullfile(pwd,sprintf('%s-%s.tar',container.label,container.id));
end

%% If the container is a search response, convert it to an container

status = container.downloadTar(destination);

if isempty(status), error('Download error'); end


end

