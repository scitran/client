function val = stSessionExists(sessions,label,tStamp)
% Check for a session with a label and time stamp
%
% Syntax
%   match = sessionExists(sessions,sessionLabel,tSamp)
%
% Inputs
%  sessions:   Cell array of sessions
%  label   :   Session label
%  tStamp:     Time stamp in the right format
%
% Optional key/value pairs
%  N/A
%
% Returns
%   val - The session if it exists, or false if it does
%
%

% Assume it doesn't exist
val = [];

if isempty(sessions)
    % No sessions, then no match
    return;
else
    % There are sessions.  See if there is one with this label
    sameLabel = stSelect(sessions,'label',label);
    if isempty(sameLabel)
        % None with the label.  Create a new one
        return;
    else
        % Sessions with this label exist
        nSessions = numel(sameLabel);
        
        % Check if they have this time stamp
        for ii=1:nSessions
            if strncmp(tStamp,sameLabel{ii}.timestamp,17)
                % The session with the same label and the same time stamp exists
                val = sameLabel{ii};
                return;
            end
        end
    end
end

end