function [srchResult, srchFile] = stEsearchRun(srch)
% Create the cmd and run an elastic search from the search struct
%
%  [srchResult, srchFile] = stEsearchRun(s)
%
% BW Scitran Team 2016

% The struct srch should have a url, token and body
% We use those to create the elastic search command
esCMD = stEsearchCreate(srch);

% We run the command
[~, result] = system(esCMD);

% Load the result file, which is a string in the returned data.
srchFile = strtrim(result(strfind(result,'/private/tmp'):end));
srchResult = loadjson(srchFile); % NOTE the use of strtrim

end
