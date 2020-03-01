st = scitran('stanfordlabs');
st.verify;

% Read the Google Spreadsheet with the metadata (example HCP)
ProjectName = 'HCP_preproc';
DOCID       = '1gqtgGHTV7WDynqA6eXooGvmYGucoIQNkcdLVAnGeV74';
TABID       = '552262644';
DOCURL      = ['https://docs.google.com/spreadsheets/d/' ...
                DOCID '/export?gid=' TABID '&format=csv'];
mddt        = readtable(websave('tmp', DOCURL));
mddt.DIR    = categorical(string(mddt.DIR));
mddt.HCPID  = categorical(string(mddt.HCPID));
mddt.sesId  = categorical(repmat("notAssigned", [height(mddt),1]));



% Obtain results knowing the subject names
sessions = st.search('session', 'project label exact', ProjectName);
for ns=1:length(sessions)
    sesCode  = sessions{ns}.subject.code;
    sesLabel = sessions{ns}.session.label;
    sesId    = sessions{ns}.session.id;
    mddt{mddt.HCPID==sesCode & mddt.DIR==sesLabel,'sesId'} = string(sesId);
end

% Instead of using the excel file, use the collection feature in FW
myCollectionName = 'FWmatlabAPI_test';
collections = st.fw.getAllCollections();
for nc=1:length(collections)
    if strcmp(collections{nc}.label, myCollectionName)
        collectionID = collections{nc}.id;
    end
end
thisCollection        = st.fw.getCollection(collectionID);
sessionsInCollection  = st.fw.getCollectionSessions(idGet(thisCollection));
thisSession           = sessionsInCollection{2};
analysesInThisSession = st.fw.getSessionAnalyses(idGet(thisSession));

for i = 1:numel(analysesInThisSession)
    fprintf('%s\n', analysesInThisSession{i}.label);
end

thisAnalysis = st.fw.getAnalysis(idGet(analysesInThisSession{5}))
afqPipelineParams = thisAnalysis.job.config.config;





% With search
projects     = st.list('project','wandell');
projects     =  projects(1:23);
for np=1:length(projects)
    fprintf('\n\nPROJECT %i: %s\n', np, projects{np}.label)
    fprintf('-------------------------\n')
    sessions     = st.list('session', idGet(projects{np}));
    if ~isempty(sessions)
        for ns=1:length(sessions)
            % fprintf('\n\nSESSION %i: %s>%s', ns, sessions{ns}.subject.code, sessions{ns}.label)
            disp(['SESSION ' num2str(ns) ': ' sessions{ns}.subject.code ' > ' sessions{ns}.label])
            % if ~isempty(sessions{ns}.analyses)
               % acquisitions = st.list('acquisition',idGet(sessions{ns})); 
               analyses        = st.list('analysis',idGet(sessions{ns}));
               analyses       = st.fw.getAnalyses('project', idGet(projects{np}), 'session');
               
            % end
        end
    end
end




