
    Constructor
        function obj = Flywheel(apiKey)
            % Usage Flywheel(apiKey)
            %  apiKey - API Key assigned for each user through the Flywheel UI
            %          apiKey must be in format <domain>:<API token>
            
     Methods (auto-generated)

## Search related
        % search(obj, search_query)

        % getAllBatches(obj)
        % getBatch(obj, id)
        % startBatch(obj, id)

## Collections related
        % getAllCollections(obj)
        % getCollection(obj, id)
        % getCollectionSessions(obj, id)
        % getCollectionAcquisitions(obj, id)
        % getCollectionSessionAcquisitions(obj, id, sid)  
        % addCollection(obj, collection)
        % addAcquisitionsToCollection(obj, id, aqids)
        % addSessionsToCollection(obj, id, sessionids)
        % addCollectionNote(obj, id, text)
        % modifyCollection(obj, id, collection)
        % deleteCollection(obj, id)
        % modifyCollectionFile(obj, id, filename, attributes)
        % setCollectionFileInfo(obj, id, filename, set)
        % replaceCollectionFileInfo(obj, id, filename, replace)  
        % deleteCollectionFileInfoFields(obj, id, filename, keys)
        % uploadFileToCollection(obj, id, path)
        % downloadFileFromCollection(obj, id, name, path)

## Acquisition related
        % getAllAcquisitions(obj)
        % getAcquisition(obj, id)
        % addAcquisition(obj, acquisition)
        % addAcquisitionNote(obj, id, text)
        % addAcquisitionTag(obj, id, tag)
        % modifyAcquisition(obj, id, acquisition)
        % deleteAcquisition(obj, id)
        % modifyAcquisitionFile(obj, id, filename, attributes)
        % setAcquisitionFileInfo(obj, id, filename, set)
        % replaceAcquisitionFileInfo(obj, id, filename, replace)
        % deleteAcquisitionFileInfoFields(obj, id, filename, keys)
        % uploadFileToAcquisition(obj, id, path)
        % downloadFileFromAcquisition(obj, id, name, path)

## Job related
        % getJob(obj, id)
        % getJobLogs(obj, id)
        % addJob(obj, job)  
        % heartbeatJob(obj, id)

## Project related
        % getAllProjects(obj)
        % getProject(obj, id)
        % getProjectSessions(obj, id)
        % addProject(obj, project)
        % addProjectNote(obj, id, text)
        % addProjectTag(obj, id, tag)
        % modifyProject(obj, id, project)
        % deleteProject(obj, id)
        % modifyProjectFile(obj, id, filename, attributes)
        % setProjectFileInfo(obj, id, filename, set)
        % replaceProjectFileInfo(obj, id, filename, replace)
        % deleteProjectFileInfoFields(obj, id, filename, keys)  
        % uploadFileToProject(obj, id, path)
        % downloadFileFromProject(obj, id, name, path)

## Gear related
        % getAllGears(obj)
        % getGear(obj, id)
        % addGear(obj, gear)
        % deleteGear(obj, id)
        % getAllGroups(obj)
        % getGroup(obj, id)
        % addGroup(obj, group)
        % addGroupTag(obj, id, tag)
        % modifyGroup(obj, id, group)
        % deleteGroup(obj, id)

        % getConfig(obj)
        % getVersion(obj)

## Session related
        % getAllSessions(obj)  
        % getSession(obj, id)
        % getSessionAcquisitions(obj, id)
        % addSession(obj, session)
        % addSessionNote(obj, id, text)
        % addSessionTag(obj, id, tag)           
        % modifySession(obj, id, session)   
        % deleteSession(obj, id) 
        % modifySessionFile(obj, id, filename, attributes)
        % setSessionFileInfo(obj, id, filename, set)  
        % replaceSessionFileInfo(obj, id, filename, replace)  
        % deleteSessionFileInfoFields(obj, id, filename, keys)
        % uploadFileToSession(obj, id, path)
        % downloadFileFromSession(obj, id, name, path)
        % getCurrentUser(obj)
        % getAllUsers(obj)
        % getUser(obj, id)
        % addUser(obj, user)
        % modifyUser(obj, id, user)
        % deleteUser(obj,id)

## Static methods in separate files
        % version = getSdkVersion()
        % structFromJson = handleJson(statusPtr,ptrValue)
        % cmdout = testBridge(obj, s)
        % newStruct = replaceField(oldStruct,oldField,newField)
