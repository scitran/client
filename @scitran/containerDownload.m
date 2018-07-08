function destination = containerDownload(obj,containertype,containerid,varargin)
% Download a Flywheel container to a local tar-file
%
%  tarFile = scitran.containerDownload(containerType, containerID, varargin)
%
% When the tar-file is unpacked, the directory structure reflects the
% Flywheel organization.  The top directory is the group name, then
% container directories.  Files are within the appropriate container.
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
%  destination:  full path to tarfile location. THe default is
%      fullfile(pwd,sprintf('Flywheel-%s-%s.tar',containerType,id));
%
% Return
%  tarFile:  Full path to the file object on disk
%
% LMP/BW Vistasoft Team, 2015-16
%
% See also: 
%   s_stFileDownload, scitran.fileDelete, scitran.fileDownload

% Examples:
%{
  st = scitran('stanfordlabs');
  acq = st.search('acquisition',...
    'project label contains','SOC',...
    'session label exact','stimuli');
  id = idGet(acq{1}'data type','acquisition');
  fName = st.containerDownload('acquisition',id);  
  delete(fName);
%}

%% Parse inputs
varargin = stParamFormat(varargin);

p = inputParser;
p.addRequired('containertype',@ischar);
p.addRequired('containerid',@ischar);

% Param/value pairs
p.addParameter('destination','',@ischar)

p.parse(containertype,containerid,varargin{:});

containerType = p.Results.containertype;
id            = p.Results.containerid;
destination   = p.Results.destination;

if isempty(destination)
    destination = fullfile(pwd,sprintf('Flywheel-%s-%s.tar',containerType,id));
end

%% Make the flywheel sdk call

% Sets up the parameters for creating a ticket and doing the download
% as a tar file.
switch(containerType)
    case 'project'
        params = struct('optional', false, ...
            'nodes', ...
            { struct('level', 'project', 'id', id) });
    case 'session'
        % Download a session as a tar file
        params = struct('optional', false, ...
            'nodes', ...
            { struct('level', 'session', 'id', id) });
        
    case 'acquisition'
        % An acquisition within a session
        params = struct('optional', false, ...
            'nodes', ...
            { struct('level', 'acquisition', 'id', id) });
                
    % Some of these might be implemented.  But ...
    case 'collection'
        disp('collection NYI')
    case 'analysisacquisition'
        disp('analysisacquisition NYI')
    case 'analysiscollection'
        disp('analysiscollection NYI')
    otherwise
        error('Unknown container download type %s \n',containerType);
end

% Get the ticket and then do the download
summary = obj.fw.createDownloadTicket(params);
obj.fw.downloadTicket(summary.ticket, destination);

end

