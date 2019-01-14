function tf = stContains(str,pattern)
% Returns 1 (true) if str contains pattern, and returns 0 (false) otherwise.
%
% Syntax:
%    tf = stContains(str,pattern)
%
% Description:
%    Work around for the contains function. Written so that it will
%    work with Matlab versions prior to those with contains().
%
% Inputs
%   str -  A cell array of strings (or a string)
%   pattern -  A string
%
% Returns
%   tf    A logical array for each entry in the cell array, according
%         to whether it contains the pattern
%
% Wandell, SCITRAN TEAM 2018
%
% See also: 
%   contains, strfind
%   

% Examples:
%{
   stContains('help','he')
   stContains('help','m')
   stContains({'help','he','lp'},'he')
%}

if(iscell(str))
    tf = zeros(1,length(str));
    
    % If cell loop through all entries.
    for ii = 1:length(str)
        currStr = str{ii};
        if (~isempty(strfind(currStr,pattern))) %#ok<*STREMP>
            tf(ii) = 1;
        else
            tf(ii) = 0;
        end
    end
else
    
    if (~isempty(strfind(str,pattern)))
        tf = 1;
    else
        tf = 0;
    end
    
end

tf = logical(tf);

end

