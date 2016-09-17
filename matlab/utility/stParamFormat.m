function sformatted = stParamFormat(s)
% Converts s to a standard ISET parameter format  (lower case, no spaces)
%
%    sformatted = stParamFormat(s)
%
% The string is sent to lower case and spaces are removed.
%
% Example:
%     stParamFormat('upper left')
%

if ~ischar(s), error('s has to be a string'); end

% Lower case
sformatted = lower(s);

% Remove spaces
sformatted = strrep(sformatted,' ','');

return;


