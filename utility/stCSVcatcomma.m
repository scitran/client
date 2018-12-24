function s = stCSVcatcomma(C)
% Concatenate cell array of strings into comma separated strings
%
%   s = stCSVcatcomma(C)
%
% Description:
%   Used to write out the headers in csv files that are plotted in
%   Flywheel.
%
% Input:
%
% Optional key/value pair
%
% Output
%   s:   String with comma separated values x,y,z
%
% See also
%

% Examples:
%{
C = {'x_ticks','V1','V2'}
str = stCSVcatcomma(C)
%}


%%
if notDefined('C') || ~iscell(C), error('Cell array input required'); end

%%
s = [];
for ii=1:(length(C)-1)
   s = [s,C{ii},',']; %#ok<*AGROW>
end
s = [s,C{end}];

end
