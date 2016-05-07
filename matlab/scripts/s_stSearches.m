%% Scitran search
%
% It is possible to interact with the database, either to process the files
% or to discover content, using Matlab or Python.  This script illustrates
% various ways to search the database to find files and experiments.
%
% The basic objects in the data base comprise individual files,
% acquisitions (groups of related files), sessions, and projects. These
% objects are described a little more below and also on the scitran/client
% wiki page.
%
% The scitran client supports search the data base to identify these
% objects. The principle of the search is simple:
%
%    * Authorization - use stAuth to get a token
%    * Use a Matlab structure to set up the search requirements for one of
%      the object types  
%    * Use stEsearchRun to perform the search
%    * The results are returned in a cell array that lists the objects that
%      meet the search criterion
% 
% Principles
%
% 1. Basic terms
%
%  * A project includes the data from multiple sessions; a project
%    belongs to a research *group* 
%  * Session - What you might have done in an hour's session at the
%    scanner, collecting a variety of data
%  * Acquisitions - groups of related files, such as the diffusion, bvecs
%    and bval fall, or the dicom and nifti file, that are produced when you
%    push the button on an MR scanner
%  * Files - single files, such as a nifti file, or a dicom file, ...
%  * Collection - users create collections from the Flywheel interface by
%    combining multiple acquisitions or sessions.  Collections act as
%    'virtual experiments' in which the data collected at different
%    projects, or by different groups, are combined and analyzed. Scitran
%    creates these collections without duplicating the data
%  * Analyses - sets of files, within a collection or session, that have
%    been analyzed using a Gear.  The analyses objects include both the
%    files and information about the methods that were used to perform a
%    specific (reproducible) analysis.
%  
% 2. Searching for an object
%
%  Searches begin by defining the type of object (e.g., files).  Then we
%  define the required features of the object.
%
%  We set the terms of the search by  creating a Matlab struct.  The first
%  slot in the struct defines the type of object you are searching for.
%  Suppose we call the struct 'b'.  The b.path slot defines the kind of
%  object we are searching for.
%
%   b.path = 'projects'
%   b.path = 'sessions'    
%   b.path = 'acquisitions'
%   b.path = 'files'        
%   b.path = 'analysis'
%   b.path = 'collections'
%
% 3. The search operations are specified by adding additional slots to the
%    struct, 'b'.  These includes specific operators, parameters, and
%    values.  The point of this script is to provide many examples of how
%    to set up these searches
% 
% 4. Important operators that we use below are
%
%   'match'
%   'bool'
%   'must' 
%   'range'
%
% Important parameters we use in search are 
%   'name', 'group', 'label', 'id','plink', subject_0x2E_age',
%   'container_id', 'type'.  
%
% The full list can be found in the scitran/core data model wiki page (Data
% model).
%
% Other terms are possible (e.g. 'filtered','filter','query','not') but
% here we illustrate the basics. 
%
% See also:  stBrowser - we use this function to visualize the returned
% object in the browser.
%
% See programming notes at the end of the file
%
% LMP/BW Scitran Team, 2016

%% Authorization

% The auth returns a token and the url of the flywheel instance.  These are
% fixed as part of 's' throughout the examples, below.
[s.token, s.url] = stAuth('action', 'create', 'instance', 'scitran');

%% List all projects

% In this example, we use the structure 'b' to store the search parameters.
% When we are satisfied with the parameters, we attach b to the mean search
% structure, s, and then run the search command.

clear b
b.path = 'projects';
s.json = b;
projects = stSearch(s);

fprintf('Found %d projects\n',length(projects))


%% List projects attached to the group 'wandell' with label 'vwfa'

clear b
b.path = 'projects';
b.projects.bool.must(1).match.group = 'wandell';
b.projects.bool.must(2).match.label = 'vwfa';

% b.projects.match.label = 'vwfa'
s.json = b;
projects = stSearch(s);
fprintf('Found %d projects for the group wandell, with label vwfa.\n',length(projects))

% Save this project information
projectID    = projects{1}.id;
projectLabel = projects{1}.source.label;

% You can browse to the project this way
%   stBrowser(s.url,projects{1});

%% Get the sessions within the first project

clear b
b.path = 'sessions';
b.projects.match.x0x5F_id = projectID;   % Note the ugly x0x5F.  See notes.
s.json = b;
sessions = stSearch(s);
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
acquisitions = stSearch(s);
fprintf('Found %d acquisitions in the session %s\n',length(acquisitions),sessionLabel);

% This brings up the session containing this acquisition
%   stBrowser(s.url,acquisitions{1});

%% Find nifti files in the session

clear b
b.path = 'files';
b.sessions.match.x0x5F_id = sessionID;
b.files.match.type = 'nifti';
s.json = b;
files = stSearch(s);

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
analyses = stSearch(s);

% Which collection is the analysis in?
clear b; 
b.path = 'collections';
b.collections.match.label = 'GearTest';
s.json = b;
collections = stSearch(s);

% Find a session from that collection
clear b; 
b.path = 'sessions'; 
b.collections.match.label = 'GearTest';
s.json = b;
sessions = stSearch(s);

% Bring up the browser to that collection and session
stBrowser(s.url,sessions{1},'collection',collections{1})

%% Count the number of sessions created in a recent time period

clear b
b.path = 'collections';
b.sessions.range.created.gte = 'now-4w';  % For weeks ago
s.json = b;
collections = stSearch(s);
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
sessions = stSearch(s);
fprintf('Found %d sessions with subject code %s\n',length(sessions),subjectCode)

% Click to 'Subject' tab to see the subject code
%    stBrowser(s.url,sessions{1});

%% Get sessions in which the subject age is within a range

clear b
b.path = 'sessions';
b.sessions.bool.must{1}.range.subject_0x2E_age.gt = year2sec(10);
b.sessions.bool.must{1}.range.subject_0x2E_age.lt = year2sec(15);
s.json = b;
sessions = stSearch(s);
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
sessions = stSearch(s);
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
files = stSearch(s);
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

files = stSearch(s);

%%
clear b
b.path = 'files';   
b.collections.match.label = 'Young Males';
b.acquisitions.match.measurement = 'Diffusion';
b.files.match.type = 'bvec';

s.json = b;
files = stSearch(s);

%% get files in project/session/acquisition/collection

clear b
b.path = 'files';                         % Looking for T1 weighted files
b.collections.match.label = 'ENGAGE';     % Collection is ENGAGE
b.acquisitions.match.label = 'T1w 1mm';   % Description column
s.json = b;
files = stSearch(s);
fprintf('Found %d matching files\n',length(files))

%% get files from a collection

clear b
b.path = 'files'; 
b.collections.match.label = 'Young Males';   
b.acquisitions.match.label = 'SPGR 1mm 30deg';   
b.files.match.name = '16.1_dicom_nifti.nii.gz';
s.json = b;

files = stSearch(s);
fprintf('Found %d matching files\n',length(files))

for ii=1:length(files)
    files{ii}.source
end

%%




%% Matlab structs and JSON format
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