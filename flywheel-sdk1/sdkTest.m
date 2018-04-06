%% Test SDK methods in @Flywheel
%
% Before running this script, ensure the following paths were added
%
%   path to JSONlab
%   set SdkTestKey environment variable as user API key
<<<<<<< HEAD:flywheel/testDrive.m
%       ex: setenv('SdkTestKey', APIKEY)

% Create string to be used in testdrive
testString = 'aeu84sdfarew2h23333';
% A test file
=======
%     APIKEY = 'flywheel-cni.scitran.stanford.edu:******';
%     setenv('SdkTestKey',APIKEY)

%% Create string to be used in testdrive

% Used for labels, tags, user names
testString = 'abcdefg';

% A test file we upload and download later
>>>>>>> sdk:flywheel/sdkTest.m
filename = 'test.txt';
fid = fopen(filename, 'w');
fprintf(fid, 'This is a test file');
fclose(fid);

% Define error message
errMsg = 'Strings not equal';

%% Create FW client

apiKey = getenv('SdkTestKey');
fw = Flywheel(apiKey);

% Check that data can flow back & forth across the bridge
bridgeResponse = fw.testBridge('world');
assert(strcmp(bridgeResponse,'Hello world'), errMsg)

%% Users
disp('Testing Users')
user = fw.getCurrentUser();
assert(~isempty(user.id))

users = fw.getAllUsers();
assert(length(users) >= 1, 'No users returned')

% add a new user
email = strcat(testString, '@', testString, '.com');
userId = fw.addUser(struct('id',email,'email',email,'firstname',testString,'lastname',testString));

% modify the new user
fw.modifyUser(userId, struct('firstname', 'John'));
user2 = fw.getUser(userId);
assert(strcmp(user2.email, email), errMsg)
assert(strcmp(user2.firstname,'John'), errMsg)

fw.deleteUser(userId);
disp('Done')

%% Groups
disp('Testing Groups')

groupId = fw.addGroup(struct('id',testString));

fw.addGroupTag(groupId, 'blue');
fw.modifyGroup(groupId, struct('label','testdrive'));

groups = fw.getAllGroups();
assert(~isempty(groups))

group = fw.getGroup(groupId);
assert(strcmp(group.tags{1},'blue'), errMsg)
assert(strcmp(group.label,'testdrive'), errMsg)
disp('Done')

%% Projects
disp('Testing Projects')

projectId = fw.addProject(struct('label',testString,'group',groupId));

fw.addProjectTag(projectId, 'blue');
fw.modifyProject(projectId, struct('label','testdrive'));
fw.addProjectNote(projectId, 'This is a note');

projects = fw.getAllProjects();
assert(~isempty(projects), errMsg)


fw.uploadFileToProject(projectId, filename);
fw.downloadFileFromProject(projectId, filename, '/tmp/download.txt');

project = fw.getProject(projectId);
assert(strcmp(project.tags{1},'blue'), errMsg)
assert(strcmp(project.label,'testdrive'), errMsg)
assert(strcmp(project.notes.text, 'This is a note'), errMsg)
assert(strcmp(project.files.name, filename), errMsg)
s = dir('/tmp/download.txt');
<<<<<<< HEAD:flywheel/testDrive.m
assert(project.files.size == s.bytes, errMsg)
=======
assert(project.files{1,1}.size == s.bytes, errMsg)
disp('Done');
>>>>>>> sdk:flywheel/sdkTest.m

%% Sessions
disp('Testing Sessions')

sessionId = fw.addSession(struct('label', testString, 'project', projectId));

fw.addSessionTag(sessionId, 'blue');
fw.modifySession(sessionId, struct('label', 'testdrive'));
fw.addSessionNote(sessionId, 'This is a note');

sessions = fw.getProjectSessions(projectId);
assert(~isempty(sessions), errMsg)

sessions = fw.getAllSessions();
assert(~isempty(sessions), errMsg)

fw.uploadFileToSession(sessionId, filename);
fw.downloadFileFromSession(sessionId, filename, '/tmp/download2.txt');

session = fw.getSession(sessionId);
assert(strcmp(session.tags{1}, 'blue'), errMsg)
assert(strcmp(session.label, 'testdrive'), errMsg)
assert(strcmp(session.notes.text, 'This is a note'), errMsg)
assert(strcmp(session.files.name, filename), errMsg)
s = dir('/tmp/download2.txt');
<<<<<<< HEAD:flywheel/testDrive.m
assert(session.files.size == s.bytes, errMsg)
=======
assert(session.files{1,1}.size == s.bytes, errMsg)
disp('Done');
>>>>>>> sdk:flywheel/sdkTest.m

