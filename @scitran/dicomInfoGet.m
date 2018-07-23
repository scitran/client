function files = dicomInfoGet(st,files)
% Get info about a dicom file.  Attach it to the input files{} structs
%
% Syntax
%    files = scitran.dicomInfoGet(files, ...)
%
% Description
%  Dicom header information describes critical parameters about the file
%  and is stored in Flywheel in an info object.  We return the info object
%  for a cell array of dicom files here.
%
% Inputs
%  files - Cell array of file structs, as returned by a search
%
% Returns
%  info -  Cell array of info structs for each file.  If none, empty.
%
% LMP/BW Scitran Team, 2017
%
% See also:  scitran.search

% Example
%{
st = scitran('cni');
files = st.search('file',...
          'filename exact','16504_4_1_BOLD_EPI_Ax_AP.dicom.zip',...
          'filetype','dicom',...
          'project label exact','qa');
files = st.getdicominfo(files);
fprintf('Echo Time %d\n',files{1}.info.('EchoTime'))
%}

%%
p = inputParser;
p.KeepUnmatched = true;

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('files',@iscell);   % Parameters for finding the files
p.parse(st,files);

%% Parse the acquisitions for the info in that file
    
for ii=1:numel(files)
    if ~isequal(files{ii}.file.type,'dicom')
        warning('File %d is not of type dicom. Skipping',ii);
    end
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

