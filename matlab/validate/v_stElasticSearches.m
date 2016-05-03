%% Elastic search examples to query the database
%
%    * Authorize - use stAuth to get a token
%    * Set database parameters (e.g., url and token)
%    * Set json parameters for the search
%    * Use stEsearchRun
% 
%  The scitran site url and token are fixed and set at the beginning. We
%  then illustrate how to set the fields of a Matlab struct to perform a
%  range of queries.  A more extensive manual will be prepared in the next
%  few weeks.
%
% Principles
% 1. Basic terms
%
%  A project includes multiple sessions
%  A session includes multiple acquisitinos
%  An acquisition includes multiple files
%  A collection is a collection of acquisitions
%  
%  A project belongs to a specific group.
%
% 2. The "path" attribute
% 
% The path slot in the json structure defines the general scope of the
% search.  For simple strings, the projects, sessions, acquisitions, or
% files are searched throughout the database.
%
%   b.path = 'projects'
%   b.path = 'sessions'    
%   b.path = 'acquisitions'
%   b.path = 'files'        
%   b.path = 'analysis'
%
% There are various special cases when you set the path, as well.  Note
% that some of these have a single '/' and some have a double '//'.
%
%   b.path = 'acquisitions/files'  files within a specific acquisition
%   b.path = 'sessions//files'     files contained in sessions and
%            acquisitions (excluding files attached to a collection or a
%            project). The double slash ("//") means take every descendant
%            of the matched sessions that is a file. 
%   b.path = 'sessions//' "//" means every descendant of the matched
%            sessions, including the sessions themselves. That is
%            sessions, files, notes, analyses in these sessions,
%            acquisitions belonging to these sessions, files, notes,
%            analyses in these acquisitions.   
%   b.path = 'collections//files'   Files in the matched collections
%   b.path = 'collections//acquisitions' all acquisitions that belongs to
%            the matched collections. 
%
% 3. The key operations in the search now are 'match', 'range',
%  'bool','must', 'filtered','filter','query','not'
%
%   The three that are straightforward to begin with are 'match', range'
%   and 'bool'.  Start with those, and then we will build up more complex
%   examples.
%
%% Notation
%
%  Matlab uses '.' in structs, and json allows '.' as part of the
%  variable name. So, we insert a dot on the Matlab side by inserting a
%  string, _0x2E_.  For example, to create a json object like this:
%
%   s = {
%   	"range": {
%   		"subject.age": {
% 	   		  "lte": years2sec(10)
% 		    }
% 	       }
%       }
%
% We use the code
%     clear b; 
%     b.range.subject_0x2E_age.lte = years2sec(10);
%
% Another issue is the use of _ at the front of a variable, like _id
%
% In this case, we cannot set b._id in Matlab.  But we can set
%    b.projects.match.x0x5F_id = projectID;
%
% The savejson('',b) returns the variable as simply _id, without all the
% x0x5F nonsense.
% 
% LMP/BW Scitran Team, 2016


% Questions for RF:
%
%   In the case of acquisitions/files, I suppose we always have to set the
%   acquisition.match.label or something?  What is intended there?
%   Same question in general for the '/' and '//'
%

%% Authorization

% The auth returns a token and the url of the flywheel instance
[token, furl, ~] = stAuth('action', 'create', 'instance', 'scitran');
fprintf('Token length %d\nConnected to: %s\n',length(token),furl)

% We use the structure s to store the parameters needed to create the
% elastic search command.  The url and token are fixed throughout, so we
% set them here.  

clear s
s.url    = furl;
s.token  = token;

% We keep changing the json payload, which we store in the slot called
%    s.json
% This is built up specifically for each of the searches, below.

%% get all the projects
clear b
b.path = 'projects';
s.json = b;
[projects,~,sFile] = stEsearchRun(s);
fprintf('Found %d projects\n',length(projects))

% Save this project label for later
projectID    = projects{1}.id;
projectLabel = projects{1}.source.label;

%% Get the sessions within the first project from above

clear b
b.path = 'projects/sessions';
b.projects.match.x0x5F_id = projectID;
s.json = b;
sessions = stEsearchRun(s);
fprintf('Found %d sessions in the project %s\n',length(sessions),projectLabel);

sessionID = sessions{1}.id;
sessionLabel = sessions{1}.source.label;
% stBrowser(s.url,sessions{1});

%% Get the acquisitions inside a session

clear b
b.path = 'sessions/acquisitions';
b.sessions.match.x0x5F_id = sessionID;
s.json = b;
acquisitions = stEsearchRun(s);

