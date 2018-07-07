function collectionDelete(obj,id)
% Delete a collection using its id
%
% Syntax
%
%
% See also
%  collectionCreate

%%
p = inputParser;
p.addRequired('obj',@(x)(isa(x,'scitran')));
p.addRequired('id',@ischar);
p.parse(obj,id);

%%
st.fw.deleteCollection(id);

end
