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
projects = fw.search('project',...
    'summary',true,...
    'project label contains','vwfa');

% Save this project information
projectID    = projects{end}.project.x_id;
projectLabel = projects{end}.project.label;

%% Get all the sessions within a specific collection
[sessions, srchCmd] = fw.search('session',...
    'collection label exact','Anatomy Male 45-55',...
    'summary',true);

%% Get all the sessions within a specific collection

% Not working.  Returns too many sessions.
[sessions, srchCmd] = fw.search('session',...
    'collection label contains','Anatomy Male 45-55',...
    'summary',true);

%% Get the sessions within the first project
sessions = fw.search('session',...
    'project id',projectID,...
    'summary',true);

% Save this session information
sessionID = sessions{1}.session.x_id;
sessionLabel = sessions{1}.session.label;

%% Get the acquisitions inside a session

acquisitions = fw.search('session',...
    'session id',sessionID,...
    'summary',true);

%% Find nifti files in the session
files = fw.search('file',...
    'session id',sessionID,...
    'file type','nifti',...
    'summary',true);
for ii=1:length(files)
    fprintf('%d:  %s\n',ii,files{ii}.file.name);
end

%% Look for analyses in the GearTest collection = BUG BUG

% There is an issue - the analysis seems to be part of the session, not the
% collection.  So we can't really search for analyses in a collection, as
% we did earlier.  Not sure what we really want.  We used to have files in
% analysis, analysis in collection, stuff like that.

% This works, returns 1
sessions = fw.search('session',...
    'collection label exact','GearTest',...
    'summary',true);

% This returns 1.  Should return 4.
analyses = fw.search('analysis',...
    'session id',sessions{3}.session.x_id,...
    'summary',true);

% This should work, but it does not
analyses = fw.search('analysis',...
    'session id',sessions{3}.session.x_id,...
    'collection label contains','GearTest',...
    'summary',true);

% Fails.  Maybe because the analysis is part of the session and not the
% collection?
analyses = fw.search('analysis',...
    'collection label','GearTest', ...
    'summary', true);

%% Find a session from that collection

sessions = fw.search('session',...
    'session label',sessions{1}.session.label,...
    'summary',true);
sessions{1}.session.label

%% Count the number of sessions created in a recent time period

sessions = fw.search('session',...
    'session after time','now-16w');
fprintf('Found %d sessions in previous 16 weeks \n',length(sessions))

%% Get sessions with this subject code
sessions = fw.search('session',...
    'subject code','ex4842',...
    'all_data',true,...
    'summary',true);

%% Get sessions in which the subject age is within a range

sessions = fw.search('session', ...
    'subject age range',[10,11], ...
    'summary',true);

%% Find a session with a specific label

sessionLabel = '20151128_1621';  % There are two sessions with this label

sessions = fw.search('session',...
    'session label exact',sessionLabel,...
    'summary',true);

% There are a lot of files in these sessions, even a lot of nifti files.
% Why?
files = fw.search('file',...
    'session label exact',sessions{1}.session.label,...
    'filetype','nifti',...
    'summary',true);

%% get files from a particular project and acquisition

files = fw.search('file', ...
    'project label','VWFA FOV', ...
    'acquisition label','11_1_spiral_high_res_fieldmap',...
    'file type','nifti',...
    'summary',true);

% This is how to download the nifti file
%  fname = files{1}.source.name;
%  dl_file = stGet(files{1}, s.token, 'destination', fullfile(pwd,fname));
%  d = niftiRead(dl_file);

%% Search for files in collection; find session names
files = fw.search('file',...
    'collection label','DWI',...
    'acquisition label','00 Coil Survey',...
    'summary',true);

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
files = fw.search('file',...
    'collection label contains','ENGAGE',...
    'acquisition label contains','T1w 1mm', ...
    'summary',true);

%% get files in project/session/acquisition/collection
files = fw.search('file',...
    'collection label','Anatomy Male 45-55',...
    'acquisition label','Localizer',...
    'file type','nifti',...
    'summary',true);

%% Find sessions in a project that contain an analysis and subject code
   
% In this case, we are searching through all the data, not just the data
% that we have ownership on.
[sessions,srchS] = fw.search('session',...
    'project label exact','UMN', ...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'all_data',true,'summary',true);

[sessions,srchS] = fw.search('session',...
    'project label contains','UMN', ...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'all_data',true,'summary',true);

[sessions,srchS] = fw.search('session',...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'all_data',true,'summary',true);

%%  Find the number of projects owned by a specific group

groupName = 'wandell';
[projects,srchS] = fw.search('project',...
    'project group',groupName,...
    'summary',true);

groupName = {'aldit','wandell','jwday','leanew1'};
for ii=1:length(groupName)
    projects = fw.search('project',...
        'project group',groupName{ii},...
        'summary',true);
end

%%
