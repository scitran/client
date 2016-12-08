function  eraseProject(obj, projectID)

[project, sess, acqs] = obj.projectHierarchy('x0x5F_id', projectID);
length_acqs = 0;
for ii = 1:length(acqs)
    length_acqs = length(acqs{ii}) + length_acqs;
end
prompt = sprintf('Deleting %d sessions and %d acquisitions from project %s on %s. This action is irreversible. Confirm deletion? (y/n): ', length(sess), length_acqs, project.source.label, obj.url);
response = input(prompt,'s');
if lower(response) == 'y'
    for ii = 1:length(acqs)
        sessAcqs = acqs{ii};
        for jj = 1:length(sessAcqs)
            cmd = obj.deleteContainerCmd('acquisitions', sessAcqs{jj}.id);
            [~,~] = system(cmd);
        end
    end
    for ii = 1:length(sess)
        cmd = obj.deleteContainerCmd('sessions', sess{ii}.id);
        [~,~] = system(cmd);
    end
    cmd = obj.deleteContainerCmd('projects', projectID);
    [~,~] = system(cmd);
else
    disp('Aborting');
    return
end

end