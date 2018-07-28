function modalityReplace(st,id,modality)
% Replace an existing Flywheel modality with a new definition
%
% Inputs
%   id:        Old modality id (its name, a string)
%   modality:  New modality object 
%
% Optional Key/Value pairs
%   None
%
% Returns
%   None
%
% BW, Vistasoft Team, 2018
%
% See also
%   scitran.modalityCreate

% Examples:
%{
cgClasses.model = {'Subaru','Mercedes','Ford','Volvo','Ferrari'};
modality = flywheel.model.Modality('id','CG','classification',cgClasses);
st.modalityReplace('CG',modality);
%}


%%
p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('id',@ischar)
p.addRequired('modality',@(x)(isa(x,'flywheel.model.Modality')));

%%
st.fw.replaceModality(id,modality);

end