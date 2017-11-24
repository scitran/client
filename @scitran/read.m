function [data, dname] = read(st,fileInfo,varargin)
% Read scitran data from a file into a Matlab variable
%
%   [data, destinationFile] = st.read(file, ...);
%
% Inputs:
%    file - a file struct returned by a search
%
% Parameter
%    'destination'  - Full path to file destination
%    'save'         - Delete or not destination file (logical)
%
% BW/SCITRAN Team, 2017

% Programming todo
%   We need to add some of the read functions into scitran.  Sigh.  For
%   now, I am just adding vistasoft to the path.  Bit niftiRead, objRead
%   ...
%

% Examples:
%{
  % Read a JSON file
  st = scitran('vistalab');
  file = st.search('file','project label contains','SOC','filename','toolboxes.json');
  data = st.read(file{1});  
  edit(fName)
  delete(fName);
%}
%{
  % Read a nifti file.
  st = scitran('vistalab');
  file = st.search('file',...
                   'project label exact','ADNI: T1',...
                   'subject code',4256,...
                   'filetype','nifti');
  data = st.read(file{1});
%}

%% Parse input parameters

p = inputParser;

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('fileInfo',@isstruct);

p.addParameter('destination',[],@ischar);
p.addParameter('save',false,@islogical);

p.parse(st, fileInfo, varargin{:});

save        = p.Results.save;
% The only reason you would have two outputs is to save the file.
if nargout > 1, save = true; end

% Create destination from file name.  Might need the extension for
% filetype
destination = p.Results.destination;
fname       = fileInfo.file.name;
if isempty(p.Results.destination),  dname = fullfile(tempdir,fname); 
else,                               dname = destination;
end

% When we read the file, it should be one of these file types
fileType = stParamFormat(fileInfo.file.type);
fileTypes = {'obj','mat','matlab','nifti','json','csv'};
if ~contains(fileType,fileTypes)
    if isequal(fileType,'sourcecode') 
        [~,~,ext] = fileparts(fname);
        if isequal(ext,'.json'), fileType = 'json'; 
        else, warning('unrecognized file type %s\n',fileType);
        end
    end
end

%% Download the file

st.downloadFile(fileInfo,'destination',dname);

%% Load the file data

switch fileType
    case {'mat','matlab'}
        % Not sure what to do here.  Perhaps if there is only a single
        % variable, we set
        data = load(dname);
        fnames = fieldnames(data);
        if length(fnames) == 1
            data = data.(fnames{1});
        end
        
    case 'nifti'
        data = niftiRead(dname);
        
    case 'mniobj'
        
    case 'obj'
        % Not sure what to do.  This is a text file, I think.
        data = objRead(dname);
        
    case 'csv'
        % Read as text
        
    case 'json'
        % Use JSONio stuff
        data = jsonread(dname);
        
    otherwise
        error('Unknown file type %s\n',fileType);
end

%% If the name of the destination file is not returned, we delete it
if ~save
    disp('Deleting local file');
    delete(dname);
end

end





