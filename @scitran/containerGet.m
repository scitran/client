function container = containerGet(st,id)
% Get the container metadata given its id
%
% Syntax:
%    container = scitran.containerGet(id)
%
% Brief description:
%    A search response return includes the container's ID, but not all of
%    the metadata about the container.  This function is useful when you
%    perform a search and would like all of the container's metadata.
%
%    I am considering adding an option to the search so that search returns
%    the container, not a search response.  Maybe pre-pending metadata
%
%       scitran.search('metadata returnType', ...)
%
%   In which case the return would not be the search response, but would be
%   an array of container metadata
%
% Inputs
%   id:  The container's unique ID, or a SearchResponse of the container
%
% Returns
%   container:  The complete container metadata
%
% Optional key/value parameters
%
% Wandell, Vistasoft Team, 2019
%

%Examples
%{
 st = scitran('stanfordlabs');
 label = 'SVIP Released Data (SIEMENS)';
 id = st.projectID(label);

 project = st.containerGet(id);

%}
%{
 project = st.search('project','project label exact',label);
 project = st.containerGet(project{1});

%}
%% More might happen.  For now only this
p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('id',@(x)(ischar(x) || isa((x),'flywheel.model.SearchResponse')));
p.parse(st,id);

%%
if ischar(id)
    container = st.fw.getContainer(id);
else
    cType = id.returnType;
    id = id.(cType).id;
    container = st.fw.getContainer(id);
end

end
