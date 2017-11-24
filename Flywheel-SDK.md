The Flywheel SDK commands are grouped in various ways; the same command appears in different groups. For example, all the download<> commands are grouped and then all the <>File commands are grouped. 

    Constructor
        function obj = Flywheel(apiKey)
            % Usage Flywheel(apiKey)
            %  apiKey - API Key assigned for each user through the Flywheel UI
            %          apiKey must be in format <domain>:<API token>
            
     Methods (auto-generated)

Here, the methods are organized into four (redundant) lists

* **object** (project, session, acquisition, file, collection, analysis, group, user) 
* **action** (search, add modify, replace, delete, download, upload, get, set).
* **compute** (job, batch, gear)
* **miscellaneous** (about Flywheel)

# Object

### Project
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

### Session
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

### Acquisition
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

### Collections
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

### Analysis
        % getAnalysis(obj, id)
        % downloadFileFromAnalysis(obj, id, name, path)
        % addSessionAnalysisNote(obj, sessionId, analysisId, text)
        % downloadFileFromAnalysis(obj, sessionId, analysisId, filename, path)

### Group
        % getAllGroups(obj)
        % getGroup(obj, id)
        % addGroup(obj, group)
        % addGroupTag(obj, id, tag)
        % modifyGroup(obj, id, group)
        % deleteGroup(obj, id)

### User information
        % getCurrentUser(obj)
        % getAllUsers(obj)
        % getUser(obj, id)
        % addUser(obj, user)
        % modifyUser(obj, id, user)
        % deleteUser(obj,id)

# Action

### Search
        % search(obj, search_query)
        % searchRaw(obj, search_query)

### Add
        % addProject(obj, project)
        % addProjectNote(obj, id, text)
        % addProjectTag(obj, id, tag)

        % addSession(obj, session)
        % addSessionNote(obj, id, text)
        % addSessionTag(obj, id, tag)      

        % addAcquisition(obj, acquisition)
        % addAcquisitionNote(obj, id, text)
        % addAcquisitionTag(obj, id, tag)

        % addCollection(obj, collection)
        % addAcquisitionsToCollection(obj, id, aqids)
        % addSessionsToCollection(obj, id, sessionids)
        % addCollectionNote(obj, id, text)

        % addGroup(obj, group)
        % addGroupTag(obj, id, tag)
        % addUser(obj, user)

### Modify
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

### Replace
        % replaceProjectFileInfo(obj, id, filename, replace)
        % replaceSessionFileInfo(obj, id, filename, replace)
        % replaceAcquisitionFileInfo(obj, id, filename, replace)  
        % replaceCollectionFileInfo(obj, id, filename, replace)  

### Delete
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

### Download
        % downloadFileFromProject(obj, id, name, path)
        % downloadFileFromSession(obj, id, name, path)
        % downloadFileFromAcquisition(obj, id, name, path)
        % downloadFileFromCollection(obj, id, name, path)

### Upload
        % uploadFileToProject(obj, id, path)
        % uploadFileToSession(obj, id, path)
        % uploadFileToAcquisition(obj, id, path)
        % uploadFileToCollection(obj, id, path)

### Get
        % getProject(obj, id)
        % getProjectSessions(obj, id)
        % getAllProjects(obj)

        % getSession(obj, id)
        % getSessionAcquisitions(obj, id)
        % getAllSessions(obj)  

        % getAcquisition(obj, id)
        % getAllAcquisitions(obj)

        % getCollection(obj, id)
        % getCollectionSessions(obj, id)
        % getCollectionSessionAcquisitions(obj, id, sid)
        % getCollectionAcquisitions(obj, id)
        % getAllCollections(obj)

        % getAnalysis(obj, id)

        % getAllGroups(obj)
        % getGroup(obj, id)
        % getCurrentUser(obj)
        % getAllUsers(obj)
        % getUser(obj, id)

        % getAllBatches(obj)
        % getBatch(obj, id)

### Set
        % setProjectFileInfo(obj, id, filename, set)
        % setSessionFileInfo(obj, id, filename, set)  
        % setAcquisitionFileInfo(obj, id, filename, set)
        % setCollectionFileInfo(obj, id, filename, set)

# Compute

### Job
        % getJob(obj, id)
        % getJobLogs(obj, id)
        % addJob(obj, job)  
        % heartbeatJob(obj, id)

### Batch
        % getAllBatches(obj)
        % getBatch(obj, id)
        % startBatch(obj, id)

### Gear
        % getAllGears(obj)
        % getGear(obj, id)
        % addGear(obj, gear)
        % deleteGear(obj, id)

