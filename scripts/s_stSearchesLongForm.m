%% Scitran search
%
% This script illustrates various ways to search the database to find
% information.  This is the long form search; we expect people mainly to
% use the s_stSearches() examples, which are much simpler and compact to
% write.  This form is useful because it has more programming control.  But
% it is harder to read and write.
%
% PRINCIPLES
% The search data returned from Flywheel are cell arrays describing files,
% acquisitions (groups of related files), sessions, or projects. These
% objects are described a little more below and on the scitran/client
% wiki page (see below).
%
% The principle of the search command is this:
%
%    * Get authorization to access the scitran site (st = scitran)
%    * Create a Matlab structure (srch) to specify search requirements
%    * Run this search (results = @scitran.search(srch))
%    * Results is a cell array of objects that meet the search criterion
%
% For further documentation, see
%
%  * <https://github.com/scitran/client/wiki scitran/client wiki page>, and
%  specifically the pages on
%
%  * <https://github.com/scitran/client/wiki/Search Search> and the
%  * <https://github.com/scitran/client/wiki/Search-examples search examples>
%
% This should go on the wiki page, not here.
%
%   Searching for an object
%
%  Searches begin by defining the type of object you are looking for (e.g.,
%  files).  Then we define the required features of the object.
%
%  We set the terms of the search by  creating a Matlab struct.  The first
%  slot in the struct defines the type of object you are searching for.
%  Suppose we call the struct 'srch'.  The srch.path slot defines the kind
%  of object we are searching for.
%
%   srch.path = 'projects'
%   srch.path = 'sessions'
%   srch.path = 'acquisitions'
%   srch.path = 'files'
%   srch.path = 'analysis'
%   srch.path = 'collections'
%
% The search operations are specified by adding additional slots to the
% struct, 'srch'.  These includes specific operators, parameters, and
% values.  The point of this script is to provide many examples of how to
% set up these searches
%
% Important operators that we use below are
%
%   'match', 'bool', 'must', 'range'
%
% Important parameters we use in search are
%   'name', 'group', 'label', 'id','plink', subject_0x2E_age',
%   'container_id', 'type'.
%
% A list of searchable terms can be found in the scitran/core
%
%  <https://github.com/scitran/core/wiki/Data-Model Data Model page>.
%
% Other operators are possible (e.g. 'filtered','filter','query','not') but
% here we illustrate the basics.
%
% See also:  st.browser - we use this function to visualize the returned
%            object in the browser.
%
% LMP/BW Scitran Team, 2016

%% Authorization

% The auth returns a token and the url of the flywheel instance.  These are
% fixed as part of 's' throughout the examples, below.
st = scitran('scitran', 'action', 'create');

%% List all projects

% In this example, we use the structure 'srch' to store the search parameters.
% When we are satisfied with the parameters, we attach srch to the mean search
% structure, s, and then run the search command.

clear srch
srch.path = 'projects';
projects = st.search(srch);
fprintf('Found %d projects\n',length(projects))

%% List projects in the group 'wandell' with label 'vwfa'

clear srch
srch.path = 'projects';
srch.projects.bool.must(1).match.group = 'wandell';
srch.projects.bool.must(2).match.label = 'vwfa';

% srch.projects.match.label = 'vwfa'
projects = st.search(srch);
fprintf('Found %d projects for the group wandell, with label vwfa.\n',length(projects))

% Save this project information
projectID    = projects{end}.id;
projectLabel = projects{end}.source.label;

%% Get all the sessions within a specific collection

clear srch;
srch.path = 'collections/sessions';
srch.collections.match.label = 'Anatomy Male 45-55';
[sessions, srchCmd] = st.search(srch);

fprintf('Found %d sessions in the collection %s\n',length(sessions),srch.collections.match.label);

%% Get the sessions within the first project

clear srch
srch.path = 'sessions';
srch.projects.match.x0x5Fid = projectID;   % Note the ugly x0x5F.  See notes.
sessions = st.search(srch);
fprintf('Found %d sessions in the project %s\n',length(sessions),projectLabel);

% Save this session information
sessionID = sessions{end}.id;
sessionLabel = sessions{end}.source.label;

% Bring the session up this way
%   st.browser(sessions{1});

%% Get the acquisitions inside a session

clear srch
srch.path = 'acquisitions';
srch.sessions.match.x0x5Fid = sessionID;
acquisitions = st.search(srch);
fprintf('Found %d acquisitions in the session %s\n',length(acquisitions),sessionLabel);

% This brings up the session containing this acquisition
%   st.browser(acquisitions{1});

%% Find nifti files in the session

clear srch
srch.path = 'files';
srch.sessions.match.x0x5Fid = sessionID;
srch.files.match.type = 'nifti';
files = st.search(srch);

nFiles = length(files);
fprintf('Found %d nifti files in the session %s\n',nFiles,sessionLabel);
for ii=1:nFiles
    fprintf('%d:  %s\n',ii,files{ii}.source.name);
end

% Download a file this way
%
%  dl = stGet(files{1}.plink,s.token)
%  d = niftiRead(dl);

%% Look for analyses in the GearTest collection

% Returns analyses attached to anything in the collection, including
% the collection itself, or the sessions and acquisitions in the
% collection.
clear srch
srch.path = 'analyses';
srch.collections.match.label = 'GearTest';
analyses = st.search(srch);
fprintf('Analyses in collections and sessions %d\n',length(analyses));

