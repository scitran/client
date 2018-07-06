function destination = downloadFile(obj,file,varargin)
% Retrieve a file from a Flywheel site
%
%   outfile = scitran.downloadFile(file, ...)
%
% We use the iFlywheel SDK to download a file.  This routine differs from
% the other Flywheel download methods because files do not have an id.
% They have a parent and a filename, which we use to get them.
%
% Required Inputs
%  file - A filename (string), or 
%         A struct defining the file as returned by a search.  Required
%         struct fields are 
%           file.parent.type
%           file.parent.x_id
%           file.file.name
%
% Optional Inputs
%  When file is a string, you must specify the container information
%   containerType {'project', 'session', 'acquisition', 'collection', 'analysis'}
%   containerID   You can use idGet() for most objects
%  destination:   Full path to the local file (default is in tempdir)
%  size:          File size in bytes; used for checking
%
% Return
%  destination:  Full path to the local file
%
% See also: scitran.deleteFile, scitran.search
%
% Examples in code
%
% LMP/BW Vistasoft Team, 2015-16

% Examples
%{
  % Search struct form
  st = scitran('stanfordlabs');
  file = st.search('file',...
         'project label exact','DEMO',...
         'filename','dtiError.json');
  fName = st.downloadFile(file{1});

  edit(fName)
  delete(fName);
%}
%{
  % String form
  [s,id]  = st.exist('project','DEMO');
  if s
    fName = st.downloadFile('dtiError.json','containerType','project','containerID',id);
  end

  edit(fName)
  delete(fName);
%}
%{
  % String form with destination file name
  [s,id]  = st.exist('project','DEMO');
  if s
    fName = st.downloadFile('dtiError.json',...
          'containerType','project','containerID',id, ...
          'destination',fullfile(pwd,'deleteme.json'));
  end

  edit(fName)
  delete(fName);
%}

%% Parse inputs
varargin = stParamFormat(varargin);

p = inputParser;

% Either a struct or a char string
vFunc = @(x)(isa(x,'flywheel.model.SearchResponse') || ischar(x));
p.addRequired('file',vFunc);

% Param/value pairs
p.addParameter('containertype','',@ischar); % If file is string, required
p.addParameter('containerid','',@ischar);   % If file is string, required
p.addParameter('destination','',@ischar);
p.addParameter('size',[],@isnumeric);

p.parse(file,varargin{:});
containerType = p.Results.containertype;
containerID   = p.Results.containerid;
% sessionID     = p.Results.sessionid;   % Needed for analysis case
file          = p.Results.file;
destination   = p.Results.destination;
size          = p.Results.size;

%% Set up the Flywheel SDK call

if ischar(file)
    % Set up the download variables
    filename = file;
    if isempty(containerType) || isempty(containerID)
        error('If file is a string, you must specify container information');
    end
    %     if strcmp(containerType,'analysis') && isempty(sessionID)
    %         error('Session ID is required to download an analysis file');
    %     end
else
    containerType = file.parent.type;
    containerID   = file.parent.id;
    filename      = file.file.name;
    %     if strcmp(containerType,'analysis')
    %         sessionID = file.session.x_id;
    %     end
end

if isempty(destination)
    destination = fullfile(pwd,filename);
end

%% Call the correct Flywheel SDK download method
switch lower(containerType)
    case 'acquisition'
        obj.fw.downloadFileFromAcquisition(containerID,filename,destination);
    case 'project'
        obj.fw.downloadFileFromProject(containerID,filename,destination);
    case 'session'
        obj.fw.downloadFileFromSession(containerID,filename,destination);
    case 'collection'
        obj.fw.downloadFileFromCollection(containerID,filename,destination);
    case 'analysis'
        obj.fw.downloadOutputFromAnalysis(containerID,filename,destination);
    otherwise
        error('Unknown container type %s\n',file{1}.parent.type);
end


%% Verify file size
if ~isempty(size)
    dlf = dir(destination);
    if ~isequal(dlf.bytes, size)
        error('File size mismatch: %d (file) %d (expected).\n',dlf.bytes,size);
    end
end

end

