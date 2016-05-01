function [srchResult, srchFile] = stEsearchRun(srch)
% Create the cmd and run an elastic search from the search struct
%
%  [srchResult, srchFile] = stEsearchRun(s)
%
% Input:
%  srch:  A struct containing the url, token and json fields needed to
%  create the elastic search command
%
% BW Scitran Team 2016

%% Could check the srch struct here for the appropriate fields
%

% The struct srch should have a url, token and body
% We use those to create the elastic search command
esCMD = stEsearchCreate(srch);

%% Run the command
[~, result] = system(esCMD);

%% Load the result file, which is a string in the returned data.

srchFile = strtrim(result(strfind(result,'/private/tmp'):end));
srchResult = loadjson(srchFile); % NOTE the use of strtrim

end
