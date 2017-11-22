%% Flywheel search
%
% This script illustrates ways to search the database using the Matlab
% interface.
%
% The returned data are cell arrays describing files, acquisitions (groups
% of related files), sessions, projects, or collections.  Each element of
% the cell array is a struct that contains information about the returned
% object.  For example, if you find a file the cell array will be structs
% with fields
% 
%         project: [struct]
%         session: [struct]
%     acquisition: [struct]
%            file: [struct]
%      collection: [struct]
%
%     permissions: [1×1 struct]
%         subject: [1×1 struct]
%           group: [1×1 struct]
%          parent: [1×1 struct]
%
% To perform a search you must create a scitran object and be authorized to
% access the Flywheel site.  The scitran search method has the syntax
%
%    results = scitran.search(result_type,'parameter',value,...)
%
% For further documentation, see
%
%  * <https://github.com/scitran/client/wiki scitran/client wiki page>, and
%  specifically the pages on
%
%  * <https://github.com/scitran/client/wiki/Search Search> and the
%  * <https://github.com/scitran/client/wiki/Search-examples search examples>
%
% To convert the struct to JSON use
%
%  opts = struct('replacementStyle','hex');
%  jsonwrite(cmd,opts);
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
st = scitran('vistalab');
fw = st.fw;
% st.verify

%% List projects you can access

% I guess we should sort the projects on return.
projects = st.search('project',...
    'summary',true,...
    'sortlabel','project label');

% Ordered by the project label
for ii=1:length(projects)
    disp(projects{ii}.project.label)
end

%% Needs short form
[projects,srchCmd] = st.search('project',...
    'summary',true,...
    'project label contains','vwfa');

% Save this project information
projectID    = projects{end}.project.x_id;
projectLabel = projects{end}.project.label;

%% You can also set up a struct with search parameters and run that
projects = st.search(srchCmd);

% These match
fprintf('%s matches %s\n',projects{end}.project.label,projectLabel);

%% Get a sessions within a specific collection with a subject code

% BUG - This seems like a bug.  There is an SU in front of the code and I don't
% understand why.
sessions = st.search('session',...
    'collection label exact','Anatomy Male 45-55',...
    'subject code','SU ex10316',...
    'summary',true);

sessions = st.search('session',...
    'collection label exact','Anatomy Male 45-55',...
    'summary',true);

%% Get all the sessions within a specific collection

[sessions, srchCmd] = st.search('session',...
    'collection label contains','Anatomy Male 45-55',...
    'summary',true);

%% Get the sessions within the first project
sessions = st.search('session',...
    'project id',projectID,...
    'summary',true);

% Save this session information
sessionID = sessions{1}.session.x_id;
sessionLabel = sessions{1}.session.label;

%% Get the session with this particular sessionID
sessions = st.search('session',...
    'session id',sessionID,...
    'summary',true);

%% Get the acquisitions inside a session

acquisitions = st.search('acquisition',...
    'session id',sessionID,...
    'summary',true);

%% Find files in the session using an ID

[acquisitions,srchCmd] = st.search('acquisition',...
    'string','BOLD_EPI',...
    'project label exact','ALDIT', ...
    'summary',true);

% Notice that this has BOLD<space>EPI as well.
for ii=1:length(acquisitions)
    acquisitions{ii}.acquisition.label
end

%%
[projects,srchCmd] = st.search('project',...
    'string','BOLD_EPI',...
    'summary',true);

%% Projects that have this string somewhere in their representation

[projects,srchCmd] = st.search('project',...
    'string','BOLD_EPI',...
    'summary',true);
    
for ii=1:length(projects)
    projects{ii}.project.label
end

%% Sessions that have the string somewhere

[sessions,srchCmd] = st.search('session',...
    'string','BOLD_EPI',...
    'summary',true);

for ii=1:length(sessions)
    sessions{ii}.project.label
end

%% Restrict to one project
thisProject = 'ALDIT';
[sessions,srchCmd] = st.search('session',...
    'string','BOLD_EPI',...
    'project label exact',thisProject,...
    'summary',true);

%% Finding files in various ways

[files,srchCmd] = st.search('file',...
    'acquisition id',acquisitions{1}.acquisition.x_id,...
    'summary',true);

%%
[files,srchCmd] = st.search('file',...
    'session id',sessionID,...
    'summary',true);

%% A lot of files in a project

[files,srchCmd] = st.search('file',...
    'project id',files{1}.project.x_id,...
    'filetype','nifti',...
    'summary',true);
    
