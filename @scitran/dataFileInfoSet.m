function info = dataFileInfoSet(st, acqid, fname, field, val)
% Read the modality and classification values from a data file
%
%   info = dataFileInfoSet(st, acqid, fname, field, val)
%
% Inputs
%   acqid:   Acquisition ID
%   fname:   file name
%   field:   field to modify (default is name)
%   val:     value to place in the field
%
% Returns
%   info - updated info object
%
% BW, Vistasoft Team, 2018
%
% See also
%   scitran.dataFileInfoSet

% Examples:
%{
% Return the whole info class
 st = scitran('stanfordlabs');
 h = st.projectHierarchy('EJ Apricot');
 acqid = h.acquisitions{1}{1}.id;   % From session 2
 fname = h.acquisitions{1}{1}.files{1}.name;
 info = st.dataFileInfoSet(acqid,fname,'name','stimulusMovieUpdate.mat');
 infoUpdated = st.dataFileInfoGet(acqid,fname);

%}
%{
%}

%%  Ask Justin

disp('dataFileInfoSet Not yet implemented');

end
%{
%%
p = inputParser;

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('acqid',@ischar);
p.addRequired('fname',@ischar);
p.addRequired('field',@ischar);
p.addRequired('val');

p.parse(st,acqid,fname,field,val);

%%  Build the struct and set the field in the file info

% It would be good to be able to check that the field and value are
% permitted.
newdata.(field) = val;
info = st.fw.modifyAcquisitionFileInfo(acqid,fname,newdata);

end
%}