function str = stType(container)
% Return a string for the Flywheel container type 
%
% Synopsis
%   str = stType(container)
%
% Inputs
%  container - Flywheel container
%
% Optional key/val
%   N/A
%
% Outputs
%   str - the string of the container type.  Usually the container classes
%    are flywheel.model.containerType.  We return the containerType part.
%
% Description
%    Various functions require knowledge of the container type.  This
%    method returns the key part of the container class that identifies the
%    container type.
%
% See also
%   scitran.infoGet


% The Flywheel containers have a class
tmp = class(container);

% They whole class usually looks like flywheel.model.type
tmp = split(tmp,'.');

% The case is annoying so we always force to lower case
str = lower(tmp{end});

end
