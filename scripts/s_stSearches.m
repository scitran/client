%% Flywheel search
%
% This script illustrates various ways to search the database to find data
% using the Matlab interface.
%
% The search data returned from Flywheel are cell arrays describing files,
% acquisitions (groups of related files), sessions, projects, or
% collections.
%
% The principle of the search command is this:
%
%    * Get authorization to access the Flywheel site
%    * Set the search return type and the search conditions
%    * Run the search (results = @scitran.search(srchParameters ...))
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
% See also:  st.browser - we use this function to visualize the returned
%            object in the browser.
%
% LMP/BW Scitran Team, 2017

%% Authorization

% You may need to create a local token for your site.  You can do this
% using
%    scitran('yourSite','action','create');
%
% You will be queried for the apiKey on the Flywheel User Profile page.
%
fw = scitran('vistalab');

%% List projects you can access

% I guess we should sort the projects on return.
projects = fw.search('project','summary',true,'sortlabel','project label');
for ii=1:length(projects)
    disp(projects{ii}.project.label)
end

%% Needs short form
projects = fw.search('project','project label contains','vwfa');
fprintf('Found %d projects for the group wandell, with label vwfa.\n',length(projects));

% Save this project information
projectID    = projects{end}.project.x_id;
projectLabel = projects{end}.project.label;

%% Get all the sessions within a specific collection
[sessions, srchCmd] = fw.search('sessions in collection',...
    'collection label contains','Anatomy Male 45-55');
fprintf('Found %d sessions\n',length(sessions));

%% Get the sessions within the first project
sessions = fw.search('sessions','project id',projectID);
fprintf('Found %d sessions in the project %s\n',length(sessions),projectLabel);
% Save this session information
sessionID = sessions{end}.id;
sessionLabel = sessions{end}.source.label;

%% Get the acquisitions inside a session

acquisitions = fw.search('acquisitions',...
    'session id',sessionID);
fprintf('Found %d acquisitions in session %s\n',length(acquisitions),sessionLabel);

%% Find nifti files in the session
files = fw.search('files',...
    'session id',sessionID,...
    'file type','nifti');
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

analyses = fw.search('analyses','collection label','GearTest');
fprintf('Analyses in collections and sessions: %d\n',length(analyses));

%% Analyses that are within a collection

% Returns analyses attached only to the collection, but not the sessions
% and acquisitions in the collection.

analyses = fw.search('analysesincollection','collection label','GearTest');
fprintf('Analyses in collections only %d\n',length(analyses));

%% Which collection is the analysis in?
collections = fw.search('collections','collection label','GearTest');
fprintf('Collections found %d\n',length(collections));

%% Returns analyses attached only to the sessions in the collection,
% but not to the collection as a whole.

analyses = fw.search('analyses in session','collection label','GearTest');
fprintf('Analyses found %d\n',length(analyses));

%% Find a session from that collection

sessions = fw.search('sessions','session label',sessions{1}.source.label);
sessions{1}.source.label

%% Count the number of sessions created in a recent time period

collections = fw.search('collections',...
    'session after time','now-16w');
fprintf('Found %d collections in previous four weeks \n',length(collections))

%% Get sessions with this subject code
subjectCode = 'ex4842';
sessions = fw.search('sessions','subject code','ex4842',...
    'all_data',true);
fprintf('Found %d sessions with subject code %s\n',length(sessions),subjectCode)

%% Get sessions in which the subject age is within a range

sessions = st.search('sessions',...
    'subject age gt', 9, ...
    'subject age lt', 10,...
    'summary',true);

%% Find a session with a specific label

sessionLabel = '20151128_1621';
files = fw.search('files','session label contains',sessionLabel);
fprintf('Found %d files from the session label %s\n',length(files),sessionLabel)

%% get files from a particular project and acquisition

files = fw.search('files', ...
    'project label','VWFA FOV', ...
    'acquisition label','11_1_spiral_high_res_fieldmap',...
    'file type','nifti',...
    'summary',true);
% This is how to download the nifti file
%  fname = files{1}.source.name;
%  dl_file = stGet(files{1}, s.token, 'destination', fullfile(pwd,fname));
%  d = niftiRead(dl_file);

%% Search for files in collection; find session names
files = fw.search('files',...
    'collection label','DWI',...
    'acquisition label','00 Coil Survey');
fprintf('Found %d files\n',length(files));

%% Find the session name for these files
% Make this work.  Something wrong!
%
% for ii=1:length(files)
%     % srch.sessions.match.label = files{ii}.source.session.label;
%     files{ii}.source.session.label
%     thisSession = st.search('sessions','session label',files{ii}.source.session.label);
%
%     if ~isempty(thisSession)
%         % This should not happen.  But it does.  So fix it. (BW).
%         ii
%         sessionNames{ii} = thisSession{1}.source.label;
%     end
% end
% %
% sessionNames = unique(sessionNames);
% fprintf('\n---------\n');
% for ii=1:length(sessionNames)
%     fprintf('%3d:  Session name %s\n',ii,sessionNames{ii});
% end
% fprintf('---------\n');

%% get files in project/session/acquisition/collection
files = fw.search('files',...
    'collection label contains','ENGAGE',...
    'acquisition label contains','T1w 1mm', ...
    'summary',true); %#ok<NASGU>

%% get files in project/session/acquisition/collection
files = fw.search('files',...
    'collection label','Anatomy Male 45-55',...
    'acquisition label','Localizer',...
    'file type','nifti');
fprintf('Found %d matching files\n',length(files))

%% Find sessions in this project that contain an analysis

% In this case, we are searching through all the data, not just the data
% that we have ownership on.

[sessions,srchS] = fw.search('sessions',...
    'project label','UMN', ...
    'session contains analysis', 'AFQ', ...
    'session contains subject','4279',...
    'all_data',true,'summary',true);

%%  Find the number of projects owned by a specific group
groupName = {'ALDIT','wandell','jwday','leanew1'}
for ii=1:length(groupName)
    projects = st.search('projects','project group',groupName{ii});
    fprintf('%d projects owned by the %s group\n',length(projects), groupName{ii});
end

%%
