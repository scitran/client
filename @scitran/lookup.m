function result = lookup(st,str,full)
% Interface to Flywheel lookup function
%
% Syntax:
%    scitran.lookup(str,full)
%
% Brief description:
%   Lookup a container by a string.  The format of the string is
%
%     groupID/projectLabel/subjectLabel/sessionLabel/acquisitionLabel
%
%   The returned container is not always complete.  Instead, there is a
%   flag (infoExists) that indicates whether there are info fields in the
%   whole container that are not returned here.  If there are info fields
%   not returned, the user is warned.
%
% Input:
%  str:  A string of labels.  You can have any depth in this order.  
%  full: Logical. Return full data (default: false)
%
% Output:
%   result:  The requested object or if 'gears' a cell array of gear objects
%
% See also
%    scitran.gears, scitran.groups
%

% Examples:
%{
 st = scitran('stanfordlabs');
 group       = st.lookup('wandell');
 project     = st.lookup('wandell/VWFA');
 thisSession = project.sessions.findFirst;

 str     = fullfile(group.id,project.label,thisSession.subject.label,thisSession.label);
 session = st.lookup(str);
%}
%{
 % Special case
 st = scitran('stanfordlabs');
 gears  = st.gears;
 thisGear = st.lookup(fullfile('gears',gears{10}.gear.name));
 thisGear.gear.name
%}

%%
if notDefined('full'), full = false; end

%%  Get the container
result = st.fw.lookup(str);

%% Flywheel sometimes returns partial information

% They do this because the additional information can be very large, and
% they are trying to save time/bandwidth.  The user might have specified
% 'full' as true, which means get all the info, not just the partial info.
% We check that here.
if full && ~isempty(result.infoExists)
    % Get the whole container
    result = st.fw.get(result.id);
elseif result.infoExists
    % Warn the user
    disp('This is a partial container.  Other info exists');
end

end
