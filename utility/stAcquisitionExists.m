function val = stAcquisitionExists(session,label)
% Check for an acquisition with a label within a session
%
% Syntax
%   val = stAcquisitionExists(session,label)
%
% Inputs
%  session: A single session
%  label:   Acquisitions label
%
% Optional key/value pairs
%  N/A
%
% Returns
%   val - The acquisitions if it exists, or empty 
%
% BW, December, 2019
%
% See also:  
%    stSessionExists, stSelect
%

% Assume none exist
val = [];
acquisitions = session.acquisitions();

if isempty(acquisitions)
    % No acquisitions, then no match
    return;
else
    % There are acquisitions.  See if there is one with this label
    sameLabel = stSelect(acquisitions,'label',label);
    if isempty(sameLabel)
        % None with the label.
        return;
    else
        if numel(sameLabel) > 1
            warning('Multiple acquisitions exist with label %s',label);
        end
        % Acquisitions with this label exist
        val = sameLabel{1};
    end
end

end