# Flywheel
        % getConfig(obj)
        % getVersion(obj)

# Grep of for function in Flywheel.m
```       function result = getAllBatches(obj)
        function result = getBatch(obj, id)
        function result = startBatch(obj, id)
        function result = getAllCollections(obj)
        function result = getCollection(obj, id)
        function result = getCollectionSessions(obj, id)
        function result = getCollectionAcquisitions(obj, id)
        function result = getCollectionSessionAcquisitions(obj, id, sid)
        function result = addCollection(obj, collection)
        function result = addAcquisitionsToCollection(obj, id, aqids)
        function result = addSessionsToCollection(obj, id, sessionids)
        function result = addCollectionNote(obj, id, text)
        function result = modifyCollection(obj, id, collection)
        function result = deleteCollection(obj, id)
        function result = modifyCollectionFile(obj, id, filename, attributes)
        function result = setCollectionFileInfo(obj, id, filename, set)
        function result = replaceCollectionFileInfo(obj, id, filename, replace)
        function result = deleteCollectionFileInfoFields(obj, id, filename, keys)
        function result = uploadFileToCollection(obj, id, path)
        function result = downloadFileFromCollection(obj, id, name, path)
        function result = getAllGears(obj)
        function result = getGear(obj, id)
        function result = addGear(obj, gear)
        function result = deleteGear(obj, id)
        function result = getAllProjects(obj)
        function result = getProject(obj, id)
        function result = getProjectSessions(obj, id)
        function result = addProject(obj, project)
        function result = addProjectNote(obj, id, text)
        function result = addProjectTag(obj, id, tag)
        function result = modifyProject(obj, id, project)
        function result = deleteProject(obj, id)
        function result = modifyProjectFile(obj, id, filename, attributes)
        function result = setProjectFileInfo(obj, id, filename, set)
        function result = replaceProjectFileInfo(obj, id, filename, replace)
        function result = deleteProjectFileInfoFields(obj, id, filename, keys)
        function result = uploadFileToProject(obj, id, path)
        function result = downloadFileFromProject(obj, id, name, path)
        function result = search(obj, search_query)
        function result = searchRaw(obj, search_query)
        function result = getAllAcquisitions(obj)
        function result = getAcquisition(obj, id)
        function result = addAcquisition(obj, acquisition)
        function result = addAcquisitionNote(obj, id, text)
        function result = addAcquisitionTag(obj, id, tag)
        function result = modifyAcquisition(obj, id, acquisition)
        function result = deleteAcquisition(obj, id)
        function result = modifyAcquisitionFile(obj, id, filename, attributes)
        function result = setAcquisitionFileInfo(obj, id, filename, set)
        function result = replaceAcquisitionFileInfo(obj, id, filename, replace)
        function result = deleteAcquisitionFileInfoFields(obj, id, filename, keys)
        function result = uploadFileToAcquisition(obj, id, path)
        function result = downloadFileFromAcquisition(obj, id, name, path)
        function result = getAnalysis(obj, id)
        function result = addSessionAnalysisNote(obj, sessionId, analysisId, text)
        function result = downloadFileFromAnalysis(obj, sessionId, analysisId, filename, path)
        function result = getCurrentUser(obj)
        function result = getAllUsers(obj)
        function result = getUser(obj, id)
        function result = addUser(obj, user)
        function result = modifyUser(obj, id, user)
        function result = deleteUser(obj, id)
        function result = getAllGroups(obj)
        function result = getGroup(obj, id)
        function result = addGroup(obj, group)
        function result = addGroupTag(obj, id, tag)
        function result = modifyGroup(obj, id, group)
        function result = deleteGroup(obj, id)
        function result = getJob(obj, id)
        function result = getJobLogs(obj, id)
        function result = addJob(obj, job)
        function result = heartbeatJob(obj, id)
        function result = getConfig(obj)
        function result = getVersion(obj)
        function result = getAllSessions(obj)
        function result = getSession(obj, id)
        function result = getSessionAcquisitions(obj, id)
        function result = addSession(obj, session)
        function result = addSessionNote(obj, id, text)
        function result = addSessionTag(obj, id, tag)
        function result = modifySession(obj, id, session)
        function result = deleteSession(obj, id)
        function result = modifySessionFile(obj, id, filename, attributes)
        function result = setSessionFileInfo(obj, id, filename, set)
        function result = replaceSessionFileInfo(obj, id, filename, replace)
        function result = deleteSessionFileInfoFields(obj, id, filename, keys)
        function result = uploadFileToSession(obj, id, path)
        function result = downloadFileFromSession(obj, id, name, path)
        function version = getSdkVersion()
```