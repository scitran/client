function modelName = stModel(data)
% Determine the flywheel model of the data
%
%  modelName = stModel(data)
%
% Wandell, Vistasoft team, 2018

%% Not sure this makes sense
if iscell(data)
    thisData = data{1};
else
    thisData = data;
end

str    = class(thisData);
cArray = split(str,'.');

modelName = lower(cArray{end});

end
