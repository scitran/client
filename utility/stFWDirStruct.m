function d = stFWDirStruct(varargin)
% Return a struct with the directory fields
%
% Syntax
%   dstruct = stFWDirStruct
%
% See also
%   stFWCreate

% Examples:
%{
  d = stFWDirStruct('group id','oraleye','project label','Dental')
%}
%%
varargin = stParamFormat(varargin);

p = inputParser;
p.addParameter('groupid','',@ischar);
p.addParameter('projectlabel','',@ischar);
p.addParameter('subjectcode','',@ischar);
p.addParameter('sessionlabel','',@ischar);
p.parse(varargin{:});

d.groupid = p.Results.groupid;

d.projectlabel = p.Results.projectlabel;
d.subjectcode  = p.Results.subjectcode;
d.sessionlabel = p.Results.sessionlabel;

end