for ii=1:length(files)
    fprintf('%d:  %s\n',ii,files{ii}.file.name);
end

%% Find files in the project using a label

% Get the label
thisProject = st.search('project',...
    'project label contains',...
    'VWFA','limit',1);

% There are a lot of files.  We limit, but there are about 3300
[files,srchCmd] = st.search('file',...
    'project label exact',thisProject{1}.project.label,...
    'limit',88,...
    'summary',true);

%% Look for sessions in the GearTest collection

% Sessions that are part of the GearTest
sessions = st.search('session',...
    'collection label exact','GearTest',...
    'summary',true);

%% Analyses that are part of this session
analyses = st.search('analysis',...
    'session id',sessions{3}.session.x_id,...
    'summary',true);

%% The analysis is part of the session, not the  collection.

% So we can't search for analyses in a collection, as we did
% earlier.  Not sure what we really want.  We used to have files in
% analysis, analysis in collection, stuff like that.
% This code finds all the analyses in the collection by looping through the
% sessions
analyses = cell(length(sessions),1);
for ii=1:length(sessions)
    analyses{ii} = st.search('analysis',...
        'session id',sessions{ii}.session.x_id,...
        'summary',true);
end

%% Count the number of sessions created in a recent time period

sessions = st.search('session',...
    'session after time','now-16w',...
    'summary',true);

%% Get sessions with this subject code (vistalab)

sessions = st.search('session',...
    'subject code','ex4842',...
    'all_data',true,...
    'summary',true);

%% Get sessions in which the subject age is within a range

sessions = st.search('session', ...
    'subject age range',[10,11], ...
    'summary',true);

%% Find a session with a specific label

% Note that multiple sessions can have the same label!!
sessionLabel = '20151128_1621';  % There are two sessions with this label
sessions = st.search('session',...
    'session label exact',sessionLabel,...
    'summary',true);

for ii=1:length(sessions)
    disp(sessions{ii}.project.label)
    files = st.search('file',...
        'session label exact',sessions{ii}.session.label,...
        'project label exact',sessions{ii}.project.label,...
        'filetype','nifti',...
        'summary',true);
end

% When we search constrained only to the session label, we get files from
% both sessions!  
files = st.search('file',...
    'session label exact',sessions{ii}.session.label,...
    'filetype','nifti',...
    'summary',true);

%% get files from a particular project and acquisition

files = st.search('file', ...
    'project label exact','VWFA FOV', ...
    'acquisition label exact','11_1_spiral_high_res_fieldmap',...
    'file type','nifti',...
    'summary',true);

% This is how to download the nifti file
%  fname = files{1}.source.name;
%  dl_file = stGet(files{1}, s.token, 'destination', fullfile(pwd,fname));
%  d = niftiRead(dl_file);

%% Search for files in collection; find session names
files = st.search('file',...
    'collection label exact','DWI',...
    'acquisition label contains','00 Coil Survey',...
    'summary',true);

%% get files in project/session/acquisition/collection
files = st.search('file',...
    'collection label contains','ENGAGE',...
    'acquisition label contains','T1w 1mm', ...
    'summary',true); %#ok<*NASGU>

%% get files in project/session/acquisition/collection
files = st.search('file',...
    'collection label exact','Anatomy Male 45-55',...
    'acquisition label contains','Localizer',...
    'file type','nifti',...
    'summary',true);

%% Find sessions in a project that contain an analysis and subject code
   
% In this case, we are searching through all the data, not just the data
% that we have ownership on.
[sessions,srchCmd] = st.search('session',...
    'project label exact','UMN', ...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'all_data',true,'summary',true); %#ok<*ASGLU>

[projects,srchCmd] = st.search('project',...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'all_data',true,'summary',true);

[projects,srchCmd] = st.search('project',...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'all_data',true,'summary',true);


%%  Find the number of projects owned by a specific group

groupName = 'wandell';
[projects,srchCmd] = st.search('project',...
    'project group',groupName,...
    'summary',true);

groupName = {'aldit','jwday','leanew1'};
for ii=1:length(groupName)
    projects = st.search('project',...
        'project group',groupName{ii},...
        'summary',true);
end

%% Need to add "get group" to return a list of all group names

% Structs defining the group
groups = st.search('group','all')

% Just the group labels
labels = st.search('group','alllabels')

% The users for a particular group
users = st.search('group','users','wandell')

% Struct for a particular group 
thisGroup = st.search('group','name','wandell')

%%
