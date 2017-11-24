The Flywheel SDK commands are grouped in various ways; the same command appears in different groups. For example, all the download<> commands are grouped and then all the <>File commands are grouped. 

    Constructor
        function obj = Flywheel(apiKey)
            % Usage Flywheel(apiKey)
            %  apiKey - API Key assigned for each user through the Flywheel UI
            %          apiKey must be in format <domain>:<API token>
            
     Methods (auto-generated)

## Search
        % search(obj, search_query)

## Project
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

## Session
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

## Acquisition
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

## Collections
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

## Group
        % getAllGroups(obj)
        % getGroup(obj, id)
        % addGroup(obj, group)
        % addGroupTag(obj, id, tag)
        % modifyGroup(obj, id, group)
        % deleteGroup(obj, id)

## User information
        % getCurrentUser(obj)
        % getAllUsers(obj)
        % getUser(obj, id)
        % addUser(obj, user)
        % modifyUser(obj, id, user)
        % deleteUser(obj,id)

## Job
        % getJob(obj, id)
        % getJobLogs(obj, id)
        % addJob(obj, job)  
        % heartbeatJob(obj, id)

## Compute
        % getAllBatches(obj)
        % getBatch(obj, id)
        % startBatch(obj, id)

## Gear
        % getAllGears(obj)
        % getGear(obj, id)
        % addGear(obj, gear)
        % deleteGear(obj, id)

## Flywheel
        % getConfig(obj)
        % getVersion(obj)

## Add

## Modify
        % modifyProject(obj, id, project)
        % modifyProjectFile(obj, id, filename, attributes)
        % modifySession(obj, id, session)
        % modifySessionFile(obj, id, filename, attributes)
        % modifyAcquisition(obj, id, acquisition)
        % modifyAcquisitionFile(obj, id, filename, attributes)
        % modifyCollection(obj, id, collection)
        % modifyCollectionFile(obj, id, filename, attributes)

        % modifyUser(obj, id, user)
        % modifyGroup(obj, id, group)

## Replace

## Delete
        % deleteProject(obj, id)
        % deleteProjectFileInfoFields(obj, id, filename, keys)  
        % deleteSession(obj, id) 
        % deleteSessionFileInfoFields(obj, id, filename, keys)
        % deleteAcquisition(obj, id)
        % deleteAcquisitionFileInfoFields(obj, id, filename, keys)
        % deleteCollection(obj, id)
        % deleteCollectionFileInfoFields(obj, id, filename, keys)

        % deleteGroup(obj, id)
        % deleteUser(obj,id)

        % deleteGear(obj, id)

## Download

## Upload

## Get

## Set

