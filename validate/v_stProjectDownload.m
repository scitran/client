%% Download an entire project 
%
% Used to start the process of making a BIDS compliant directory tree
%
% v_stProjectDownload

%%
chdir(fullfile(stRootPath,'local'));

%% Open a channel
st = scitran('vistalab');

%% Choose the project

projectLabel = 'BIDS-Test';
[~, id] = st.exist(projectLabel,'projects');
projectID  = id{1};

%%  Download to a tar file
tarfile = 'deleteMe';
destination = st.download('project',projectID,'destination',[tarfile,'.tar']);

%% Untar and move the directory up
untar(destination,tarfile);

% How do we get the group label, in this case 'wandell'?
movefile(fullfile(pwd,tarfile,'scitran','wandell',projectLabel),fullfile(pwd));
delete(destination)
rmdir(tarfile,'s');

%% Now, rearrange the files to be in the BIDS organization
subjectMetaFiles = dirPlus('FIND the bids@sub files')
for ii=1:length(subjectMetaFiles)
    % Move the files into the appropriate sub folder
    %
end

%% Do we strip the sub-01 and rename the sub-01-XXX folders?


%%

% jstruct = jsonread('projectTicket.json');
% 
% case {'projectticket'}
% 
%     
%     
%     
%     
%     % Basic idea to get a ticket for download
%     
%     clear payload
%     payload.optional = true;
%     payload.nodes.level = 'project';
%     payload.nodes.x0x5Fid = project{1}.id;
%     
%     % Format for curl command
%     jPayload = jsonwrite(payload,struct('indent','  ','replacementstyle','hex'));
%     jPayload = regexprep(jPayload, '\n|\t', ' ');
%     jPayload = regexprep(jPayload, ' *', ' ');
%     
%     jPayload = strrep(jPayload,'"nodes":','"nodes":[');
%     jPayload = strrep(jPayload,'" } ','" }] ');
%     
%     cmd = sprintf('curl ''%s/api/download'' -H ''Authorization: %s'' --data-binary ''%s''',st.url, st.showToken, jPayload);
%     [status, result] = system(cmd);
%     
%     sResult = jsonread(result);
%     
%     % curl https://flywheel.scitran.stanford.edu -H "Authorization":"scitran-user OQlKDTTTlkZsmDDQi_Pz3r1-_2E1m5D24REuP_3LNggUrwEkMVI1Up3i" --data-binary '{ "optional": true, "nodes": { "level": "project", "_id": "5993e2ba97276d001b87ed6c" } }'
%     
%     % curl 'https://flywheel.scitran.stanford.edu/api/download'
%     % -H 'Authorization: z9Ssc187IE_Kb28h-6u6n6aoiwvaZtHSFx9if5Z-ijvGT3yhA9bS-Pjd'
%     % --data-binary '{"optional":true,"nodes":[{"level":"project","_id":"5993e2ba97276d001b87ed6c"}]}'
%     
%     case {'projectdownload'}
%         % With the ticket, which is only good for a minute, you can download the
%         % whole thing.
%         % curl 'https://flywheel.scitran.stanford.edu/api/download?ticket=e0cd7b7e-9b2e-4310-aebc-bcb3c823643b'
%         
%         dcmd = sprintf('curl ''%s/api/download?ticket=%s'' > deleteMe.tar',st.url,foo.ticket);
%         
%         [status, result] = system(dcmd);
% 
% 
% %%
% cmd = 'curl 'https://flywheel.scitran.stanford.edu' -H 'Authorization: OQlKDTTTlkZsmDDQi_Pz3r1-_2E1m5D24REuP_3LNggUrwEkMVI1Up3i' --data-binary '{ "optional": true, "nodes": { "level": "project", "_id": "5993e2ba97276d001b87ed6c" } }'';
% jPayload = '{ "optional": true, "nodes": [{ "level": "project", "_id": "5993e2ba97276d001b87ed6c" }]}';