%% Acquisitions
disp('Testing Acquisitions')

acqId = fw.addAcquisition(struct('label', testString,'session', sessionId));

fw.addAcquisitionTag(acqId, 'blue');
fw.modifyAcquisition(acqId, struct('label', 'testdrive'));
fw.addAcquisitionNote(acqId, 'This is a note');

acqs = fw.getSessionAcquisitions(sessionId);
assert(~isempty(acqs), errMsg)

acqs = fw.getAllAcquisitions();
assert(~isempty(acqs), errMsg)

fw.uploadFileToAcquisition(acqId, filename);
fw.downloadFileFromAcquisition(acqId, filename, '/tmp/download3.txt');

acq = fw.getAcquisition(acqId);
assert(strcmp(acq.tags{1},'blue'), errMsg)
assert(strcmp(acq.label,'testdrive'), errMsg)
assert(strcmp(acq.notes.text, 'This is a note'), errMsg)
assert(strcmp(acq.files.name, filename), errMsg)
s = dir('/tmp/download3.txt');
<<<<<<< HEAD:flywheel/testDrive.m
assert(session.files.size == s.bytes, errMsg)
=======
assert(session.files{1,1}.size == s.bytes, errMsg)
disp('Done');
>>>>>>> sdk:flywheel/sdkTest.m

%% Gears
disp('Testing Gears')

gearId = fw.addGear(struct('category','converter','exchange', struct('git0x2Dcommit','example','rootfs0x2Dhash','sha384:example','rootfs0x2Durl','https://example.example'),'gear', struct('name','test-drive-gear','label','Test Drive Gear','version','3','author','None','description','An empty example gear','license','Other','source','http://example.example','url','http://example.example','inputs', struct('x', struct('base','file')))));

gear = fw.getGear(gearId);
assert(strcmp(gear.gear.name, 'test-drive-gear'), errMsg)

gears = fw.getAllGears();
assert(~isempty(gears), errMsg)

job2Add = struct('gear_id',gearId,'state','pending','inputs',struct('x',struct('type','acquisition','id',acqId,'name',filename)));
jobId = fw.addJob(job2Add);

job = fw.getJob(jobId);
assert(strcmp(job.gear_id,gearId), errMsg)

logs = fw.getJobLogs(jobId);
% Likely will not have anything in them yet
disp('Done');

%% Misc
disp('Testing Misc')

config = fw.getConfig();
assert(~isempty(config), errMsg)

fwVersion = fw.getVersion();
assert(fwVersion.database >= 25, errMsg)
disp('Done');

%% Cleanup
disp('Cleanup')

fw.deleteAcquisition(acqId);
fw.deleteSession(sessionId);
fw.deleteProject(projectId);
fw.deleteGroup(groupId);
fw.deleteGear(gearId);

disp('')
disp('Test drive complete.')
disp('Done');

%% Search

clear srch
srch.return_type = 'project';
projects = fw.search(srch);

% Deal with '.' replacement in jsonwrite
clear srch
srch.return_type = 'project';
srch.filters(1).match.project0x2Elabel = 'ENGAGE';
srch.filters(2).match.project0x2Egrouplabel = 'PanLab';
jsonwrite(srch,struct('indent','  ','replacementstyle','hex'))

projects = fw.search(srch);

% 'return_type': 'project',
%     'filters': [
%         {'match': {'project.label': 'ADNI'}}
        
%%
% 'return_type': 'session',
%     'all_data': True,
%     'filters': [
%         {'match': {'project.label': 'UMN'}},
%         {'match': {'analysis.label': 'AFQ'}},
%         {'term': {'subject.code': '4279'}}
%     ]
% }).get('results', []) ]
clear srch
srch.return_type = 'session';
srch.all_data = 1;
srch.filters(2).match.project0x2Elabel = 'UMN';
srch.filters(2).match.analysis0x2Elabel = 'AFQ';
% srch.filters.term.subject0x2Ecode = '4279';
jsonwrite(srch,struct('indent','  ','replacementstyle','hex'))
projects = fw.search(srch);

% Produces this error
%
% Error using Flywheel/handleJson (line 28)
% json: cannot unmarshal number into Go struct field SearchQuery.all_data of type bool
% 
% Error in Flywheel/search (line 240)
%             result = obj.handleJson(status,cmdout);
%  
%             
