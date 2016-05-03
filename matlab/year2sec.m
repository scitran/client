function secs = year2sec(years)
% Convert years to seconds for elastic search
%
%   secs = year2sec(years)
%
% Input:  
%   years (can be a fraction, 10.5)
%
% Output:
%   seconds
%
% Example
%    
% BW, Scitran Team, 2016

% Add a quarter for leap years
% 365.25*24*60*60
%
secs = 31557600*years;

end

