% Flywheel
classdef Flywheel
    % Flywheel class enables user to communicate with Flywheel platform
    properties
        key     % key - API Key assigned through the Flywheel UI
        folder  % folder - folder where the SDK code is located
    end
    methods
        function obj = Flywheel(apiKey)
            % Usage Flywheel(apiKey)
            %  apiKey - API Key assigned for each user through the Flywheel UI
            %          apiKey must be in format <domain>:<API token>
            C = strsplit(apiKey, ':');
            % Check if key is valid
            if length(C) < 2
                ME = MException('FlywheelException:Invalid', 'Invalid API Key');
                throw(ME)
            end
            obj.key = apiKey;
            % Check if JSONlab is in path
            if ~exist('savejson')
                ME = MException('FlywheelException:JSONlab', 'JSONlab function savejson is not loaded. Please install JSONlab and add to path.')
                throw(ME)
            end
            if ~exist('loadjson')
                ME = MException('FlywheelException:JSONlab', 'JSONlab function loadjson is not loaded. Please install JSONlab and add to path.')
                throw(ME)
            end

            [folder, name, ext] = fileparts(mfilename('fullpath'));
            obj.folder = folder;

            %%% TODO: use this code below to determine which .so and .h to load
            %if ismac
            % Code to run on Mac plaform
            %elseif isunix
            % Code to run on Linux plaform
            %elseif ispc
            % Code to run on Windows platform
            %else
            %    disp('Platform not supported')
            %end
            % Suppress Max Length Warning
            warningid = 'MATLAB:namelengthmaxexceeded';
            warning('off',warningid);
        end

        % TestBridge
        function cmdout = testBridge(obj, s)
            [status,cmdout] = system([obj.folder '/sdk TestBridge ' s]);
        end

        %
        % AUTO GENERATED CODE FOLLOWS
        %

        
        function result = search(obj, search_query)
            % search(search_query)

            oldField = 'id';
            newField = 'x0x5F_id';
            search_query = Flywheel.replaceField(search_query,oldField,newField);
            search_query = savejson('',search_query);
            [status,cmdout] = system([obj.folder '/sdk Search ' obj.key ' '  '''' search_query ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getAllAcquisitions(obj)
            % getAllAcquisitions()

            [status,cmdout] = system([obj.folder '/sdk GetAllAcquisitions ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getAcquisition(obj, id)
            % getAcquisition(id)

            [status,cmdout] = system([obj.folder '/sdk GetAcquisition ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addAcquisition(obj, acquisition)
            % addAcquisition(acquisition)

            oldField = 'id';
            newField = 'x0x5F_id';
            acquisition = Flywheel.replaceField(acquisition,oldField,newField);
            acquisition = savejson('',acquisition);
            [status,cmdout] = system([obj.folder '/sdk AddAcquisition ' obj.key ' '  '''' acquisition ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addAcquisitionNote(obj, id, text)
            % addAcquisitionNote(id, text)

            [status,cmdout] = system([obj.folder '/sdk AddAcquisitionNote ' obj.key ' '  '''' id ''' ' '''' text ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addAcquisitionTag(obj, id, tag)
            % addAcquisitionTag(id, tag)

            [status,cmdout] = system([obj.folder '/sdk AddAcquisitionTag ' obj.key ' '  '''' id ''' ' '''' tag ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifyAcquisition(obj, id, acquisition)
            % modifyAcquisition(id, acquisition)

            oldField = 'id';
            newField = 'x0x5F_id';
            acquisition = Flywheel.replaceField(acquisition,oldField,newField);
            acquisition = savejson('',acquisition);
            [status,cmdout] = system([obj.folder '/sdk ModifyAcquisition ' obj.key ' '  '''' id ''' ' '''' acquisition ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteAcquisition(obj, id)
            % deleteAcquisition(id)

            [status,cmdout] = system([obj.folder '/sdk DeleteAcquisition ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifyAcquisitionFile(obj, id, filename, attributes)
            % modifyAcquisitionFile(id, filename, attributes)

            oldField = 'id';
            newField = 'x0x5F_id';
            attributes = Flywheel.replaceField(attributes,oldField,newField);
            attributes = savejson('',attributes);
            [status,cmdout] = system([obj.folder '/sdk ModifyAcquisitionFile ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' attributes ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = setAcquisitionFileInfo(obj, id, filename, set)
            % setAcquisitionFileInfo(id, filename, set)

            oldField = 'id';
            newField = 'x0x5F_id';
            set = Flywheel.replaceField(set,oldField,newField);
            set = savejson('',set);
            [status,cmdout] = system([obj.folder '/sdk SetAcquisitionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' set ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = replaceAcquisitionFileInfo(obj, id, filename, replace)
            % replaceAcquisitionFileInfo(id, filename, replace)

            oldField = 'id';
            newField = 'x0x5F_id';
            replace = Flywheel.replaceField(replace,oldField,newField);
            replace = savejson('',replace);
            [status,cmdout] = system([obj.folder '/sdk ReplaceAcquisitionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' replace ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteAcquisitionFileInfoFields(obj, id, filename, keys)
            % deleteAcquisitionFileInfoFields(id, filename, keys)

            oldField = 'id';
            newField = 'x0x5F_id';
            keys = Flywheel.replaceField(keys,oldField,newField);
            keys = savejson('',keys);
            [status,cmdout] = system([obj.folder '/sdk DeleteAcquisitionFileInfoFields ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' keys ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = uploadFileToAcquisition(obj, id, path)
            % uploadFileToAcquisition(id, path)

            [status,cmdout] = system([obj.folder '/sdk UploadFileToAcquisition ' obj.key ' '  '''' id ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = downloadFileFromAcquisition(obj, id, name, path)
            % downloadFileFromAcquisition(id, name, path)

            [status,cmdout] = system([obj.folder '/sdk DownloadFileFromAcquisition ' obj.key ' '  '''' id ''' ' '''' name ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getAllBatches(obj)
            % getAllBatches()

            [status,cmdout] = system([obj.folder '/sdk GetAllBatches ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getBatch(obj, id)
            % getBatch(id)

            [status,cmdout] = system([obj.folder '/sdk GetBatch ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = startBatch(obj, id)
            % startBatch(id)

            [status,cmdout] = system([obj.folder '/sdk StartBatch ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getAllGroups(obj)
            % getAllGroups()

            [status,cmdout] = system([obj.folder '/sdk GetAllGroups ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getGroup(obj, id)
            % getGroup(id)

            [status,cmdout] = system([obj.folder '/sdk GetGroup ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addGroup(obj, group)
            % addGroup(group)

            oldField = 'id';
            newField = 'x0x5F_id';
            group = Flywheel.replaceField(group,oldField,newField);
            group = savejson('',group);
            [status,cmdout] = system([obj.folder '/sdk AddGroup ' obj.key ' '  '''' group ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addGroupTag(obj, id, tag)
            % addGroupTag(id, tag)

            [status,cmdout] = system([obj.folder '/sdk AddGroupTag ' obj.key ' '  '''' id ''' ' '''' tag ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifyGroup(obj, id, group)
            % modifyGroup(id, group)

            oldField = 'id';
            newField = 'x0x5F_id';
            group = Flywheel.replaceField(group,oldField,newField);
            group = savejson('',group);
            [status,cmdout] = system([obj.folder '/sdk ModifyGroup ' obj.key ' '  '''' id ''' ' '''' group ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteGroup(obj, id)
            % deleteGroup(id)

            [status,cmdout] = system([obj.folder '/sdk DeleteGroup ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getCurrentUser(obj)
            % getCurrentUser()

            [status,cmdout] = system([obj.folder '/sdk GetCurrentUser ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getAllUsers(obj)
            % getAllUsers()

            [status,cmdout] = system([obj.folder '/sdk GetAllUsers ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getUser(obj, id)
            % getUser(id)

            [status,cmdout] = system([obj.folder '/sdk GetUser ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addUser(obj, user)
            % addUser(user)

            oldField = 'id';
            newField = 'x0x5F_id';
            user = Flywheel.replaceField(user,oldField,newField);
            user = savejson('',user);
            [status,cmdout] = system([obj.folder '/sdk AddUser ' obj.key ' '  '''' user ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifyUser(obj, id, user)
            % modifyUser(id, user)

            oldField = 'id';
            newField = 'x0x5F_id';
            user = Flywheel.replaceField(user,oldField,newField);
            user = savejson('',user);
            [status,cmdout] = system([obj.folder '/sdk ModifyUser ' obj.key ' '  '''' id ''' ' '''' user ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteUser(obj, id)
            % deleteUser(id)

            [status,cmdout] = system([obj.folder '/sdk DeleteUser ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getAllCollections(obj)
            % getAllCollections()

            [status,cmdout] = system([obj.folder '/sdk GetAllCollections ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getCollection(obj, id)
            % getCollection(id)

            [status,cmdout] = system([obj.folder '/sdk GetCollection ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getCollectionSessions(obj, id)
            % getCollectionSessions(id)

            [status,cmdout] = system([obj.folder '/sdk GetCollectionSessions ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getCollectionAcquisitions(obj, id)
            % getCollectionAcquisitions(id)

            [status,cmdout] = system([obj.folder '/sdk GetCollectionAcquisitions ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getCollectionSessionAcquisitions(obj, id, sid)
            % getCollectionSessionAcquisitions(id, sid)

            [status,cmdout] = system([obj.folder '/sdk GetCollectionSessionAcquisitions ' obj.key ' '  '''' id ''' ' '''' sid ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addCollection(obj, collection)
            % addCollection(collection)

            oldField = 'id';
            newField = 'x0x5F_id';
            collection = Flywheel.replaceField(collection,oldField,newField);
            collection = savejson('',collection);
            [status,cmdout] = system([obj.folder '/sdk AddCollection ' obj.key ' '  '''' collection ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addAcquisitionsToCollection(obj, id, aqids)
            % addAcquisitionsToCollection(id, aqids)

            oldField = 'id';
            newField = 'x0x5F_id';
            aqids = Flywheel.replaceField(aqids,oldField,newField);
            aqids = savejson('',aqids);
            [status,cmdout] = system([obj.folder '/sdk AddAcquisitionsToCollection ' obj.key ' '  '''' id ''' ' '''' aqids ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addSessionsToCollection(obj, id, sessionids)
            % addSessionsToCollection(id, sessionids)

            oldField = 'id';
            newField = 'x0x5F_id';
            sessionids = Flywheel.replaceField(sessionids,oldField,newField);
            sessionids = savejson('',sessionids);
            [status,cmdout] = system([obj.folder '/sdk AddSessionsToCollection ' obj.key ' '  '''' id ''' ' '''' sessionids ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addCollectionNote(obj, id, text)
            % addCollectionNote(id, text)

            [status,cmdout] = system([obj.folder '/sdk AddCollectionNote ' obj.key ' '  '''' id ''' ' '''' text ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifyCollection(obj, id, collection)
            % modifyCollection(id, collection)

            oldField = 'id';
            newField = 'x0x5F_id';
            collection = Flywheel.replaceField(collection,oldField,newField);
            collection = savejson('',collection);
            [status,cmdout] = system([obj.folder '/sdk ModifyCollection ' obj.key ' '  '''' id ''' ' '''' collection ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteCollection(obj, id)
            % deleteCollection(id)

            [status,cmdout] = system([obj.folder '/sdk DeleteCollection ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifyCollectionFile(obj, id, filename, attributes)
            % modifyCollectionFile(id, filename, attributes)

            oldField = 'id';
            newField = 'x0x5F_id';
            attributes = Flywheel.replaceField(attributes,oldField,newField);
            attributes = savejson('',attributes);
            [status,cmdout] = system([obj.folder '/sdk ModifyCollectionFile ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' attributes ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = setCollectionFileInfo(obj, id, filename, set)
            % setCollectionFileInfo(id, filename, set)

            oldField = 'id';
            newField = 'x0x5F_id';
            set = Flywheel.replaceField(set,oldField,newField);
            set = savejson('',set);
            [status,cmdout] = system([obj.folder '/sdk SetCollectionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' set ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = replaceCollectionFileInfo(obj, id, filename, replace)
            % replaceCollectionFileInfo(id, filename, replace)

            oldField = 'id';
            newField = 'x0x5F_id';
            replace = Flywheel.replaceField(replace,oldField,newField);
            replace = savejson('',replace);
            [status,cmdout] = system([obj.folder '/sdk ReplaceCollectionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' replace ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteCollectionFileInfoFields(obj, id, filename, keys)
            % deleteCollectionFileInfoFields(id, filename, keys)

            oldField = 'id';
            newField = 'x0x5F_id';
            keys = Flywheel.replaceField(keys,oldField,newField);
            keys = savejson('',keys);
            [status,cmdout] = system([obj.folder '/sdk DeleteCollectionFileInfoFields ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' keys ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = uploadFileToCollection(obj, id, path)
            % uploadFileToCollection(id, path)

            [status,cmdout] = system([obj.folder '/sdk UploadFileToCollection ' obj.key ' '  '''' id ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = downloadFileFromCollection(obj, id, name, path)
            % downloadFileFromCollection(id, name, path)

            [status,cmdout] = system([obj.folder '/sdk DownloadFileFromCollection ' obj.key ' '  '''' id ''' ' '''' name ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getAllGears(obj)
            % getAllGears()

            [status,cmdout] = system([obj.folder '/sdk GetAllGears ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getGear(obj, id)
            % getGear(id)

            [status,cmdout] = system([obj.folder '/sdk GetGear ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addGear(obj, gear)
            % addGear(gear)

            oldField = 'id';
            newField = 'x0x5F_id';
            gear = Flywheel.replaceField(gear,oldField,newField);
            gear = savejson('',gear);
            [status,cmdout] = system([obj.folder '/sdk AddGear ' obj.key ' '  '''' gear ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteGear(obj, id)
            % deleteGear(id)

            [status,cmdout] = system([obj.folder '/sdk DeleteGear ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getJob(obj, id)
            % getJob(id)

            [status,cmdout] = system([obj.folder '/sdk GetJob ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getJobLogs(obj, id)
            % getJobLogs(id)

            [status,cmdout] = system([obj.folder '/sdk GetJobLogs ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addJob(obj, job)
            % addJob(job)

            oldField = 'id';
            newField = 'x0x5F_id';
            job = Flywheel.replaceField(job,oldField,newField);
            job = savejson('',job);
            [status,cmdout] = system([obj.folder '/sdk AddJob ' obj.key ' '  '''' job ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = heartbeatJob(obj, id)
            % heartbeatJob(id)

            [status,cmdout] = system([obj.folder '/sdk HeartbeatJob ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getAllProjects(obj)
            % getAllProjects()

            [status,cmdout] = system([obj.folder '/sdk GetAllProjects ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getProject(obj, id)
            % getProject(id)

            [status,cmdout] = system([obj.folder '/sdk GetProject ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getProjectSessions(obj, id)
            % getProjectSessions(id)

            [status,cmdout] = system([obj.folder '/sdk GetProjectSessions ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addProject(obj, project)
            % addProject(project)

            oldField = 'id';
            newField = 'x0x5F_id';
            project = Flywheel.replaceField(project,oldField,newField);
            project = savejson('',project);
            [status,cmdout] = system([obj.folder '/sdk AddProject ' obj.key ' '  '''' project ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addProjectNote(obj, id, text)
            % addProjectNote(id, text)

            [status,cmdout] = system([obj.folder '/sdk AddProjectNote ' obj.key ' '  '''' id ''' ' '''' text ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addProjectTag(obj, id, tag)
            % addProjectTag(id, tag)

            [status,cmdout] = system([obj.folder '/sdk AddProjectTag ' obj.key ' '  '''' id ''' ' '''' tag ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifyProject(obj, id, project)
            % modifyProject(id, project)

            oldField = 'id';
            newField = 'x0x5F_id';
            project = Flywheel.replaceField(project,oldField,newField);
            project = savejson('',project);
            [status,cmdout] = system([obj.folder '/sdk ModifyProject ' obj.key ' '  '''' id ''' ' '''' project ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteProject(obj, id)
            % deleteProject(id)

            [status,cmdout] = system([obj.folder '/sdk DeleteProject ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifyProjectFile(obj, id, filename, attributes)
            % modifyProjectFile(id, filename, attributes)

            oldField = 'id';
            newField = 'x0x5F_id';
            attributes = Flywheel.replaceField(attributes,oldField,newField);
            attributes = savejson('',attributes);
            [status,cmdout] = system([obj.folder '/sdk ModifyProjectFile ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' attributes ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = setProjectFileInfo(obj, id, filename, set)
            % setProjectFileInfo(id, filename, set)

            oldField = 'id';
            newField = 'x0x5F_id';
            set = Flywheel.replaceField(set,oldField,newField);
            set = savejson('',set);
            [status,cmdout] = system([obj.folder '/sdk SetProjectFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' set ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = replaceProjectFileInfo(obj, id, filename, replace)
            % replaceProjectFileInfo(id, filename, replace)

            oldField = 'id';
            newField = 'x0x5F_id';
            replace = Flywheel.replaceField(replace,oldField,newField);
            replace = savejson('',replace);
            [status,cmdout] = system([obj.folder '/sdk ReplaceProjectFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' replace ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteProjectFileInfoFields(obj, id, filename, keys)
            % deleteProjectFileInfoFields(id, filename, keys)

            oldField = 'id';
            newField = 'x0x5F_id';
            keys = Flywheel.replaceField(keys,oldField,newField);
            keys = savejson('',keys);
            [status,cmdout] = system([obj.folder '/sdk DeleteProjectFileInfoFields ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' keys ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = uploadFileToProject(obj, id, path)
            % uploadFileToProject(id, path)

            [status,cmdout] = system([obj.folder '/sdk UploadFileToProject ' obj.key ' '  '''' id ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = downloadFileFromProject(obj, id, name, path)
            % downloadFileFromProject(id, name, path)

            [status,cmdout] = system([obj.folder '/sdk DownloadFileFromProject ' obj.key ' '  '''' id ''' ' '''' name ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getConfig(obj)
            % getConfig()

            [status,cmdout] = system([obj.folder '/sdk GetConfig ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getVersion(obj)
            % getVersion()

            [status,cmdout] = system([obj.folder '/sdk GetVersion ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getAllSessions(obj)
            % getAllSessions()

            [status,cmdout] = system([obj.folder '/sdk GetAllSessions ' obj.key ' ' ]);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getSession(obj, id)
            % getSession(id)

            [status,cmdout] = system([obj.folder '/sdk GetSession ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = getSessionAcquisitions(obj, id)
            % getSessionAcquisitions(id)

            [status,cmdout] = system([obj.folder '/sdk GetSessionAcquisitions ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addSession(obj, session)
            % addSession(session)

            oldField = 'id';
            newField = 'x0x5F_id';
            session = Flywheel.replaceField(session,oldField,newField);
            session = savejson('',session);
            [status,cmdout] = system([obj.folder '/sdk AddSession ' obj.key ' '  '''' session ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addSessionNote(obj, id, text)
            % addSessionNote(id, text)

            [status,cmdout] = system([obj.folder '/sdk AddSessionNote ' obj.key ' '  '''' id ''' ' '''' text ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = addSessionTag(obj, id, tag)
            % addSessionTag(id, tag)

            [status,cmdout] = system([obj.folder '/sdk AddSessionTag ' obj.key ' '  '''' id ''' ' '''' tag ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifySession(obj, id, session)
            % modifySession(id, session)

            oldField = 'id';
            newField = 'x0x5F_id';
            session = Flywheel.replaceField(session,oldField,newField);
            session = savejson('',session);
            [status,cmdout] = system([obj.folder '/sdk ModifySession ' obj.key ' '  '''' id ''' ' '''' session ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteSession(obj, id)
            % deleteSession(id)

            [status,cmdout] = system([obj.folder '/sdk DeleteSession ' obj.key ' '  '''' id ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = modifySessionFile(obj, id, filename, attributes)
            % modifySessionFile(id, filename, attributes)

            oldField = 'id';
            newField = 'x0x5F_id';
            attributes = Flywheel.replaceField(attributes,oldField,newField);
            attributes = savejson('',attributes);
            [status,cmdout] = system([obj.folder '/sdk ModifySessionFile ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' attributes ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = setSessionFileInfo(obj, id, filename, set)
            % setSessionFileInfo(id, filename, set)

            oldField = 'id';
            newField = 'x0x5F_id';
            set = Flywheel.replaceField(set,oldField,newField);
            set = savejson('',set);
            [status,cmdout] = system([obj.folder '/sdk SetSessionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' set ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = replaceSessionFileInfo(obj, id, filename, replace)
            % replaceSessionFileInfo(id, filename, replace)

            oldField = 'id';
            newField = 'x0x5F_id';
            replace = Flywheel.replaceField(replace,oldField,newField);
            replace = savejson('',replace);
            [status,cmdout] = system([obj.folder '/sdk ReplaceSessionFileInfo ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' replace ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = deleteSessionFileInfoFields(obj, id, filename, keys)
            % deleteSessionFileInfoFields(id, filename, keys)

            oldField = 'id';
            newField = 'x0x5F_id';
            keys = Flywheel.replaceField(keys,oldField,newField);
            keys = savejson('',keys);
            [status,cmdout] = system([obj.folder '/sdk DeleteSessionFileInfoFields ' obj.key ' '  '''' id ''' ' '''' filename ''' ' '''' keys ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = uploadFileToSession(obj, id, path)
            % uploadFileToSession(id, path)

            [status,cmdout] = system([obj.folder '/sdk UploadFileToSession ' obj.key ' '  '''' id ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
        function result = downloadFileFromSession(obj, id, name, path)
            % downloadFileFromSession(id, name, path)

            [status,cmdout] = system([obj.folder '/sdk DownloadFileFromSession ' obj.key ' '  '''' id ''' ' '''' name ''' ' '''' path ''' ']);

            result = Flywheel.handleJson(status,cmdout);
        end
        
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
        function newStruct = replaceField(oldStruct,oldField,newField)
            % Replace a field within a struct or a cell array of structs
            % Check if variable is a cell
            if iscell(oldStruct)
                % Initialize newStruct as a copy of the oldStruct
                newStruct = oldStruct;
                for k=1:length(oldStruct)
                    f = fieldnames(oldStruct{k});
                    % Check if oldField is a fieldname in oldStruct
                    if any(ismember(f, oldField))
                        [oldStruct{k}.(newField)] = oldStruct{k}.(oldField);
                        newStruct{k} = rmfield(oldStruct{k},oldField);
                    else
                        newStruct{k} = oldStruct{k};
                    end
                end
            % Check if variable is a struct
            elseif isstruct(oldStruct)
                % Replace a fieldname within a struct object
                f = fieldnames(oldStruct);
                % Check if oldField is a fieldname in oldStruct
                if any(ismember(f, oldField))
                    [oldStruct.(newField)] = oldStruct.(oldField);
                    newStruct = rmfield(oldStruct,oldField);
                else
                    newStruct = oldStruct;
                end
            % If not, newStruct is equal to oldStruct
            else
                newStruct = oldStruct;
            end
        end
    end
end
