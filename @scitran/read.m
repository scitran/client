function [data, dname] = read(fw,fileInfo,varargin)
% Read scitran data from a file into a Matlab variable
%
%   [data, destinationFile] = fw.read(fileStruct,'fileType',...,'destination',...);
%
% Inputs:
%    fileStruct - a file struct returned by a search
%
% Parameter
%    'fileType' - {'mat', 'nifti', 'json', 'csv', 'obj', 'tsv' ...}
%    'destination'  - Full path to file destination
%    'save'         - Do not delete destination file
% Examples:
%{
  fw = scitran('vistalab');
  file = fw.search('file','project label exact','ADNI: T1',...
                          'subject code',4256,...
                          'filetype','nifti');
  data = fw.read(file{1},'fileType','nifti');
%}
% Wandell/SCITRAN Team, 2017

% We should use fw.downloadFileFrom<XXX>

% downloadFileFromAcquisition(id, name, path)

%% Parse inputs
p = inputParser;

% This the perma link
p.addRequired('fileInfo',@isstruct);

% When we read the file, it should be one of these file types
fileTypes = {'obj','mat','matlab','nifti','json','csv'};
vFunc  = @(x)(ismember(lower(x),fileTypes));
p.addParameter('fileType','mat',vFunc);

% Name of destination file.
p.addParameter('destination',[],@ischar);
p.addParameter('save',false,@islogical);

p.parse(fileInfo,varargin{:});

fileType = p.Results.fileType;
save     = p.Results.save;
id       = fileInfo.parent.x_id;       % Parent ID
fname    = fileInfo.file.name;         % File name
if isempty(p.Results.destination)
    dname = fullfile(tempdir,fileInfo.file.name); % Destination name
else
    dname = destination;
end

if nargout > 1, save = true; end

switch(fileInfo.parent.type)
    case 'acquisition'
        fw.fw.downloadFileFromAcquisition(id,fname,dname);
    case 'session'
        fw.fw.downloadFileFromSession(id,fname,dname);
    case 'project'
        fw.fw.downloadFileFromProject(id,fname,dname);
    case 'collection'
        fw.fw.downloadFileFromCollection(id,fname,dname);
    otherwise
        error('Unknown parent type %s\n',fileInfo.parent.type);
end


%%
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





