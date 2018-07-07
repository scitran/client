function destination = fileDownload(obj,file,varargin)
% Retrieve a file from a Flywheel site
%
% Syntax
%   outfile = scitran.fileDownload(file, ...)
%
% Description
%   We download files from the data containers, project, session,
%   acquisition, or collection. To download a file from an analysis, which
%   has input and output files, use st.analysisDownload.
%
% Required Inputs
%  file - A filename (string), or 
%         A Flywheel search object.
%
% Optional Key/value parameter 
%  if file is a string you must specify the container information
%    containerType {'project', 'session', 'acquisition', 'collection'}
%    containerID   You can use idGet() for most objects
%  destination:   Full path to the local file (default is in tempdir)
%
% Return
%  destination:  Full path to the local file
%
% Examples in code
%
% LMP/BW Vistasoft Team, 2015-16
%
% See also: 
%  scitran.deleteFile, scitran.search

% Examples
%{
  % Search struct form
  st = scitran('stanfordlabs');
  file = st.search('file',...
         'project label exact','DEMO',...
         'filename','dtiError.json');
  fName = st.fileDownload(file{1});
  edit(fName);
  delete(fName);
%}
%{
  % String form
  [s,id]  = st.exist('project','DEMO');
  if s
    fName = st.fileDownload('dtiError.json','containerType','project','containerID',id);
  end

  edit(fName)
  delete(fName);
%}
%{
  % String form with destination file name
  [s,id]  = st.exist('project','DEMO');
  if s
    fName = st.fileDownload('dtiError.json',...
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
vFunc =( @(x)(isa(x,'flywheel.model.SearchResponse') || ischar(x)));
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
else
    % A Flywheel search object
    containerType = file.parent.type;
    containerID   = file.parent.id;
    filename      = file.file.name;
end

if isempty(destination)
    destination = fullfile(pwd,filename);
end

%% Call the correct Flywheel SDK download method
% Perhaps we could call the analysis download too.  But I don't understand
% the syntax yet (BW).
%  fw.downloadAnalysisOutputsByFilename
switch lower(containerType)
    case 'project'
        obj.fw.downloadFileFromProject(containerID,filename,destination);
    case 'session'
        obj.fw.downloadFileFromSession(containerID,filename,destination);
    case 'acquisition'
        obj.fw.downloadFileFromAcquisition(containerID,filename,destination);
        
    case 'collection'
        obj.fw.downloadFileFromCollection(containerID,filename,destination);
        
    otherwise
        error('No fileDownload for container type %s\n',containerType);
end

end

