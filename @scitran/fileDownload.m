function destination = fileDownload(st,file,varargin)
% Retrieve a file from a Flywheel site
%
% Syntax
%   outfile = scitran.fileDownload(file, ...)
%
% Description
%   We download files from the containers, project, session,
%   acquisition, or collection. To download a file from an analysis,
%   which has input and output files, use st.analysisDownload.
%
% Required Inputs
%  file - A filename (string), FileEntry, or a Flywheel search object.
%         The container id and type are required for filename or
%         FileEntry.
%
% Optional Key/value parameter 
%  if file is a string or FileEntry you must specify the container
%  information 
%
%  containerType {'project', 'session', 'acquisition', 'collection'}
%  containerID    You can use st.objectParse() for most objects
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

[containerID, containerType, fileContainerType, filename] = ...
    st.objectParse(file,containerType,containerID);

if isempty(destination)
    destination = fullfile(pwd,filename);
end

%% Call the correct Flywheel SDK download method
% Perhaps we could call the analysis download too.  But I don't understand
% the syntax yet (BW).
%  fw.downloadAnalysisOutputsByFilename
switch lower(fileContainerType)
    case 'project'
        st.fw.downloadFileFromProject(containerID,filename,destination);
    case 'session'
        st.fw.downloadFileFromSession(containerID,filename,destination);
    case 'acquisition'
        st.fw.downloadFileFromAcquisition(containerID,filename,destination);
    case 'collection'
        st.fw.downloadFileFromCollection(containerID,filename,destination);
    case 'analysis'
        st.fw.downloadOutputFromAnalysis(containerID, filename, destination);

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

