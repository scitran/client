function [project, sessions, acquisitions] = projectHierarchy(obj, field, value)
srch.path = 'projects';
srch.projects.match.(field) = value;
projects = obj.search(srch);

if length(projects) ~= 1
    error('more than 1 project matched the query')
end
project = projects{1};
projectID = project.id;
clear srch;
srch.path = 'sessions';
srch.projects.match.x0x5F_id = projectID;
sessions = obj.search(srch);
acquisitions = {};
for ii = 1:length(sessions)
    clear srch;
    srch.path = 'acquisitions';
    srch.sessions.match.x0x5F_id = sessions{ii}.id;
    acquisitions{ii} = obj.search(srch);
end

end