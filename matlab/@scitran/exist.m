function [status, id] = exist(obj,varargin)
% Tests whether a project, session, acquisition label exists in FW
%
%   [status, id] = st.exist(label,'containerType',[parentContainerID])
%
% Searches for a container of particular type with the given label.  If the
% parent container ID is known, the search is faster.
%
% If multiple 
%
% Returns:
%   status - Number of returned matches (0, 1 or N)
%   id     - The id of the object(s) (acq, or session, or project)
%
% N.B. We are thinking about collections
%
% RF/BW Scitran Team, 2016

%%
p = inputParser;

status = 0;
id = [];

end
