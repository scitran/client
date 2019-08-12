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
%  file - A FileEntry, or a file returned as a Flywheel search object.
%
% Optional key/val pairs
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
  % Lookup form
  project = st.lookup('scitran/DEMO');
  files = project.files();
  thisFile = stSelect(files,'name','dtiError.json');
  fName = st.fileDownload(thisFile{1});
  edit(fName);
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
% p.addParameter('containertype','',@ischar); % If file is string, required
% p.addParameter('containerid','',@ischar);   % If file is string, required
p.addParameter('destination','',@ischar);
p.addParameter('unzip',false,@islogical);

p.parse(file,varargin{:});

% containerType = p.Results.containertype;
% containerID   = p.Results.containerid;
file          = p.Results.file;
destination   = p.Results.destination;
zipFlag       = p.Results.unzip;

%% Set up the Flywheel SDK method parameters. 
% These are the filename and container information.

if isa(file,'flywheel.model.SearchResponse')
    cFile{1} = file;   % Make it a cell
    cFile = stSearch2Container(st,cFile);
    file = cFile{1};
end

% [containerID, containerType, fileContainerType, filename] = ...
%     st.objectParse(file,containerType,containerID);
if isempty(destination)
    destination = fullfile(pwd,file.name);
end

%% Call the correct Flywheel SDK download method

file.download(destination);

%{
% Perhaps we could call the analysis download too.  But I don't understand
% the syntax yet (BW).
%  fw.downloadAnalysisOutputsByFilename
%
% In 4.4.0 there should be a simpler unified method based on the file
% itself.  values = file.read(), or file.download()
% Or if you have the container acquisition.readfile(fname)
%
switch lower(fileContainerType)
    case 'project'
        st.fw.downloadFileFromProject(containerID,file.name,destination);
    case 'session'
        st.fw.downloadFileFromSession(containerID,file.name,destination);
    case 'acquisition'
        st.fw.downloadFileFromAcquisition(containerID,file.name,destination);
    case 'collection'
        st.fw.downloadFileFromCollection(containerID,file.name,destination);
    case 'analysis'
        st.fw.downloadOutputFromAnalysis(containerID, file.name, destination);
    case 'fileentry'
        % where result is an individual file search result:
        fileEntry = result.parent.getFile(result.file.name);
        fileEntry.download('data.bin');

    otherwise
        error('No fileDownload for container type %s\n',containerType);
end
%}

if zipFlag
    % User said to unzip the file and delete the zip file.
    outputDir = fileparts(destination);
    unzip(destination,outputDir);
    delete(destination);
end

end

