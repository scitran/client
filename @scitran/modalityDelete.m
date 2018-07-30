function modalityDelete(st,name,varargin)
% Delete a Flywheel modality
%
% Description
%   Delete a data modality from the Flywheel instance.  We do not allow
%   deleting the modality 'MR'.  Others may be added to the 'no delete'
%   list in the future. 
%
%   The user is queried to confirm the deletion.
%
% Inputs
%   name:      Modality name (string)
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
%   scitran.modalityCreate, scitran.modalityReplace

%%
p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('name',@ischar);

p.parse(st,name,varargin{:});

%%  Query user

if strcmp(name,'MR')
    fprintf('Can not delete the MR modality\n'); 
    return; 
end

% OK, not MR, so ....
prompt = sprintf('Do you want to delete the modality %s? (yes/no)\n',name);
str = input(prompt,'s');
if strmp(str,'yes')
    fprintf('Deleting modality %s\n',name);
    st.fw.deleteModality(name);
else
    fprintf('User canceled.\n');
end

end