fprintf('Found %d acquisitions in the session %s\n',length(acquisitions),sessionLabel);
stBrowser(s.url,acquisitions{1});

%% Find nifti files in the session

clear b
b.path = 'files';
b.sessions.match.x0x5F_id = sessionID;
b.files.match.type = 'nifti';
s.json = b;
files = stEsearchRun(s);

nFiles = length(files);
fprintf('Found %d nifti files in the session %s\n',nFiles,sessionLabel);
for ii=1:nFiles
    fprintf('%d:  %s\n',ii,files{ii}.source.name);
end

% Download a file this way
%
%  dl = stGet(files{1}.plink,s.token)
%  d = niftiRead(dl);

%% Look for the analyses

clear b
b.path = 'analyses';
b.analyses.match_all = '{}';
s.json = b;
savejson('',b)
analyses = stEsearchRun(s);


%% Count the number of sessions created in the last 2 weeks

clear b
b.path = 'sessions';
b.sessions.range.created.gte = 'now-2w';
s.json = b;
sessions = stEsearchRun(s);
fprintf('Found %d sessions in previous two weeks \n',length(sessions))

% To see the session in the web page, use this command
%   stBrowser(s.url,sessions{1});


%% Get sessions with this subject code
clear b
b.path = 'sessions';
subjectCode = 'ex4842';
b.sessions.match.subject_0x2E_code = subjectCode;
s.json = b;
sessions = stEsearchRun(s);
fprintf('Found %d sessions with subject code %s\n',length(sessions),subjectCode)

% Click to 'Subject' tab to see the subject code
%    stBrowser(s.url,sessions{1});

%% Find a session with a specific label

sessionLabel = '20151128_1621';

clear b
b.path = 'sessions';
b.sessions.match.label= sessionLabel;
s.json = b;
sessions = stEsearchRun(s);
fprintf('Found %d sessions with the label %s\n',length(sessions),sessionLabel)

% Browse the session.
%   stBrowser(s.url,sessions{1});

%% Sessions with subjects within this age range

clear b
b.path = 'sessions';
b.range.subject_0x2E_age.gte = year2sec(12);
s.json = b;
sessions = stEsearchRun(s); 

fprintf('Found %d sessions with subjects in this range\n',length(sessions));

%% get files from a particular project, session, and acquisition

clear b
b.path = 'acquisitions/files';
b.projects.match.label = 'testproject';
b.sessions.match.label = '20120522_1043';
b.acquisitions.match.label = '11_1_spiral_high_res_fieldmap';
b.files.match.type = 'nifti';
s.json = b;
files = stEsearchRun(s);
fprintf('Found %d matches to this acquisition/files label\n',length(files));

% This is how to download the nifti file
dl_file = stGet(files{1}.plink, s.token, 'destination', fullfile(pwd,fname),'size',sz);

%% Show the session that contains this file

% Maybe there is a better way to get to the session with this file
clear b
b.path = 'sessions';
b.sessions.match.label = '20120522_1043';
s.json = b;
data = stEsearchRun(s);
stBrowser(s.url,data.sessions{1});

%% Get the URL to the collection labeled Young Males

clear b
b.path = 'collections';  
b.collections.match.label = 'Young Males';
s.json = b;
collections = stEsearchRun(s);
stBrowser(s.url,collections{1});

%%
clear b
b.path = 'files';   % The s needs to be trimmed, sigh.
b.collections.match.label = 'Young Males';
b.acquisitions.match.label = 'SPGR 1mm 30deg';
b.files.match.type = 'nifti';
s.json = b;

files = stEsearchRun(s);
stBrowser(s.url,files{1});

%%
clear b
b.path = 'files';   % The s needs to be trimmed, sigh.
b.collections.match.label = 'Young Males';
b.acquisitions.match.measurement = 'Diffusion';
b.files.match.type = 'bvec';

s.json = b;
data = stEsearchRun(s);

stBrowser(s.url,data.collections{1});

%% get files in project/session/acquisition/collection

clear b
b.path = 'files';
b.projects.match.label = 'ENGAGE';
b.sessions.match.label = '20160212_1145';
b.acquisitions.match.label = '14_1_HOS_WB_HRBRAIN';
s.json = b;

[data,plinks] = stEsearchRun(s);
for ii=1:length(data.files)
    data.files{ii}.x0x5F_source.type
end


% Maybe there is a better way to get to the session with this file
% This works, but ...
clear b
b.path = 'sessions';
b.projects.match.label = 'ENGAGE';
b.sessions.match.label = '20160212_1145';
s.json = b;
data = stEsearchRun(s);
stBrowser(s.url,data.sessions{1});

