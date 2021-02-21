function containerSet(st,container,param,val,varargin)
% Set a container parameter to a particular value
%
%  This is a placeholder.  The better FW interface should allow us to get
%  rid of this method with simpler FW class.
%
% Syntax
%    st.containerSet(container, param, val, varargin)
%
% Description
%    Calls the update function on a container to adjust a parameter,
%    such as the time stamp.
%
% Inputs
%    obj:   scitran object
%    container:  Project, session, acquisition, file
%    param
%    val
%
% Optional key/value pairs
%
% Returns
%   N/A
%
% See also
%    scitran.containerGet
%
%

% Examples:
%{
 st = scitran('stanfordlabs');
 project = st.lookup('wandell/Graphics camera array');
 sessions = project.sessions.find;
 st.containerSet(sessions{1},'timestamp',datetime('now'));
%}
%% Parse
p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
vFunc = @(x)(strncmp(class(x),'flywheel',8));
p.addRequired('container',vFunc);
p.addRequired('param',@ischar);
p.addRequired('val');

p.parse(st,container,param,val);

%%

[id,cType] = stObjectParse(container);
cType = [cType,'s'];
switch ieParamFormat(param)
    case 'timestamp'
        % Should work for a session or project or acquisition
        % Needs much more testing.
        fwObject = st.fw.(cType).findOne(['_id=',id]);
        timestamp = datetime('now');
        timestamp.TimeZone = 'America/Los_Angeles';
        fwObject.update('timestamp', timestamp);
        
    case 'subject'
        % Not sure this is how to do it.  Also, this is only correct for
        % sessions, I think.  Not acquisition or project.
        fwObject = st.fw.(cType).findOne(['_id=',id]);
        fwObject.subject = val;
        fwObject.update();
        
    otherwise
        error('Not ready');
end



end