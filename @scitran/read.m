function read(stFile,varargin)
% Read scitran data from a file into a Matlab variable
%

p = inputParser;
p.addRequired('stFile',@isstruct)
fileTypes = {'obj','mat','nifti','json','csv'};
vFunc  = @(x)(ismember(lower(x),fileTypes));
p.addParameter('fileType','mat',vFunc);
p.parse(stFile,varargin{:});
fileType = p.Results.fileType;

%% Download the file
destdir = tempdir;
st.get(stFile,'destdir',destdir);

%% Read it using the appropriate file type

end