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
% See also: s_stRead, scitran.downloadFile
%
% BW/SCITRAN Team, 2017

% Programming todo
%   We need to add some of the read functions into scitran.  Sigh.  For
%   now, I am just adding vistasoft to the path.  Bit niftiRead, objRead
%   ...
%
%
% Examples:
%{
  % Read a JSON file
  st = scitran('stanfordlabs');
  file = st.search('file','project label contains','SOC','filename','toolboxes.json');
  data = st.read(file{1});  
  edit(fName)
  delete(fName);
%}
%{
  % Read a nifti file.
  st = scitran('stanfordlabs');
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
if isfield(fileInfo.file,'type')
    fileType = stParamFormat(fileInfo.file.type);
else
    fileType = '';
end

% Not all file types are coordinated with Flywheel.  They label json as
% sourcecode and they ignore obj.
fileTypes = {'matlabdata','nifti','json','csv'};
if ~contains(fileType,fileTypes)
    [~,~,ext] = fileparts(fname);
    switch ext
        case '.json'
            fileType = 'json';
        case '.obj'
            fileType = 'obj';
        otherwise
            warning('unrecognized file type %s\n',fileType);
    end
end

%% Download the file

st.downloadFile(fileInfo,'destination',dname);

%% Load the file data

% This code depends on having certain
switch fileType
    case {'matlabdata'}
        
        data   = load(dname);
        
        % If there is only a single variable loaded, we set data to that
        % variable.
        fnames = fieldnames(data);
        if length(fnames) == 1, data = data.(fnames{1}); end
        
    case 'nifti'
        data = niftiRead(dname);
        
    case 'mniobj'
        %
        disp('mniobj NYI');
        
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

%% File management

% If the destination file name is not returned, and save is false,
% delete the downloaded file.
if ~save, delete(dname); end

end





