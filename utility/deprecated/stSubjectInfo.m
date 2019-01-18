function subjects = stSubjectInfo(sessions)
% Return properties of the subjects from a single session or cell array of
% sessions
%
% This answers questions like:
%
%    How many unique subects?
%    Age distribution of the unique subjects
%    Sex distribution of these subjects?
%
%  Note:  The date in sessions.subject.created can be converted by datestr
%  if we replace the 'T' with a space.
%
% Inputs:
%   sessions:  A cell array of sessions (or a single session)
%   
%
% Example:
%    subjects = stSubjectInfo(sessions);   % Returns all the information
%
% BW Scitran Client

%%
p = inputParser;

% A single session or a cell array of sessions
vFunc = @(x)(isstruct(sessions) || iscell(sessions));
p.addRequired('sessions',vFunc);

% Convert single struct to a single cell
if isstruct(sessions), s{1} = sessions;
else, s = sessions;
end

% Possible fields to return.  Default would be all
subjects = cell(length(sessions),1);
nSessions = length(sessions);

%%
for ii=1:nSessions
    
    % Used to be isfield.  Now that it is an object, we need isprop.
    % Note this somewhere better than here.
    if isprop(s{ii}.subject,'code') 
        subjects{ii}.code= s{ii}.subject.code;
    else
        subjects{ii}.code= 0;
    end
    
    if isprop(s{ii}.subject,'firstname') 
        subjects{ii}.firstname= s{ii}.subject.firstname;
    else
        subjects{ii}.firstname= '';
    end
    
    if isprop(s{ii}.subject,'lastname')
        subjects{ii}.lastname= s{ii}.subject.lastname;
    else
        subjects{ii}.lastname= '';
    end
    
    if ~isprop(s{ii}.subject,'sex') || isempty(s{ii}.subject.sex)
        subjects{ii}.sex= 'u';
    else
        subjects{ii}.sex= s{ii}.subject.sex; 
    end
    
    if isprop(s{ii}.subject,'age')
        subjects{ii}.age= sec2year(s{ii}.subject.age);
    else
        subjects{ii}.age= 0;
    end
    
end


end
