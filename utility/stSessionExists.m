function val = stSessionExists(sessions,label,tStamp)
% Check for a session with a specific label and time stamp
%
% Syntax
%   match = sessionExists(sessions,sessionLabel,tSamp)
%
% Inputs
%  sessions:   Cell array of sessions
%  label:      Session label
%  tStamp:     Time stamp
%
% Optional key/value pairs
%  N/A
%
% Returns
%   val - The session if it exists, or empty if it does not
%
% See also
%

%% Check
val = [];

if isempty(sessions)
    % No sessions, then no match
    return;
else
    % There are sessions.  See if one has this label
    sameLabel = stSelect(sessions,'label',label);
    if isempty(sameLabel)
        % None with the same session label.
        return;
    else
        % Sessions with this label exist
        nSessions = numel(sameLabel);
        % Simplified time stamp to avoid formatting issues.  We store
        % lower case letters and numbers
        X = stParamFormat(char(tStamp)); 
        X = strrep(X,':',''); X = strrep(X,'-','');

        % Check if they have the same time stamp
        for ii=1:nSessions
            % Simplify this time stamp as above
            Y = char(sameLabel{ii}.timestamp);
            Y = stParamFormat(Y); Y = strrep(Y,':',''); Y = strrep(Y,'-','');
            if strcmp(X,Y)
                % A match. Return the session with the same label and
                % time stamp
                val = sameLabel{ii};
                return;
            end
        end
    end
end

end