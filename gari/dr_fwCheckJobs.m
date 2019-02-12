function joblist = dr_fwCheckJobs(serverName, collectionName)
% Return the jobs running in this collection. 
% First version: print it on screen
% Second: return a list of IDs


% Example inputs to make it work
%{
clear all; clc;

serverName     = 'stanfordlabs';
collectionName = 'FWmatlabAPI_test';
collectionName = 'ComputationalReproducibility';
collectionName = 'GariWH';
collectionName = 'CompRepCheck';
collectionName = 'HCPTEST';
%}

% 2018: GLU, Vistalab garikoitz@gmail.com



%% 1.- Connect to the collection, verify it and show the number of sessions for verification
st = scitran(serverName);
st.verify;
% FC: obtain collection ID from the collection name
collectionID = '';
collections  = st.fw.getAllCollections();
for nc=1:length(collections)
    if strcmp(collections{nc}.label, collectionName)
        collectionID = collections{nc}.id;
    end
end

if isempty(collectionID)
    error(fprintf('Collection %s could not be found on the server %s (verify permissions or the collection name).\n', collectionName, serverName))
else
    thisCollection        = st.fw.getCollection(collectionID);
    sessionsInCollection  = st.fw.getCollectionSessions(idGet(thisCollection));
    fprintf('There are %i sessions in the collection %s (server %s).\n', length(sessionsInCollection), collectionName, st.instance)
end


%% 2.- Find all the jobs running per session
nOfJobs = 0;

% TableElements = {'Proj', 'SubjID','TRT', 'label', 'state', 'gearName', 'gearVersion', 'Analysis'};
for ns=1:length(sessionsInCollection)
    % Get info for the session
    thisSession = sessionsInCollection{ns};
    % Get info for the project the session belong to
    thisProject = st.fw.getProject(thisSession.project);
    % Only apply it to HCP for now, or use this to discriminate between projects
    % when upgrading
    % Possible 'states': 'cancelled', 'pending', 'complete', 'running', 'failed'
    % if exist('state','var')
    %     thisJobs = st.fw.getSessionJobs(idGet(thisSession), 'states', state);
    % else
        % thisJobs = st.fw.getSessionJobs(idGet(thisSession)); % This is for the list in provenance, we want the list in analyses
        thisAnalyses = st.fw.getSessionAnalyses(idGet(thisSession));
    % end
    fprintf('(%d) %s >> %s (%s)\n', ns, thisProject.label, thisSession.subject.code, thisSession.label)
    if ~isempty(thisAnalyses)
        T = struct();
        for ntj=1:length(thisAnalyses)
            thisAnalysis      = st.fw.getAnalysis(thisAnalyses{ntj}.id);
            
            T(ntj).Proj        = string(thisProject.label);
            T(ntj).SubjID      = string(thisSession.subject.code);
            T(ntj).TRT         = string(thisSession.label);
            T(ntj).label       = string(thisAnalysis.label);
            T(ntj).collection  = string(collectionName);
            if isempty(thisAnalysis.job)
                T(ntj).state       = "uploaded";
            else
                T(ntj).state       = string(thisAnalysis.job.state);
            end
            if isempty(thisAnalysis.gearInfo)
                T(ntj).gearName = "NoInformation";
            else
                T(ntj).gearName    = string(thisAnalysis.gearInfo.name);
            end
            if isempty(thisAnalysis.gearInfo)
                T(ntj).gearVersion = "NoInformation";
            else
                T(ntj).gearVersion = string(thisAnalysis.gearInfo.version);
            end
            T(ntj).Analysis    = thisAnalysis.struct;
            if isempty(thisAnalysis.job)
                T(ntj).JobCreated  = "01-Jan-1970 00:00:00";
                T(ntj).JobModified = "01-Jan-1970 00:00:00";
            else
                T(ntj).JobCreated  = datetime(thisAnalysis.job.created);
                T(ntj).JobModified = datetime(thisAnalysis.job.modified);
            end
        end
        T = struct2table(T);
        
%         T.SubjID   = categorical(string(repmat(thisSession.subject.code, [length(thisAnalyses), 1])));
%         T.TRT      = categorical(string(repmat(thisSession.label       , [length(thisAnalyses), 1])));
%         T.Proj     = categorical(string(repmat(thisProject.label       , [length(thisAnalyses), 1])));
%         analyses     = {};
%         states       = {};
%         labels       = {};
%         gearNames    = {};
%         gearVersions = {};
%         created      = {};
%         modified     = {};
        % T          = array2table(NaN(length(thisAnalyses),length(TableElements)));
        % T.Properties.VariableNames = TableElements;
%         for ntj=1:length(thisAnalyses)
%             thisAnalysis      = st.fw.getAnalysis(thisAnalyses{ntj}.id);
%             analyses{ntj}     = struct2table(thisAnalysis.struct, 'AsArray', true);
%             states{ntj}       = thisAnalysis.job.state;
%             labels{ntj}       = thisAnalysis.label;
%             gearNames{ntj}    = thisAnalysis.gearInfo.name;
%             gearVersions{ntj} = thisAnalysis.gearInfo.version;
%             created{ntj}      = datetime(thisAnalysis.job.created);
%             modified{ntj}     = datetime(thisAnalysis.job.modified);            
%         end
%         T.Analysis    = analyses';
%         T.state       = categorical(states');
%         T.label       = categorical(labels');
%         T.gearName    = categorical(gearNames');
%         T.gearVersion = categorical(gearVersions');
%         T.JobCreated  = created';
%         T.JobModified = modified';
        % T.JobCreated  = datetime(T.JobCreated);
        % T.JobModified = datetime(T.JobModified);
        if ~exist('joblist','var')
            joblist = T;
        else
            joblist = [joblist; T];
        end
        
        %{
        for ntj=1:length(thisJobs.jobs)
            thisGear = st.fw.getGear(thisJobs.jobs{ntj}.gearId);
            nOfJobs = nOfJobs +1;
            if strcmp(gearName, 'NO')
                fprintf('   ... (%d) Gear %s (q%s) ... \n', nOfJobs, thisGear.gear.name, thisGear.gear.version)
            end
            if (strcmp(gearName, thisGear.gear.name) & strcmp(gearVersion, thisGear.gear.version))
                fprintf('   ... (%d) Gear %s (q%s) ... \n', nOfJobs, thisGear.gear.name, thisGear.gear.version)
            end
        end
    else
        fprintf('   ... no %s jobs\n', state)
        %}
    end
end

joblist.Proj        = categorical(joblist.Proj);
joblist.SubjID      = categorical(joblist.SubjID);
joblist.TRT         = categorical(joblist.TRT);
joblist.label       = categorical(joblist.label);
joblist.collection  = categorical(joblist.collection);
joblist.state       = categorical(joblist.state);
joblist.gearName    = categorical(joblist.gearName);
joblist.gearVersion = categorical(joblist.gearVersion);

%% Check by number of input files
%{
for ns=1:length(sessionsInCollection)
    % Get info for the session
    thisSession = sessionsInCollection{ns};
    % Get info for the project the session belong to
    thisProject = st.fw.getProject(thisSession.project);
    acqus  = st.list('acquisitions',idGet(thisSession));
    for na=1:length(acqus)
        acqu = acqus{na};
        if strcmp(acqu.label,'Diffusion')
            if size(acqu.files,1) ~= 12
                fprintf('Working in session: %s >> %s (%s)\n', thisProject.label, thisSession.subject.code, thisSession.label)
            end
        end
    end
end
%}