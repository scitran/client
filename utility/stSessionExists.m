function val = stSessionExists(sessions,label,tStamp)
% Check if a session with a specific label exists in the sessions list
%
% Syntax
%   match = sessionExists(sessions,sessionLabel,[tSamp])
%
% Brief description
%   If there are multiple sessions that match the label, then you can also
%   specify a time stamp (tStamp).
% Inputs
%  sessions:   Array of Flywheel sessions
%  label:      Session label
%
% Optional
%  tStamp:     Time stamp  (formatted as in datestr(now))
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
if notDefined('tStamp'), tStamp = ''; end

if isempty(sessions)
    % No sessions, then no match
    return;
else
    % There are sessions.  See if one has this label
    sameLabel = stSelect(sessions,'label',label);
    if isempty(sameLabel)
        % None with the same session label.
        return;
    elseif isempty(tStamp)
        % No tStamp.
        val = sameLabel;
        % Sessions with this label exist
        if numel(val) > 1
            warning('Multiple session matches.')
        end
        return;
    else
        % There is a tStamp and a match, so keep checking
        
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