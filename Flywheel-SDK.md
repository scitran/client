The Matlab scitran client is designed to be a clear interface to the Flywheel SDK commands.  

## Installing the SDK2 (modern stuff)

We download the SDK2 as a matlab toolbox that will be installed in the Add-Ons directory. As of April 12, 2018, Here is a link.  This might be updated over time, and we need a more automated procedure for doing the install for updates.

https://storage.googleapis.com/flywheel-dist/sdk/alphas/flywheel-sdk-2.1.2-rc.5.mltbx

Here are the api calls

https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html

And the base wiki

https://flywheel-io.github.io/core/

## Mac/Windows

On Mac and Windows (probably) just click on the file.

## Linux

[Mathworks instructions for Linux](https://www.mathworks.com/help/matlab/ref/matlab.addons.toolbox.installtoolbox.html).  Basically, do this.

    tbxFile = 'flywheel-sdk-2.1.2-rc.5.mltbx';
    tbx = matlab.addons.toolbox.installToolbox(tbxFile)

If this is the first time you are installing on Linux, a directory 'Add-Ons' will be created in your userpath directory.  You should make sure that Add-Ons is included in your path, such as

    addpath(genpath((fullfile(userpath,'Add-Ons'))));

## Programming
This page lists the Flywheel SDK commands, grouped redundantly in two organizations. First, there is a list in terms of the objects, and then there is a list in terms of the actions.

For example, all the project methods are listed, which include downloadProject.  Then the download methods are listed, which also includes downloadProject. 

The methods listed here are part of the Flywheel.m class file, which is created and attached whenever you create a scitran instance.

This is the Flywheel SDK constructor

        function obj = Flywheel(apiKey)
            % Usage Flywheel(apiKey)
            %  apiKey - API Key assigned for each user through the Flywheel UI
            %          apiKey must be in format <domain>:<API token>
            
The constructor and its methods are auto-generated for several languages (Matlab, Python, and R) as part of the Flywheel SDK.

Below, the methods are organized into four (redundant) lists

* **object** (project, session, acquisition, file, collection, analysis, group, user) 
* **action** (search, add, modify, replace, delete, download, upload, get, set).
* **compute** (job, batch, gear)
* **miscellaneous** (about Flywheel)

A list of the Flywheel.m methods obtained by running 'grep function Flywheel.m' is [on this page](Flywheel-methods-list).

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

### File Info
        % setProjectFileInfo(obj, id, filename, set)
        % replaceProjectFileInfo(obj, id, filename, replace)
        % deleteProjectFileInfoFields(obj, id, filename, keys)  
        % setSessionFileInfo(obj, id, filename, set)  
        % replaceSessionFileInfo(obj, id, filename, replace)  
        % deleteSessionFileInfoFields(obj, id, filename, keys)
        % setAcquisitionFileInfo(obj, id, filename, set)
        % replaceAcquisitionFileInfo(obj, id, filename, replace)
        % deleteAcquisitionFileInfoFields(obj, id, filename, keys)
        % setCollectionFileInfo(obj, id, filename, set)
        % replaceCollectionFileInfo(obj, id, filename, replace)  
        % deleteCollectionFileInfoFields(obj, id, filename, keys)

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
        % downloadFileFromAnalysis(obj, sessionId, analysisId, name, path)

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

