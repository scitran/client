
    Constructor
        function obj = Flywheel(apiKey)
            % Usage Flywheel(apiKey)
            %  apiKey - API Key assigned for each user through the Flywheel UI
            %          apiKey must be in format <domain>:<API token>
            

        % getAllBatches(obj)
        % getBatch(obj, id)
        % startBatch(obj, id)
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
        % search(obj, search_query)
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
        % getJob(obj, id)
        % getJobLogs(obj, id)
        % addJob(obj, job)  
        % heartbeatJob(obj, id)  
        % getAllProjects(obj)
        % getProject(obj, id)
        % getProjectSessions(obj, id)
        % addProject(obj, project)
        % addProjectNote(obj, id, text)
        % addProjectTag(obj, id, tag)
        % modifyProject(obj, id, project)
        % deleteProject
        function result = deleteProject(obj, id)
            statusPtr = libpointer('int32Ptr',-100);
            [status,cmdout] = system([obj.folder '/sdk DeleteProject ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        % modifyProjectFile(obj, id, filename, attributes)
        % setProjectFileInfo(obj, id, filename, set)
        % replaceProjectFileInfo(obj, id, filename, replace)
        % deleteProjectFileInfoFields(obj, id, filename, keys)
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
