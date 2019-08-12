function result = lookup(st,str)
% Interface to Flywheel lookup function
%
% Syntax:
%    scitran.lookup(str)
%
% Brief description:
%   Lookup a container by a string of labels.
%
% Input:
%  str:  A string of labels.  You can have any depth in this order.  
%
%     groupID/projectLabel/subjectLabel/sessionLabel/acquisitionLabel
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

% We might want to make the result conform to some other format some day.
% Or Flywheel may always return us the same format.
result = st.fw.lookup(str);

end
