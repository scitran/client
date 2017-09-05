%% Test methods in Flywheel.m
%% Setup
disp('Setup')
% Before running this script, ensure the following paths were added
%   path to Flywheel.m to be tested
%   path to JSONlab
%   for BW at Flywheel-cni.stanford.edu
%   set SdkTestKey environment variable as user API key
%    APIKEY = 'flywheel-cni.scitran.stanford.edu:p707Q4tQxEhfNM0315';
%    setenv('SdkTestKey',APIKEY)

% Create string to be used in testdrive
testString = 'abcdefg';
% A test file
filename = 'test.txt';
fid = fopen(filename, 'w');
fprintf(fid, 'This is a test file');
fclose(fid);
% Define error message
errMsg = 'Strings not equal';

% Create client
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
assert(strcmp(project.notes{1,1}.text, 'This is a note'), errMsg)
assert(strcmp(project.files{1,1}.name, filename), errMsg)
s = dir('/tmp/download.txt');
assert(project.files{1,1}.size == s.bytes, errMsg)

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
assert(strcmp(session.notes{1,1}.text, 'This is a note'), errMsg)
assert(strcmp(session.files{1,1}.name, filename), errMsg)
s = dir('/tmp/download2.txt');
assert(session.files{1,1}.size == s.bytes, errMsg)

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
assert(strcmp(acq.notes{1,1}.text, 'This is a note'), errMsg)
assert(strcmp(acq.files{1,1}.name, filename), errMsg)
s = dir('/tmp/download3.txt');
assert(session.files{1,1}.size == s.bytes, errMsg)

%% Gears
disp('Testing Gears')

gearId = fw.addGear(struct('category','converter','exchange', struct('git_0x2D_commit','example','rootfs_0x2D_hash','sha384:example','rootfs_0x2D_url','https://example.example'),'gear', struct('name','test-drive-gear','label','Test Drive Gear','version','3','author','None','description','An empty example gear','license','Other','source','http://example.example','url','http://example.example','inputs', struct('x', struct('base','file')))));

gear = fw.getGear(gearId);
assert(strcmp(gear.gear.name, 'test-drive-gear'), errMsg)

gears = fw.getAllGears();
assert(~isempty(gears), errMsg)

job2Add = struct('gear_id',gearId,'state','pending','inputs',struct('x',struct('type','acquisition','id',acqId,'name','testDrive.m')));
jobId = fw.addJob(job2Add);

job = fw.getJob(jobId);
assert(strcmp(job.gear_id,gearId), errMsg)

logs = fw.getJobLogs(jobId);
% Likely will not have anything in them yet

%% Misc
disp('Testing Misc')

config = fw.getConfig();
assert(~isempty(config), errMsg)

fwVersion = fw.getVersion();
assert(fwVersion.database >= 25, errMsg)

%% Cleanup
disp('Cleanup')

fw.deleteAcquisition(acqId);
fw.deleteSession(sessionId);
fw.deleteProject(projectId);
fw.deleteGroup(groupId);
fw.deleteGear(gearId);

disp('')
disp('Test drive complete.')
