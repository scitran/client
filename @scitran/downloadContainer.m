function destination = downloadContainer(obj,containertype, containerid,varargin)
% Download a Flywheel object
%
%   outfile = scitran.downloadContainer(objectID, ...)
%
% The Flywheel container will be downloaded as a tar file.  When it is
% unpacked, the directory structure is organized as
%
%    Group Name
%     Project Name
%      Session Name
%       Acquisiton Name
%        file list
%        ...
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
%   scitran.search, scitran.deleteFile, scitran.sdownloadFile

% Examples
%{
  st = scitran('stanfordlabs');
  acq = st.search('acquisition',...
    'project label contains','SOC',...
    'session label exact','stimuli');
  id = idGet(acq{1});
  st.downloadContainer('acquisition',id);  
  edit(fName)
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
    case 'session'
        % Download a session as a tar file
        params = struct('optional', false, ...
            'nodes', ...
            { struct('level', 'session', 'id', id) });
        
    case 'acquisition'        
        params = struct('optional', false, ...
            'nodes', ...
            { struct('level', 'acquisition', 'id', id) });
        
    case 'analysissession'
    case 'analysisacquisition'
    case 'analysiscollection'
        
    case 'collection'
        
    otherwise
        error('Unknown container type %s \n',containerType);
end

% Get the ticket and then do the download
summary = obj.fw.createDownloadTicket(params);
obj.fw.downloadTicket(summary.ticket, destination);


%% Verify file size
% We used to allow this.  But I don't really know the size.
% if ~isempty(sz)
%     dlf = dir(destination);
%     if ~isequal(dlf.bytes, sz)
%         error('File size mismatch: %d (file) %d (expected).\n',dlf.bytes,sz);
%     end
% end

end

