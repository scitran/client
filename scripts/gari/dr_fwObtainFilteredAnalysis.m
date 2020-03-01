function addThisAnalysisIdToMyResults = dr_fwObtainFilteredAnalysis(st, thisSession, gearName, gearVersion)
%DR_FWOBTAINFILTEREDANALYSIS Summary of this function goes here

% TODO: make it multiparameter, any combination


% Obtain all the analyses for this specific session
analysesInThisSession = st.fw.getSessionAnalyses(idGet(thisSession));

% Take only the analyses we are interested
addThisAnalysisIdToMyResults = {}; nav = 1; 
if ~isempty(analysesInThisSession) % FC: check if empty and obtain only the gearName+gearVersion analyses
    for na=1:length(analysesInThisSession)
        thisAnalysis      = st.fw.getAnalysis(idGet(analysesInThisSession{na}));
        % We do not care about thisAnalysis.label, this can be anything. We
        % could be consistent with the name for our analyses but it is not
        % going to be future proof. Better to be sure that we use the same
        % gearName and same gearVersion (even then, the specific analysis
        % parameters can be different!, see TMAT2 above
        % FC: [gearID, thisGear, thisGearName, thisGearVersion] = gearInfoObtainFromAnalysis(thisAnalysis)
        gearId            = thisAnalysis.job.gearId;
        thisGear          = st.fw.getGear(gearId);
        thisGearName      = thisGear.gear.name;
        thisGearVersion   = thisGear.gear.version;
        % Now check if this is the gearName and gearVersion we want
        if (strcmp(thisGearName, gearName) & strcmp(thisGearVersion, gearVersion))
            addThisAnalysisIdToMyResults{nav} = thisAnalysis; nav = nav+1;
        end
    end
end




end

