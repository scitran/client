function [modality,classification] = dataFileModalityGet(st, acqid, fname)
% Read the modality and classification values from a data file
%
%   [modality, classification] = dataFileModalityGet(st, acqid, fname)
%
% Inputs
%   acqid:   Acquisition ID
%   fname:   file name
%
% Returns
%   modality - the modality ID (a string)
%   classification names - Cell array of classification field names
%
% BW, Vistasoft Team, 2018
%
% See also
%   scitran.dataFileModalitySet

% Examples:
%{
st = scitran('stanfordlabs');
h = st.projectHierarchy('Graphics assets');
acqid = h.acquisitions{2}{2}.id;   % From session 2
fname = h.acquisitions{2}{2}.files{1}.name;

% The classification shows the value of the current classification fields
[m,classification] = st.dataFileModalityGet(acqid,fname);

% To convert the CommonClassification object to a struct use
classification.struct

%}

%%
p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('acqid',@ischar);
p.addRequired('fname',@ischar);

p.parse(st,acqid,fname);

%%  Find the file
files    = st.list('file',acqid);
thisFile = stFileSelect(files,'name',fname);

% Return its modality and the CommonClassification object
modality       = thisFile{1}.modality;
classification = thisFile{1}.classification;

end