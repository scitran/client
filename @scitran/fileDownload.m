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
%  file - A filename (string), FileEntry, or a Flywheel search object.
%         Additional parameters are required for filename or FileEntry.
%
% Optional Key/value parameter 
%  if file is a string or FileEntry you must specify the container
%  information 
%
%  containerType {'project', 'session', 'acquisition', 'collection'}
%  containerID   You can use idGet() for most objects
%  destination:   Full path to the local file (default is in tempdir)
%  unzip:         Unzip the download and delete the zip file
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

% BUG:
%{
% This bug worries me.

% This session has an analysis.  But it is not returned in the search info
session = st.search('session',...
   'project label exact','Brain Beats',...
   'session label exact','20180319_1232');

% The analysis slot is empty
session{1}.analysis

% This is the session id
idGet(session{1},'data type','session')

% Yet, this session has an analysis which we find when we do a search.
analysis = st.search('analysis',...
   'project label exact','Brain Beats',...
   'session label exact','20180319_1232');

% Notice that the analysis is attached to the right session id
analysis{1}.session.id
session{1}.session.id
%}

% Examples:
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
vFunc = @(x)(isa(x,'flywheel.model.SearchResponse') || ...
             isa(x,'flywheel.model.FileEntry') || ...
             ischar(x));
p.addRequired('file',vFunc);

% Param/value pairs
p.addParameter('containertype','',@ischar); % If file is string, required
p.addParameter('containerid','',@ischar);   % If file is string, required
p.addParameter('destination','',@ischar);
p.addParameter('unzip',false,@islogical);

p.parse(file,varargin{:});

containerType = p.Results.containertype;
containerID   = p.Results.containerid;
file          = p.Results.file;
destination   = p.Results.destination;
zipFlag       = p.Results.unzip;

%% Set up the Flywheel SDK method parameters. 
% These are the filename and container information.

if ischar(file)
    % Set up the download variables
    filename = file;
    if isempty(containerType) || isempty(containerID)
        error('If file is a string, you must specify container information');
    end
elseif isa(file,'flywheel.model.FileEntry')
    % A file entry is not much more than the file name at this point.  We
    % need to specify container type and id.  Not sure why it is so
    % limited.
    filename = file.name;
    if isempty(containerType) || isempty(containerID)
        error('If file is a FileEntry, you must specify container information');
    end
elseif isa(file,'flywheel.model.SearchResponse')
    % A Flywheel search object has a lot of information about the file.
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
    case 'analysis'
        obj.fw.downloadOutputFromAnalysis(containerID, filename, destination);

    otherwise
        error('No fileDownload for container type %s\n',containerType);
end

if zipFlag
    % User said to unzip the file and delete the zip file.
    outputDir = fileparts(destination);
    unzip(destination,outputDir);
    delete(destination);
end

end

