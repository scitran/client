%% Scitran search examples
%
% To interact with the database, you need to find key structures, such as
% files, acquisitions (groups of related files), sessions, and projects.
% This search method shows how to find these database objects.  The idea is
% this:
%
%    * Authorize yourself - use stAuth to get a token
%    * Set search conditions as a Matlab structure
%    * Use stEsearchRun to perform the search and return the object
% 
% Principles
%
% 1. Basic terms
%
%  A *project* includes multiple sessions
%  A project belongs to a research *group*
%  A *session* is part of a project
%  Each session includes multiple *acquisitions*
%  Each acquisition includes multiple *files*
%  A *collection* is built from multiple *acquisitions*
%  
% 2. Searching for a particular type of object
%
% We set the terms of the search by creating a Matlab struct.  The first
% slot in the struct defines the type of object you are searching for.
% Examples are:
%
%   b.path = 'projects'
%   b.path = 'sessions'    
%   b.path = 'acquisitions'
%   b.path = 'files'        
%   b.path = 'analysis'
%   b.path = 'collections'
%
% 3. The key operations in the search now are 
%   'match'
%   'bool'
%   'must' 
%   'range'
%
% Other terms are possible (e.g. 'filtered','filter','query','not') but
% here we illustrate the basics. 
%
% See also:  stBrowser - we use this function to visualize the returned
% object in the browser.
%
%% Matlab structs and JSON
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
%% DRAFT:  Do not use for now.
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
% See also:
%   
% LMP/BW Scitran Team, 2016

%% Authorization

% The auth returns a token and the url of the flywheel instance.  These are
% fixed as part of 's' throughout the examples, below.
[s.token, s.url] = stAuth('action', 'create', 'instance', 'scitran');

%% See a list of all projects

% In this example, we use the structure 'b' to store the search parameters.
% When we are satisfied with the parameters, we attach b to the mean search
% structure, s, and then run the search command.

clear b
b.path = 'projects';
s.json = b;
projects = stEsearchRun(s);

fprintf('Found %d projects\n',length(projects))


%% See a list of projects attached to the group 'wandell'

clear b
b.path = 'projects';
b.projects.bool.must(1).match.group = 'wandell';
b.projects.bool.must(2).match.label = 'vwfa';

% b.projects.match.label = 'vwfa'
s.json = b;
projects = stEsearchRun(s);
fprintf('Found %d projects for the group wandell, with label vwfa.\n',length(projects))

% Save this project information
projectID    = projects{1}.id;
projectLabel = projects{1}.source.label;

% You can browse to the project this way
%   stBrowser(s.url,projects{1});

%% Get the sessions within the first project

clear b
b.path = 'sessions';
b.projects.match.x0x5F_id = projectID;   % Sorry about that.
s.json = b;
sessions = stEsearchRun(s);
fprintf('Found %d sessions in the project %s\n',length(sessions),projectLabel);

% Save this session information
sessionID = sessions{1}.id;
sessionLabel = sessions{1}.source.label;

% Bring the session up this way
%   stBrowser(s.url,sessions{1});

%% Get the acquisitions inside a session

clear b
b.path = 'acquisitions';
b.sessions.match.x0x5F_id = sessionID;
s.json = b;
acquisitions = stEsearchRun(s);
fprintf('Found %d acquisitions in the session %s\n',length(acquisitions),sessionLabel);

% This brings up the session containing this acquisition
%   stBrowser(s.url,acquisitions{1});

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

%% Look for  analyses in the GearTest collection

clear b
b.path = 'analyses';
b.collections.match.label = 'GearTest';
s.json = b;
analyses = stEsearchRun(s);

% Which collection is the analysis in?
clear b; 
b.path = 'collections';
b.collections.match.label = 'GearTest';
s.json = b;
collections = stEsearchRun(s);

% Find a session from that collection
clear b; 
b.path = 'sessions'; 
b.collections.match.label = 'GearTest';
s.json = b;
sessions = stEsearchRun(s);

% Bring up the browser to that collection and session
stBrowser(s.url,sessions{1},'collection',collections{1})

%% Count the number of sessions created in a recent time period

clear b
b.path = 'collections';
b.sessions.range.created.gte = 'now-4w';  % For weeks ago
s.json = b;
collections = stEsearchRun(s);
fprintf('Found %d collections in previous two weeks \n',length(collections))

% To see the sessions within some time range use:
%   b.sessions.range.created.gte = dateFormat;
%   b.sessions.range.created.lte = dateFormat;
%
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

%% Get sessions in which the subject age is within a range

clear b
b.path = 'sessions';
b.sessions.bool.must{1}.range.subject_0x2E_age.gt = year2sec(10);
b.sessions.bool.must{1}.range.subject_0x2E_age.lt = year2sec(15);
s.json = b;
sessions = stEsearchRun(s);
% savejson('',s.json)

fprintf('Found %d sessions\n',length(sessions))

% View it in the browser and click on the subject tab to see the age
%   stBrowser(s.url,sessions{1})

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

%% get files from a particular project, session, and acquisition

clear b
b.path = 'files';
b.projects.match.label = 'testproject';
b.sessions.match.label = '20120522_1043';
b.acquisitions.match.label = '11_1_spiral_high_res_fieldmap';
b.files.match.type = 'nifti';
s.json = b;
files = stEsearchRun(s);
fprintf('Found %d matches to this files label\n',length(files));

% This is how to download the nifti file
%  fname = files{1}.source.name;
%  dl_file = stGet(files{1}, s.token, 'destination', fullfile(pwd,fname));
%  d = niftiRead(dl_file);


%%
clear b
b.path = 'files';   
b.collections.match.label = 'Young Males';
b.acquisitions.match.label = 'SPGR 1mm 30deg';
b.files.match.type = 'nifti';
s.json = b;

files = stEsearchRun(s);

%%
clear b
b.path = 'files';   
b.collections.match.label = 'Young Males';
b.acquisitions.match.measurement = 'Diffusion';
b.files.match.type = 'bvec';

s.json = b;
files = stEsearchRun(s);

%% get files in project/session/acquisition/collection

clear b
b.path = 'files';                         % Looking for T1 weighted files
b.collections.match.label = 'ENGAGE';     % Collection is ENGAGE
b.acquisitions.match.label = 'T1w 1mm';   % Description column
s.json = b;
files = stEsearchRun(s);
fprintf('Found %d matching files\n',length(files))

%% get files from a collection

clear b
b.path = 'files'; 
b.collections.match.label = 'Young Males';   
b.acquisitions.match.label = 'SPGR 1mm 30deg';   
b.files.match.name = '16.1_dicom_nifti.nii.gz';
s.json = b;

files = stEsearchRun(s);
fprintf('Found %d matching files\n',length(files))

for ii=1:length(files)
    files{ii}.source
end

%%