function val = stSessionExists(sessions,label,varargin)
% Check if a session with a specific label exists in the sessions list
%
% Put in a warning that I changed this, in case someone else is using it
%
% Syntax
%   match = sessionExists(sessions,sessionLabel,varargin)
%
% Brief description
%   If there are multiple sessions that match the label, then you can also
%   require a match to a time stamp or subjectcode.
%
% Inputs
%  sessions:   Array of Flywheel sessions
%  label:      Session label
%
% Optional key/val
%  param:   Parameter string to check, usually subjectcode or time stamp
%
% Returns
%   val - A session if it exists, or empty if a matching session does not
%         exist
%
% See also
%    stAcquisitionExists

% Examples
%   sess = stSessionExists(sessions,thisLabel,'subject code','003');
%   sess = stSessionExists(sessions,thisLabel,'time stamp',datestr(now));
%

%% Check
varargin = ieParamFormat(varargin);

p = inputParser;
p.addRequired('sessions',@iscell);
p.addRequired('label',@ischar);
p.addParameter('timestamp','',@ischar);
p.addParameter('subjectcode','',@ischar);

p.parse(sessions,label,varargin{:});

timestamp   = p.Results.timestamp;
subjectcode = p.Results.subjectcode;

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
    end
end

% We have one or more sessions matching the label.  Check the additional
% parameter(s).
nSessions = numel(sameLabel);
if ~isempty('subjectcode')
    % Do any of the sessions match the subject code
    for ii=1:nSessions
        if isequal(sameLabel{ii}.subject.code,subjectcode)
            val = sameLabel{ii};
            return;
        end
    end
end

if ~isempty(timestamp)
    % Simplified time stamp to avoid formatting issues.  We store
    % lower case letters and numbers
    X = stParamFormat(char(timestamp));
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