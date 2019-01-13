function result = lookup(st,str)
% Interface to Flywheel lookup function
%
% Syntax:
%
% Brief description:
%   Lookup a container by a string label.
%
% Input:
% str:  A char of labels.  You can have any depth in this order.  
%
%    group/project/session/acquisition
%
% Description: 
%   Not sure this scitran method is needed.  Place holder to remember that
%   there is such a thing.  We could do better argument checking, perhaps
%   even use this as an alternative way to call resolve and return the
%   sequence of objects down the path.
%
% See also
%  

% Examples:
%{
 st = scitran('stanfordlabs');
 project = st.lookup('wandell/VWFA');
 session = st.lookup('wandell/VWFA/13642');
 group = st.lookup('wandell');

 % Not sure how to lookup gears.  We should fix this so it works!
 % gear  = st.lookup('gears/AFNI: Brain Warp')
%}

result = st.fw.lookup(str);

end
