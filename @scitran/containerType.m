function   containerType = containerType(st,containerID)
% Determine the container type from its ID
%
% Syntax:
%
% Description:
%
% Inputs
%
% Optional key/val pairs
%
% Outputs
%
% Wandell, SCITRAN Team, 2019
%
% See also
%   scitran.objectParse, scitran.containerGet
%

% Examples:
%{
 st = scitran('stanfordlabs');
 project = st.search('projects','limit',1);
 containerID = project{1}.project.id;
 st.containerType(containerID)
%}

thisContainer     = st.containerGet(containerID);
[~,containerType] = st.objectParse(thisContainer);

end