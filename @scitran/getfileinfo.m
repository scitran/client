function info = getfileinfo(st,srchFile,varargin)
%
% Get info on a dicom file, and next on a QA file.
%
% Implement a download function, which I think is kind of like a get()
% call, or read, or something.
%
% Find the file(s)
% Get the acquisitions (parents) that contain the file.
% Return the specific file info structs
%
% LMP/BW Scitran Team, 2017

%{

st = scitran('cni');
clear srchFile
srchFile.filename = '16504_4_1_BOLD_EPI_Ax_AP.dicom.zip';
srchFile.filetype = 'dicom';
srchFile.projectlabelexact = 'qa';
st.getfilenfo
%}
%%
p = inputParser;
% p.KeepUnmatched = true;

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('srchFile',@isstruct);   % Parameters for finding the files
p.parse(st,srchFile,varargin{:});

%% Find these files
files = st.search('file',srchFile);
nFiles = length(files);

%% Parse the acquisitions for the info in that file
fprintf('Found %d files\n',nFiles);
info = cell(nFiles,1);
for ii=1:nFiles
    fname = files{ii}.name;
    thisAcq = st.fw.getAcquisition(files{ii}.parent.x_id);
    for jj = 1:length(thisAcq.files)
        if strcmp(fname,thisAcq.files{jj}.name)
            info{ii} = thisAcq.files{jj}.info;
            break
        end
    end   
end

%% Return the info parameter

end
