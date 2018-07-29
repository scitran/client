function info = dataFileInfoGet(st, acqid, fname, varargin)
% Read the modality and classification values from a data file
%
%   info = dataFileInfoGet(st, acqid, fname, varargin)
%
% Inputs
%   acqid:   Acquisition ID
%   fname:   file name
%
% Returns
%   info - 
%
% BW, Vistasoft Team, 2018
%
% See also
%   scitran.dataFileInfoSet

% Examples:
%{
% Return the whole info class
 st = scitran('stanfordlabs');
 h = st.projectHierarchy('Graphics assets');
 acqid = h.acquisitions{2}{2}.id;   % From session 2
 fname = h.acquisitions{2}{2}.files{1}.name;
 info = st.dataFileInfoGet(acqid,fname);
%}
%{
% Using the 'field' parameter to return just a field
 modality = st.dataFileInfoGet(acqid,fname,'field','modality');
 created = st.dataFileInfoGet(acqid,fname,'field','created');
 classification = st.dataFileInfoGet(acqid,fname,'field','classification');
 tags = st.dataFileInfoGet(acqid,fname,'field','tags');
%}

%%
p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('acqid',@ischar);
p.addRequired('fname',@ischar);
p.addParameter('field','',@ischar);

p.parse(st,acqid,fname,varargin{:});
field = p.Results.field;

%%  Find the file

info = st.fw.getAcquisitionFileInfo(acqid,fname);

% The person asked just for a field, not the whole info
if ~isempty(field)
    info = info.struct;
    tmp = info.(field);
    info = tmp;
else
    return;
end

end