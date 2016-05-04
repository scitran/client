function years = sec2year(secs)
% Convert seconds years to 
%   years = sec2year(sec)
%
% Input:  
%   seconds
% Output:
%   years
%
% Example
%    
% BW, Scitran Team, 2016

% Add a quarter for leap years
% 365.25*24*60*60
%
years = secs/31557600;

end

