
    Constructor
        function obj = Flywheel(apiKey)
            % Usage Flywheel(apiKey)
            %  apiKey - API Key assigned for each user through the Flywheel UI
            %          apiKey must be in format <domain>:<API token>
            
            


        %
        % AUTO GENERATED CODE FOLLOWS
        %

        % getAllBatches
        function result = getAllBatches(obj)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetAllBatches ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getBatch
        function result = getBatch(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetBatch ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % startBatch
        function result = startBatch(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk StartBatch ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getAllCollections
        function result = getAllCollections(obj)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetAllCollections ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getCollection
        function result = getCollection(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetCollection ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getCollectionSessions
        function result = getCollectionSessions(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetCollectionSessions ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getCollectionAcquisitions
        function result = getCollectionAcquisitions(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetCollectionAcquisitions ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getCollectionSessionAcquisitions
        function result = getCollectionSessionAcquisitions(obj, id, sid)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetCollectionSessionAcquisitions ' obj.key ' '  '''' id ''' ' '''' sid ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addCollection
        function result = addCollection(obj, collection)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            collection = Flywheel.replaceField(collection,oldField,newField);
            collection = savejson('',collection);
            [status,cmdout] = system([obj.folder '/sdk AddCollection ' obj.key ' '  '''' collection ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addAcquisitionsToCollection
        function result = addAcquisitionsToCollection(obj, id, aqids)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            aqids = Flywheel.replaceField(aqids,oldField,newField);
            aqids = savejson('',aqids);
            [status,cmdout] = system([obj.folder '/sdk AddAcquisitionsToCollection ' obj.key ' '  '''' id ''' ' '''' aqids ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addSessionsToCollection
        function result = addSessionsToCollection(obj, id, sessionids)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            sessionids = Flywheel.replaceField(sessionids,oldField,newField);
            sessionids = savejson('',sessionids);
            [status,cmdout] = system([obj.folder '/sdk AddSessionsToCollection ' obj.key ' '  '''' id ''' ' '''' sessionids ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addCollectionNote
        function result = addCollectionNote(obj, id, text)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk AddCollectionNote ' obj.key ' '  '''' id ''' ' '''' text ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % modifyCollection
        function result = modifyCollection(obj, id, collection)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            collection = Flywheel.replaceField(collection,oldField,newField);
            collection = savejson('',collection);
            [status,cmdout] = system([obj.folder '/sdk ModifyCollection ' obj.key ' '  '''' id ''' ' '''' collection ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % deleteCollection
        function result = deleteCollection(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk DeleteCollection ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % modifyCollectionFile
        function result = modifyCollectionFile(obj, id, filename, attributes)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            attributes = Flywheel.replaceField(attributes,oldField,newField);
            attributes = savejson('',attributes);
            [status,cmdout] = system([obj.folder '/sdk ModifyCollectionFile ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' attributes ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % setCollectionFileInfo
        function result = setCollectionFileInfo(obj, id, filename, set)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            set = Flywheel.replaceField(set,oldField,newField);
            set = savejson('',set);
            [status,cmdout] = system([obj.folder '/sdk SetCollectionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' set ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % replaceCollectionFileInfo
        function result = replaceCollectionFileInfo(obj, id, filename, replace)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            replace = Flywheel.replaceField(replace,oldField,newField);
            replace = savejson('',replace);
            [status,cmdout] = system([obj.folder '/sdk ReplaceCollectionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' replace ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % deleteCollectionFileInfoFields
        function result = deleteCollectionFileInfoFields(obj, id, filename, keys)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            keys = Flywheel.replaceField(keys,oldField,newField);
            keys = savejson('',keys);
            [status,cmdout] = system([obj.folder '/sdk DeleteCollectionFileInfoFields ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' keys ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % uploadFileToCollection
        function result = uploadFileToCollection(obj, id, path)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk UploadFileToCollection ' obj.key ' '  '''' id ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % downloadFileFromCollection
        function result = downloadFileFromCollection(obj, id, name, path)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk DownloadFileFromCollection ' obj.key ' '  '''' id ''' ' '''' name ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % search
        function result = search(obj, search_query)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            search_query = Flywheel.replaceField(search_query,oldField,newField);
            search_query = savejson('',search_query);
            [status,cmdout] = system([obj.folder '/sdk Search ' obj.key ' '  '''' search_query ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getAllAcquisitions
        function result = getAllAcquisitions(obj)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetAllAcquisitions ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getAcquisition
        function result = getAcquisition(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetAcquisition ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addAcquisition
        function result = addAcquisition(obj, acquisition)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            acquisition = Flywheel.replaceField(acquisition,oldField,newField);
            acquisition = savejson('',acquisition);
            [status,cmdout] = system([obj.folder '/sdk AddAcquisition ' obj.key ' '  '''' acquisition ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addAcquisitionNote
        function result = addAcquisitionNote(obj, id, text)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk AddAcquisitionNote ' obj.key ' '  '''' id ''' ' '''' text ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addAcquisitionTag
        function result = addAcquisitionTag(obj, id, tag)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk AddAcquisitionTag ' obj.key ' '  '''' id ''' ' '''' tag ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % modifyAcquisition
        function result = modifyAcquisition(obj, id, acquisition)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            acquisition = Flywheel.replaceField(acquisition,oldField,newField);
            acquisition = savejson('',acquisition);
            [status,cmdout] = system([obj.folder '/sdk ModifyAcquisition ' obj.key ' '  '''' id ''' ' '''' acquisition ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % deleteAcquisition
        function result = deleteAcquisition(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk DeleteAcquisition ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % modifyAcquisitionFile
        function result = modifyAcquisitionFile(obj, id, filename, attributes)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            attributes = Flywheel.replaceField(attributes,oldField,newField);
            attributes = savejson('',attributes);
            [status,cmdout] = system([obj.folder '/sdk ModifyAcquisitionFile ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' attributes ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % setAcquisitionFileInfo
        function result = setAcquisitionFileInfo(obj, id, filename, set)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            set = Flywheel.replaceField(set,oldField,newField);
            set = savejson('',set);
            [status,cmdout] = system([obj.folder '/sdk SetAcquisitionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' set ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % replaceAcquisitionFileInfo
        function result = replaceAcquisitionFileInfo(obj, id, filename, replace)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            replace = Flywheel.replaceField(replace,oldField,newField);
            replace = savejson('',replace);
            [status,cmdout] = system([obj.folder '/sdk ReplaceAcquisitionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' replace ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % deleteAcquisitionFileInfoFields
        function result = deleteAcquisitionFileInfoFields(obj, id, filename, keys)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            keys = Flywheel.replaceField(keys,oldField,newField);
            keys = savejson('',keys);
            [status,cmdout] = system([obj.folder '/sdk DeleteAcquisitionFileInfoFields ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' keys ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % uploadFileToAcquisition
        function result = uploadFileToAcquisition(obj, id, path)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk UploadFileToAcquisition ' obj.key ' '  '''' id ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % downloadFileFromAcquisition
        function result = downloadFileFromAcquisition(obj, id, name, path)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk DownloadFileFromAcquisition ' obj.key ' '  '''' id ''' ' '''' name ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getJob
        function result = getJob(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetJob ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getJobLogs
        function result = getJobLogs(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetJobLogs ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addJob
        function result = addJob(obj, job)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            job = Flywheel.replaceField(job,oldField,newField);
            job = savejson('',job);
            [status,cmdout] = system([obj.folder '/sdk AddJob ' obj.key ' '  '''' job ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % heartbeatJob
        function result = heartbeatJob(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk HeartbeatJob ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getAllProjects
        function result = getAllProjects(obj)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetAllProjects ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getProject
        function result = getProject(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetProject ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getProjectSessions
        function result = getProjectSessions(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetProjectSessions ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addProject
        function result = addProject(obj, project)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            project = Flywheel.replaceField(project,oldField,newField);
            project = savejson('',project);
            [status,cmdout] = system([obj.folder '/sdk AddProject ' obj.key ' '  '''' project ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addProjectNote
        function result = addProjectNote(obj, id, text)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk AddProjectNote ' obj.key ' '  '''' id ''' ' '''' text ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addProjectTag
        function result = addProjectTag(obj, id, tag)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk AddProjectTag ' obj.key ' '  '''' id ''' ' '''' tag ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % modifyProject
        function result = modifyProject(obj, id, project)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            project = Flywheel.replaceField(project,oldField,newField);
            project = savejson('',project);
            [status,cmdout] = system([obj.folder '/sdk ModifyProject ' obj.key ' '  '''' id ''' ' '''' project ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % deleteProject
        function result = deleteProject(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk DeleteProject ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % modifyProjectFile
        function result = modifyProjectFile(obj, id, filename, attributes)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            attributes = Flywheel.replaceField(attributes,oldField,newField);
            attributes = savejson('',attributes);
            [status,cmdout] = system([obj.folder '/sdk ModifyProjectFile ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' attributes ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % setProjectFileInfo
        function result = setProjectFileInfo(obj, id, filename, set)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            set = Flywheel.replaceField(set,oldField,newField);
            set = savejson('',set);
            [status,cmdout] = system([obj.folder '/sdk SetProjectFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' set ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % replaceProjectFileInfo
        function result = replaceProjectFileInfo(obj, id, filename, replace)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            replace = Flywheel.replaceField(replace,oldField,newField);
            replace = savejson('',replace);
            [status,cmdout] = system([obj.folder '/sdk ReplaceProjectFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' replace ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % deleteProjectFileInfoFields
        function result = deleteProjectFileInfoFields(obj, id, filename, keys)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            keys = Flywheel.replaceField(keys,oldField,newField);
            keys = savejson('',keys);
            [status,cmdout] = system([obj.folder '/sdk DeleteProjectFileInfoFields ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' keys ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % uploadFileToProject
        function result = uploadFileToProject(obj, id, path)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk UploadFileToProject ' obj.key ' '  '''' id ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % downloadFileFromProject
        function result = downloadFileFromProject(obj, id, name, path)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk DownloadFileFromProject ' obj.key ' '  '''' id ''' ' '''' name ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getAllGears
        function result = getAllGears(obj)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetAllGears ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getGear
        function result = getGear(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetGear ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addGear
        function result = addGear(obj, gear)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            gear = Flywheel.replaceField(gear,oldField,newField);
            gear = savejson('',gear);
            [status,cmdout] = system([obj.folder '/sdk AddGear ' obj.key ' '  '''' gear ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % deleteGear
        function result = deleteGear(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk DeleteGear ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getAllGroups
        function result = getAllGroups(obj)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetAllGroups ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getGroup
        function result = getGroup(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetGroup ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addGroup
        function result = addGroup(obj, group)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            group = Flywheel.replaceField(group,oldField,newField);
            group = savejson('',group);
            [status,cmdout] = system([obj.folder '/sdk AddGroup ' obj.key ' '  '''' group ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % addGroupTag
        function result = addGroupTag(obj, id, tag)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk AddGroupTag ' obj.key ' '  '''' id ''' ' '''' tag ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % modifyGroup
        function result = modifyGroup(obj, id, group)
            statusPtr = libpointer('int32Ptr',-100);
            oldField = 'id';
            newField = 'x0x5F_id';
            group = Flywheel.replaceField(group,oldField,newField);
            group = savejson('',group);
            [status,cmdout] = system([obj.folder '/sdk ModifyGroup ' obj.key ' '  '''' id ''' ' '''' group ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % deleteGroup
        function result = deleteGroup(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk DeleteGroup ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getConfig
        function result = getConfig(obj)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetConfig ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        % getVersion
        function result = getVersion(obj)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk GetVersion ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
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

        
        % AUTO GENERATED CODE ENDS
    end

    methods (Static)
        function version = getSdkVersion()
            version = '0.2.0';
        end
        function structFromJson = handleJson(statusPtr,ptrValue)
            % Handle JSON using JSONlab
            statusValue = statusPtr;

            % If status indicates success, load JSON
            if statusValue == 0
                % Interpret JSON string blob as a struct object
                loadedJson = loadjson(ptrValue);
                % loadedJson contains status, message and data, only return
                %   the data information.
                dataFromJson = loadedJson.data;
                %  Call replaceField on loadedJson to replace x0x5F_id with id
                structFromJson = Flywheel.replaceField(dataFromJson,'x0x5F_id','id');
            % Otherwise, nonzero statusCode indicates an error
            else
                % Try to load message from the JSON
                try
                    loadedJson = loadjson(ptrValue);
                    msg = loadedJson.message;
                    ME = MException('FlywheelException:handleJson', msg);
                % If unable to load message, throw an 'unknown' error
                catch ME
                    msg = sprintf('Unknown error (status %d).',statusValue);
                    causeException = MException('FlywheelException:handleJson', msg);
                    ME = addCause(ME,causeException);
                    rethrow(ME)
                end
                throw(ME)
            end
        end
        
        

        % TestBridge - 
        function cmdout = testBridge(obj, s)
            [status,cmdout] = system([obj.folder '/sdk TestBridge ' s]);
        end
