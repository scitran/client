function dataFileModalitySet(st,acqid,fname,param,val)
% Set the modality or a classification field of a data file
%
% Syntax
%   scitran.dataFileModalitySet(st,acqid,fname,param,val)
%
% Description
%   Data files can be assigned a modality (e.g., MR, CG, Dental) and within
%   each modality we can set a set of possible classification types.  For
%   example, the 'Dental' modality has a location field that can be set to
%   'teeth', 'mucosa', and such. 
%
%   This function sets a modality or a classification field within a
%   modality of a specific data file.  Data files are also called
%   acquisition files.  They have a special status in the Flywheel SDK.
%
% BW, Vistasoft, 2018
%
% See also:
%   scitran.dataFileModalityGet

% Examples:
%{
 st = scitran('stanfordlabs');
 h = st.projectHierarchy('Graphics assets');
 acqid = h.acquisitions{2}{2}.id;   % From session 2
 fname = h.acquisitions{2}{2}.files{1}.name;

 % Sets the modality of the file
 st.dataFileModalitySet(acqid,'Car_2.c4d','modality','CG');
%}
%{
  % Sets the classification value of the current modality.  The
  % classification subtype must exist, and the string must be permissible
  st.dataFileModalitySet(acqID,'car.mtl','model','Ford')  
%}

%% 
p = inputParser;

p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('acqid',@ischar);
p.addRequired('fname',@ischar);
p.addRequired('param',@ischar);
p.addRequired('val');

p.parse(st,acqid,fname,param,val);

files    = st.list('file',acqid);
thisFile = stFileSelect(files,'name',fname);
%%
switch param
    case 'modality'
        st.fw.modifyAcquisitionFile(acqid, fname, struct('modality', val));
    otherwise
        % We check that it is a valid classification label and a
        % permissible val 
        names = fieldnames(thisFile.classification);
        if ismember(names,param)
            thisStruct = struct(param,{{val}});
            st.fw.setAcquisitionFileClassification(thisAcquisition.id, files.name, thisStruct)
        else
            fprintf('Classification fields are %s\n',names);
            error('No classification field with the name %s\n',param);
        end
end
        
end

