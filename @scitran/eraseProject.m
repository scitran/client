function  eraseProject(obj, projectID)
% remove a project completely
%
%    st.eraseProject('projectId')
%
% uses the projectHierarchy method to build the hierarchy of
% project,sessions and acquisitions that will be deleted.
%
%% WARNING WARNING WARNING
%  Unfortunately there is no proper testing yet for this method.
%  Therefore a bug could be destructive. 
%  It is IMPORTANT to verify the number of acquisitions sessions and the
%  project that we are deleting.
%  possible bugs could originate from the
%  scitran.projectHierarchy dependency or in the search results retrieved 
%  by this method.
%  More subtle bugs could be related to the JSON library we are using.
%  If, for example the 'x0x5Fid', is not converted to '_id' in the JSON 
%  sent to the API
%
%  RF
%%
[project, sess, acqs] = obj.projectHierarchy('x0x5Fid', projectID);
length_acqs = 0;
%% compute the total length of the acquisitions collected
for ii = 1:length(acqs)
    length_acqs = length(acqs{ii}) + length_acqs;
end
%% ask the user to confirm the project label, the number of sessions, the 
%% number of acquisitions and the instance from which we are erasing the project
prompt = sprintf('Deleting %d sessions and %d acquisitions from project %s on %s. This action is irreversible. Confirm deletion? (y/n): ', length(sess), length_acqs, project.source.label, obj.url);
response = input(prompt,'s');
if lower(response) == 'y'
    %% loop over the acquisitions and delete them
    for ii = 1:length(acqs)
        sessAcqs = acqs{ii};
        for jj = 1:length(sessAcqs)
            cmd = obj.deleteContainerCmd('acquisitions', sessAcqs{jj}.id);
            [~,~] = system(cmd);
        end
    end
    %% loop over the sessions and delete them
    for ii = 1:length(sess)
        cmd = obj.deleteContainerCmd('sessions', sess{ii}.id);
        [~,~] = system(cmd);
    end
    %% delete the project
    cmd = obj.deleteContainerCmd('projects', projectID);
    [~,~] = system(cmd);
else
    disp('Aborting');
    return
end

end