%%
% Returns analyses attached only to the collection, but not the sessions
% and acquisitions in the collection.
clear srch
srch.path = 'collections/analyses';
srch.collections.match.label = 'GearTest';
analyses = st.search(srch);
fprintf('Analyses in collections only %d\n',length(analyses));

%% Which collection is the analysis in?
clear srch;
srch.path = 'collections';
srch.collections.match.label = 'GearTest';
collections = st.search(srch);
fprintf('Collections found %d\n',length(collections));

%% Returns analyses attached only to the sessions in the collection
% but not to the collection as a whole.
clear srch
srch.path = 'sessions/analyses';
srch.collections.match.label = 'GearTest';
analyses = st.search(srch);
fprintf('Analyses found %d\n',length(analyses));

%%
% Find a session from that collection
clear srch;
srch.path = 'sessions';
srch.collections.match.label = 'GearTest';
sessions = st.search(srch);
sessions{1}.source.label

% Bring up the browser to that collection and session
% NOT WORKING
% url = st.browser('stdata',sessions{1},'collection',collections{1});

%% Count the number of sessions created in a recent time period

clear srch
srch.path = 'collections';
srch.sessions.range.created.gte = 'now-16w';  % For weeks ago
collections = st.search(srch);
fprintf('Found %d collections in previous four weeks \n',length(collections))

% To see the sessions within some time range use:
%   srch.sessions.range.created.gte = dateFormat;
%   srch.sessions.range.created.lte = dateFormat;
%
% To see the session in the web page, use this command
%   st.browser(sessions{1});

%% Get sessions with this subject code
clear srch
srch.path = 'sessions';
subjectCode = 'ex4842';
srch.sessions.match.subject0x2Ecode = subjectCode;
% srch.sessions.match.subject_code = subjectCode;
[sessions,srchS] = st.search(srch,'all_data',true);
fprintf('Found %d sessions with subject code %s\n',length(sessions),subjectCode)

% Click to 'Subject' tab to see the subject code
%    st.browser(s.url,sessions{1});

%% Get sessions in which the subject age is within a range

clear srch
srch.path = 'sessions';
srch.sessions.bool.must{1}.range.subject0x2Eage.gt = 10;
srch.sessions.bool.must{2}.range.subject0x2Eage.lt = 11;
sessions = st.search(srch);

fprintf('Found %d sessions\n',length(sessions))

% View it in the browser and click on the subject tab to see the age
%   st.browser(sessions{1})

%% Find a session with a specific label

sessionLabel = '20151128_1621';

clear srch
srch.path = 'sessions';
srch.sessions.match.label= sessionLabel;
sessions = st.search(srch);
fprintf('Found %d sessions with the label %s\n',length(sessions),sessionLabel)

% Browse the session.
%   st.browser(sessions{1});

%% get files from a particular project, session, and acquisition

clear srch
srch.path = 'files';
sLabel = '20151128_1621';
srch.sessions.match.label = sLabel;
files = st.search(srch);
fprintf('Found %d files matches to session labeled file label %s\n',length(files),sLabel);

% This is how to download the nifti file
%  fname = files{1}.source.name;
%  dl_file = stGet(files{1}, s.token, 'destination', fullfile(pwd,fname));
%  d = niftiRead(dl_file);


%% Search for files in collection; find session names
clear srch
srch.path = 'files';
srch.collections.match.label = 'DWI';
srch.acquisitions.match.label = '00 Coil Survey';

files = st.search(srch);
fprintf('Found %d files\n',length(files));

% Find the session names
clear srch
srch.path = 'sessions';
srch.collections.match.label = 'DWI';
sessionNames = cell(1,length(files));
for ii=1:length(files)
    if isfield(files{ii}.source,'session')
    srch.sessions.match.label = files{ii}.source.session.label;
    else
        fprintf('No session for file %d, name %s\n',ii,files{ii}.source.name);
    end
    thisSession = st.search(srch);
    sessionNames{ii} = thisSession{1}.source.label;
end

sessionNames = unique(sessionNames);
fprintf('\n---------\n');
for ii=1:length(sessionNames)
    fprintf('%3d:  Session name %s\n',ii,sessionNames{ii});
end
fprintf('---------\n');

%% get files in project/session/acquisition/collection

clear srch
srch.path = 'files';                         % Looking for T1 weighted files
srch.collections.match.label = 'ENGAGE';     % Collection is ENGAGE
srch.acquisitions.match.label = 'T1w 1mm';   % Description column
files = st.search(srch);
fprintf('Found %d matching files\n',length(files))

%% get files from a collection

clear srch
srch.path = 'files';
srch.collections.match.label = 'Anatomy Male 45-55';
srch.acquisitions.match.exact_label = 'Localizer';
srch.files.match.type = 'nifti';
files = st.search(srch);
fprintf('Found %d matching files\n',length(files))
for ii=1:length(files)
    files{ii}.source.acquisition.label
end

%% Find sessions in this project that contain an analysis

% In this case, we are searching through all the data, not just the data
% that we have ownership on.
clear srch
srch.path = 'sessions';
srch.projects.match.exact_label = 'UMN';
srch.sessions.bool.must(1).match.analyses0x2Elabel = 'AFQ';  % DOT
srch.sessions.bool.must(2).match.subject0x2Ecode = '4279';
sessions = st.search(srch,'all_data',true);

fprintf('Found %d matching sessions\n',length(sessions))

%%
