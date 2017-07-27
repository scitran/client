function [data, destination] = read(st,pLink,varargin)
% Read scitran data from a file into a Matlab variable
%
%   data = st.read(pLink,'fileType',fileType);
%
% Inputs:
%    pLink:  Permalink to the file in Flywheel, or a cell that contains the
%            permalink (say, as returned by a flywheel search).
%    
% Parameter
%    'fileType' - {obj, mat, nifti, json, csv}
%
% Examples:
%    st = scitran('vistalab');
%    file = st.search('files','project label','ADNI: T1','subject code',4256,'filetype','nifti');
%    data = st.read(file{1},'fileType','nifti');
%
% Wandell/SCITRAN Team, 2017

%% Parse inputs
p = inputParser;

% This the perma link
vFunc = @(x) (ischar(x) || isstruct(x));
p.addRequired('pLink',vFunc);

fileTypes = {'obj','mat','matlab','nifti','json','csv'};
vFunc  = @(x)(ismember(lower(x),fileTypes));
p.addParameter('fileType','mat',vFunc);

p.parse(pLink,varargin{:});

% Decode the permalink or the struct that contains the permalink into a
% full file path where the data can be read/stored
destination = stPlink2Destination(pLink);
fileType = p.Results.fileType;

%% Download the file
st.get(pLink,'destination',destination);

%% Read it using the appropriate file type
switch fileType
    case {'mat','matlab'}
        % Not sure what to do here.  Perhaps if there is only a single
        % variable, we set 
        data = load(destination);
        fnames = fieldnames(data);
        if length(fnames) == 1
            data = data.(fnames{1});
        end
        
    case 'nifti'
        data = niftiRead(destination);
        
    case 'mniobj'

    case 'obj'
        % Not sure what to do.  This is a text file, I think.
        data = objRead(destination);
        
    case 'csv'
        % Read as text
        
    case 'json'
        % Use JSONio stuff
        data = jsonread(destination);
        
    otherwise
        error('Unknown file type %s\n',fileType);
end

end