function  eraseProject(obj, projectLabel)
% Remove a project completely from a scitran site
%
%   @scitran.eraseProject('PROJECTLABEL');
%
% This call uses the projectHierarchy method to build the hierarchy of
% project,sessions and acquisitions.  It then deletes each of them
% systematically. I have seen it work up to (but not including) the project
% itself.
%
%% WARNING WARNING WARNING
%  Unfortunately there is no proper testing yet for this method.
%  Therefore a bug could be destructive. 
%
%  RF/BW Scitran Team, 2017

%% We should parse better and use a proper search.

p = inputParser;
p.addRequired('projectLabel',@ischar);
p.parse(projectLabel);

%% Find the project hierarchy 

% Cell arrays for the project, sessions, and acquisitions are returned.
[project, sess, acqs] = obj.projectHierarchy(projectLabel);
if length(project) ~= 1
    error('Project %s not found',projectLabel);
end

%% compute the total length of the acquisitions collected

length_acqs = 0;
for ii = 1:length(acqs)
    length_acqs = length(acqs{ii}) + length_acqs;
end

%% User must confirm information

% Confirm with the user the project label, the number of sessions, the
% number of acquisitions and the instance from which we are erasing the
% project
prompt = sprintf('Delete %d sessions and %d acquisitions from project %s? (y/n): ', ...
    length(sess), length_acqs, project{1}.source.label);
response = input(prompt,'s');

if lower(response) == 'y'
    %% loop over the acquisitions and delete them
    for ii = 1:length(acqs)
        sessAcqs = acqs{ii};
        for jj = 1:length(sessAcqs)
            cmd = obj.deleteContainerCmd('acquisitions', sessAcqs{jj}.id);
            % Maybe we should check the status
            [~,~] = system(cmd);
        end
    end
    
    %% loop over the sessions and delete them
    for ii = 1:length(sess)
        cmd = obj.deleteContainerCmd('sessions', sess{ii}.id);
        [~,~] = system(cmd);
    end
    
    %% delete the project
    cmd = obj.deleteContainerCmd('projects', projectLabel);
    [~,~] = system(cmd);
    
else
    disp('User canceled.');
    return;
end

end
