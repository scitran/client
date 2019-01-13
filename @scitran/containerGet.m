function container = containerGet(st,id)
% Get the container metadata given its id
%
% Syntax:
%    container = scitran.containerGet(id)
%
% Brief description:
%    This function is useful when you perform a search to find a container.
%    The SearchResponse is a portion of the container's metadata, but you
%    would like all of the metadata.  You can call this function with the
%    id in the SearchResponse.
%
%    I am considering adding an option to the search so that search returns
%    the container, not a search response.  Maybe pre-pending metadata
%
%       scitran.search('metadata returnType', ...)
%
% or maybe
%
%       scitran.search('returnType', ... 'metadata',true);
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
% See also
%   scitran.analysisGet
%

% Examples:
%{
 st = scitran('stanfordlabs');
 label = 'SVIP Released Data (SIEMENS)';
 id = st.projectID(label);
 project = st.containerGet(id);
%}
%{
 projectSearch = st.search('project','project label exact','ENGAGE');
 project = st.containerGet(projectSearch{1});
%}

%% Check the inputs

p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('id',@(x)(ischar(x) || isa((x),'flywheel.model.SearchResponse')));
p.parse(st,id);

%%
if ischar(id)
    % The user provided the ID
    container = st.fw.getContainer(id);
else
    % This was a search response
    cType = id.returnType;
    id = id.(cType).id;
    container = st.fw.getContainer(id);
end

end
