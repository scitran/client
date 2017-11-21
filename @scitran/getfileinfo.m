function files = getfileinfo(st,files)
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
files = st.search('file',...
          'filename exact','16504_4_1_BOLD_EPI_Ax_AP.dicom.zip',...
          'filetype','dicom',...
          'project label exact','qa');
files = st.getfileinfo(files);

%}
%%
p = inputParser;
p.KeepUnmatched = true;

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('files',@iscell);   % Parameters for finding the files
p.parse(st,files);

%% Parse the acquisitions for the info in that file
    
for ii=1:numel(files)
    fname = files{ii}.file.name;
    thisAcq = st.fw.getAcquisition(files{ii}.parent.x_id);
    for jj = 1:length(thisAcq.files)
        if strcmp(fname,thisAcq.files{jj}.name)
            files{ii}.info = thisAcq.files{jj}.info;
            break;
        end
    end   
end

end

