%% Test file deletion
%
%
% BW, Scitran Team, 2017

files = st.search('files','project label',thisProject,'file container','projects');
for ii=1:length(files)
    files{ii}.source.name
end

for ii=1:length(files)
    st.deleteFile(files{ii});
end

%%  Deletes all the session attachments

thisProject =  'BIDS-Test';
sessions = st.search('sessions','project label',thisProject);
for ii=1:length(sessions)
    files = st.search('files','session id',sessions{ii}.id,'file container','sessions');
    fprintf('Deleting %d files for session %s\n',length(files),sessions{ii}.source.label);
    for ff = 1:length(files)
        st.deleteFile(files{ff});
    end
end

%%