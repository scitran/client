function result = lookup(st,str)
% Interface to Flywheel lookup function
%
% Syntax:
%
% Brief description:
%   Useful to lookup a container or a gear when you know what you want.
%
% Input:
% str:  A char of labels.  You can have any depth in this order.  
%
%    group/project/session/acquisition
%
%
% Description: 
%   Not sure this is needed.  Place holder to remember that there is such a
%   thing.  We could do better argument checking, perhaps even use this as
%   an alternative way to call resolve and return the sequence of objects
%   down the path.
%
% See also
%  

%Example
%{
 st = scitran('stanfordlabs');
 project = st.lookup('wandell/VWFA');
 session = st.lookup('wandell/VWFA/13642');
 group = st.lookup('wandell');

 % Not sure how to lookup gears.  But in principle this should work.
 % gear  = st.lookup('gears/AFNI: Brain Warp')
%}
result = st.fw.lookup(str);

end

%{
% This is faster, but we would need to get the group (wandell) and the
% label (VWFA) sent in.  One thought is that the scitran class should always
% have the user's group attached to it (st.group).  At create time.  The
% problem with this is that some people (e.g., wandell) are members of
% multiple groups.

  % This returns the VWFA project
  tic
  tmp = st.fw.lookup('wandell/VWFA');
  toc

  % This example returns each of the containers in the hierarchy, the group
  % and the project.
  tic
  tmp = st.fw.resolve('wandell/VWFA');
  id = tmp.path{2}.id
  toc

%}
