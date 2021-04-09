function result = lookupfull(st,str)
% Interface to Flywheel lookup function but forces full data return
%
% Syntax:
%    scitran.lookupfull(str)
%
% Brief description:
%   Lookup a container by a string of labels.  The usual lookup only
%   returns a partial description of the object for reasons of speed.  In
%   this version, we do the lookup and then we do a 'get' so the entire set
%   of data is returned.
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

% This is the quick, partial lookup
result = st.fw.lookup(str);

% This flag tells us whether the return is partial.  In that case, the get
% returns the whole thing. 
if result.infoExists
    result = st.fw.get(result.id);
end

end
