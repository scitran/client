function [container, cType] = containerGet(st,id)
% Get the container metadata given its id
%
% Syntax:
%    container = scitran.containerGet(id)
%
% Brief description:
%  Retrieve the Flywheel container metadata from the object's ID.
%
%  The most common application is converting the returns from a search,
%  which are of type SearchResponse, into Flywheel data. The search
%  includes the ID, so you can call this function. 
%
%  The conversion can be useful because the SearchResponse and Flywheel
%  data contain different information.
%
%  You can also force the search to return the Flywheel data format by
%  setting the 'fw' key/val option as true.
%
%       scitran.search('returnType', ..., 'fw',true)
%
%  In that case,  scitran.search calls stSearch2Container, which in turn
%  calls this function, after collecting up the SearchResponses.
%
% Inputs
%   id:  The container's unique ID, or a SearchResponse of the container
%
% Optional key/value parameters
%   N/A
%
% Outputs
%   container:  The complete container metadata
%   cType:      The container type
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
    [~,cType] = st.objectParse(container);
else
    % This was a search response
    cType = id.returnType;
    id = id.(cType).id;
    container = st.fw.getContainer(id);
end

end
