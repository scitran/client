function modelName = stModel(data)
% Determine the flywheel model of the data
%
% Syntax
%  modelName = stModel(data)
%
% Inputs
%   data:  A Flywheel object or cell array of the same objects
%
% Optional key/value pairs
%   None
%
% Returns
%   modelName:  The flywheel model name for this object
%
% Description
%   Flywheel has a large set of model names for its different objects.
%   When we use the class() function these are all in the form
%
%         flywheel.model.XXX
%
%   Often we just want the XXX part.  So here we split the returned value
%   from the class() function, returning only the last part (XXX).
%
% Wandell, Vistasoft team, 2018

%% If a cell array, get out the first entry

if iscell(data),    thisData = data{1};
else,               thisData = data;
end

% Run the class() function
str    = class(thisData);

% Split and return the the last entry
cArray = strsplit(str,'.');

modelName = lower(cArray{end});

end
