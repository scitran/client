function getContainerInfo(obj,containerID)
% Read info from a Flywheel container
%
% Syntax
%
% Description
%   The possible container types are project, session, acquisition,
%   collection.  There is a separate method for File Info.
%
% 

% Example
%{
% The syntax for the SDK call is this:
%   st.fw.getProject(obj, id)

st = scitran('vistalab');
p = st.search('project','project label exact','VWFA')
id = idGet(p{1});
info = st.fw.getProject(id);
%}