%% get files in project/session/acquisition/collection

clear b
b.path = 'files';                         % Looking for T1 weighted files
b.collections.match.label = 'ENGAGE';     % Collection is ENGAGE
% b.projects.match.label = 'ENGAGE';       
b.acquisitions.match.label = 'T1w 1mm';   % Description column
s.json = b;
[data,plinks] = stEsearchRun(s);
fprintf('Found %d matching files\n',length(data.files))

%stBrowser(s.url,data.sessions{1});

%% get files from a collection

clear b
b.path = 'files';                         % Looking for T1 weighted files
b.collections.match.label = 'Young Males';   
% b.projects.match.label = 'ENGAGE';       
b.acquisitions.match.label = 'SPGR 1mm 30deg';   % Description column
b.files.match.name = '16.1_dicom_nifti.nii.gz';
% b.files.match.name = '*.nii.gz';
% b.acquisitions.match.type  = 'nifti';
s.json = b;

data = stEsearchRun(s);
fprintf('Found %d matching files\n',length(data.files))

for ii=1:length(data.files)
    data.files{ii}.x0x5F_source
end



%% From Renzo ... various more examples

%% Examples describing the "path" attribute:
% 
% ```
% {
%     "path": "files",
%     ...
% }
% ```
% This will search for files everywhere in the database.
% 
% ```
% {
%     "path": "acquisitions/files",
%     ...
% }
% ```
% This will search for files that are contained in some acquisition, matching.
% 
% ```
% {
%     "path": "sessions//files",
%     ...
% }
% ```
% This will search for files that are contained in sessions and acquisitions (excluding files attached to a collection or a project).
% The double slash ("//") means take every descendant of the matched sessions that is a file.
% 
% ```
% {
%     "path": "sessions//",
%     ...
% }
% ```
% In this case the double slash ("//") means take every descendant of the matched sessions, including the sessions themselves.
% That is sessions, files, notes, analyses in these sessions, acquisitions belonging to these sessions, files, notes, analyses in these acquisitions.
% 
% ```
% {
%     "path": "collections//files",
%     ...
% }
% ```
% This will search for all files within a collection that is files in the matched collections, files in their sessions and in their acquisitions
% 
% ```
% {
%     "path": "collections//acquisitions",
%     ...
% }
% ```
% This will search all acquisitions that belongs to the matched collections.
% 
% #### **Examples**
% 
% We will use for simplicity for each example a query with path "sessions".
% 
% 
% Search for all the sessions:
% ```
% {
%     "path": "sessions",
%     "sessions": {
%         "match_all": {}
%     }
% }
% ```
% 
% Search for all the sessions with the field label matching "DTI":
% ```
% {
%     "path": "sessions",
%     "sessions": {
%         "match": {
%             "label": "DTI"
%         }
%     }
% }
% ```
% 
% Search for all the sessions with a subject with code "ex3006":
% ```
% {
%     "path": "sessions",
%     "sessions": {
%         "match": {
%             "subject.code": "ex3006"
%         }
%     }
% }
% ```
% 
% Search for all the sessions with tag "test tag":
% ```
% {
%     "path": "sessions",
%     "sessions": {
%         "match": {
%             "tags": "test tag"
%         }
%     }
% }
% ```
% 
% Search for all the subjects with age between 10 years (315576000 seconds) and 15 years (473364000 seconds):
% ```
% {
%     "path": "sessions",
%     "sessions": {
%         "range": {
%             "subject.age": {
%                 "gt": 315576000,
%                 "lt": 473364000
%             }
%         }
%     }
% }
% ```
% 
% Search for all the sessions with a subject with missing age (takes around 18 seconds):
% ```
% {
%     "path": "sessions",
%     "sessions": {
%         "filtered": {
%             "filter": {
%                 "not": {
%                     "exists" : { "field" : "subject.age" }
%                 }
%             },
%             "query": {
%                 "match_all": {}
%             }
%         }
%     }
% }
% ```
% 
% Search on multiple conditions (session label containing DTI and subject age between 10 and 15 years):
% ```
% {
%     "path": "sessions",
%     "sessions": {
%         "bool": {
%             "must": [
%                 {"range": {
%                     "subject.age": {
%                         "gt": 315576000,
%                         "lt": 473364000
%                     }
%                 }},
%                 {"match": {
%                     "label": "DTI"
%                 }}
%             ]
%         }
%     }
% }
% ```
