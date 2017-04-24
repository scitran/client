function [data, destination] = read(st,pLink,varargin)
% Read scitran data from a file into a Matlab variable
%
%   data = st.read(pLink,'fileType',fileType);
%
% Wandell/SCITRAN Team, 2017

%%
p = inputParser;

vFunc = @(x) (ischar(x) || isstruct(x));
p.addRequired('pLink',vFunc);

fileTypes = {'obj','mat','nifti','json','csv'};
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
    case 'mat'
        % Not sure what to do here.  Perhaps if there is only a single
        % variable, we set 
        data = load(destination);
        fnames = fieldnames(data);
        if length(fnames) == 1
            data = data.(fnames{1});
        end
        
    case 'nifti'
        data = niftiRead(destination);
        
    case 'obj'
        % Not sure what to do.  This is a text file, I think.
        
    case 'csv'
        % Read as text
        
    case 'json'
        % Use JSONio stuff
        
    otherwise
        error('Unknown file type %s\n',fileType);
end

end