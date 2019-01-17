%% Flywheel search tutorial
%
% Syntax:
%   [results, srchCmd ]  = st.search(searchType,'parameter',value,...)
%
% Inputs
%  searchType - a string that defines the type of object that will be
%               returned.  Valid strings are stored in stValid('search return')
%
% Optional key/value pairs
%  varagin - There are many key/value pairs that define the search.
%
% Outputs
%  results - a cell array of database descriptions
%  srchCmd - a struct that can be used to rerun the search
%
% For further documentation, see the scitran.search or these documents
%
%  * <https://github.com/scitran/client/wiki scitran/client wiki page>, and
%  specifically the pages on
%
%  * <https://github.com/scitran/client/wiki/Search Search> and the
%  * <https://github.com/scitran/client/wiki/Search-examples search examples>
%
% LMP/BW Scitran Team, 2017
%
% See also
%

%% Examples
%{
 % This script is a set of examples.
%}

%% Site authorization


%% Open a connection

% You may need to create a local token for your site.  You can do this
% using
%    scitran('yourSite','action','create');
%
% You will be queried for the apiKey on the Flywheel User Profile page. See
% the scitran wiki page for complete instructions.
%
% At Stanford, we have a stanfordlabs site.  You will have to replace
% 'stanfordlabs' with the name for your site.
%
st = scitran('stanfordlabs');
st.verify;

%% List all projects

% All the projects you are part of
projects = st.search('project','summary',true);
stPrint(projects,'project','label')
assert(length(projects) >= 35);

%% All the projects, not just the ones you are part of

projects = st.search('project',...
    'all data',true,...
    'summary',true);
stPrint(projects,'project','label')
assert(length(projects) >= 62);

projectID = st.objectParse(projects{end});
projectLabel = projects{end}.project.label;

%% Print all the collections

collections = st.search('collection',...
    'summary',true);
stPrint(collections,'collection','label');

%% Exact and contains matches

% Not working yet
[projects,srchCmd] = st.search('project',...
    'summary',true,...
    'project label exact','VWFA');
projects{1}.project.label

%% You can also set up a struct with search parameters and run that

projects = st.search(srchCmd,'summary',true);
projects{1}.project.label

%% Project with a label containing VWFA

[projects,srchCmd] = st.search('project',...
    'summary',true,...
    'project label contains','vwfa');

% Save this project information
projectID = st.objectParse(projects{end});
projectLabel = projects{end}.project.label;

%% Get a sessions within a specific collection with a subject code

sessions = st.search('session',...
    'collection label exact','Anatomy Male 45-55',...
    'subject code','SU ex10316',...
    'summary',true);

%% Get all the sessions within a specific collection **

[sessions, srchCmd] = st.search('session',...
    'collection label exact','Anatomy Male 45-55',...
    'summary',true);

%% Something seems wrong about collection label contains **

% Nothing found
[collection, srchCmd] = st.search('collection',...
    'collection label contains','Anatomy Male',...
    'summary',true);

% We do find the collection when we use collection label exact
% and 'Anatomy Male 45-55'
[collection, srchCmd] = st.search('collection',...
    'collection label exact','Anatomy Male 45-55',...
    'summary',true);


%% Get the sessions within a project

sessions = st.search('session',...
    'project id',projectID,...
    'summary',true);

% Save this session information
sessionID = st.objectParse(sessions{1});
sessionLabel = sessions{1}.session.label;

%% Get the session with this particular sessionID
sessions = st.search('session',...
    'session id',sessionID,...
    'summary',true);

%% Get the acquisitions inside a session using the ID

acquisitions = st.search('acquisition',...
    'session id',sessionID,...
    'summary',true);

%% Find acquisitions in the project containing a string

[acquisitions,srchCmd] = st.search('acquisition',...
    'string','BOLD_EPI',...
    'project label exact','ALDIT', ...
    'summary',true);
stPrint(acquisitions,'acquisition','label');

%%

[projects,srchCmd] = st.search('project',...
    'string','BOLD_EPI',...
    'summary',true);

%% Projects that have this string somewhere in their representation

[projects,srchCmd] = st.search('project',...
    'string','BOLD_EPI',...
    'summary',true);
stPrint(projects,'project','label');

%% Sessions that have the string somewhere

[sessions,srchCmd] = st.search('session',...
    'string','BOLD_EPI',...
    'summary',true);

% What is the project label of each session?
stPrint(sessions,'project','label');

%% Restrict to one project
thisProject = 'ALDIT';
[sessions,srchCmd] = st.search('session',...
    'string','BOLD_EPI',...
    'project label exact',thisProject,...
    'summary',true);

%% Finding files in various ways (not tested)

[files,srchCmd] = st.search('file',...
    'acquisition id',st.objectParse(acquisitions{1}),...
    'summary',true);

%%
[files,srchCmd] = st.search('file',...
    'session id',sessionID,...
    'summary',true);

%% A lot of files in a project

[files,srchCmd] = st.search('file',...
    'project id',files{1}.project.id,...
    'filetype','nifti',...
    'summary',true);
    
stPrint(files,'file','name');

%% Find files in the project using a label

% Get the label
thisProject = st.search('project',...
    'project label contains',...
    'VWFA','limit',1,...
    'fw',true);

%% There are a lot of files.  We limit, but there are about 3300
[files,srchCmd] = st.search('file',...
    'project label exact',thisProject{1}.label,...
    'limit',88,...
    'summary',true);

%% Look for sessions in the GearTest collection

sessions = st.search('session',...
    'collection label exact','GearTest',...
    'summary',true);

stPrint(sessions,'label');

%% Analyses that are part of this session
analyses = st.search('analysis',...
    'session id',st.objectParse(sessions{3}),...
    'summary',true);

%% The analysis is part of the session, not the  collection.

% We can't search for analyses in a collections yet. We used to have files
% in analysis, analysis in collection, stuff like that. This code finds all
% the analyses in the collection by looping through the sessions
analyses = cell(length(sessions),1);
for ii=1:length(sessions)
    analyses{ii} = st.search('analysis',...
        'session id',st.objectParse(sessions{ii}),...
        'summary',true);
end

%% Count the number of sessions created in a recent time period

sessions = st.search('session',...
    'session after time','now-16w',...
    'summary',true);

%% Get sessions with this subject code (stanfordlabs)

sessions = st.search('session',...
    'subject code','ex4842',...
    'allData',true,...
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

%% Search for files in collection; find session names

% ** Something wrong with contains for the acquisition.
% When it is exact, contains fails.
files = st.search('file',...
    'collection label exact','DWI',...
    'acquisition label exact','00 Coil Survey',...
    'summary',true);

%% get files in project/session/acquisition/collection **

% Another case in which contains fails.
files = st.search('file',...
    'collection label contains','ENGAGE',...
    'acquisition label contains','T1w 1mm', ...
    'summary',true); %#ok<*NASGU>

% This one works
collection = st.search('collection',...
    'collection label contains','ENGAGE',...
    'summary',true); %#ok<*NASGU>

%% get files in project/session/acquisition/collection

% ** Here again, contains on the acquisition doesn't run right.  exact
% works OK.
% Could be the way we set it up in st.search.
files = st.search('file',...
    'collection label exact','Anatomy Male 45-55',...
    'acquisition label exact','Localizer',...
    'file type','nifti',...
    'summary',true);

%% Find sessions in a project that contain an analysis and subject code
   
% In this case, we are searching through all the data, not just the data
% that we have ownership on.
[sessions,srchCmd] = st.search('session',...
    'project label exact','UMN', ...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'allData',true,'summary',true); %#ok<*ASGLU>

%%
[projects,srchCmd] = st.search('project',...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'allData',true,'summary',true);

%%
[projects,srchCmd] = st.search('project',...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'allData',true,'summary',true);


%%  Find the number of projects owned by a specific group, by label **

% Case sensitive
group = 'wandell';
[projects,srchCmd] = st.search('project',...
    'group id',group,...
    'summary',true);

%% jwday fails, as below ... ** 
group = {'ALDIT','jwday','PanLab'};
for ii=1:length(group)
    disp(group{ii})
    projects = st.search('project',...
        'group id',group{ii},...
        'summary',true);
end

%% Looking up group information

% Structs defining the group
groups = st.search('group','all');
stPrint(groups,'label')
stPrint(groups,'id')

%% Just the group labels
labels = st.search('group','all labels');
disp(labels)

%% The users for a particular group
users = st.search('group','users','wandell');
disp(users)

%% Struct for a particular group 
thisGroup = st.search('group','name','wandell');
disp(thisGroup)

%% Or by group name, which is also the group id

% ** Fails.  There is a group label 'Wandell Lab'
group = 'wandell';
[projects,srchCmd] = st.search('project',...
    'group id',group,...
    'summary',true);

%% Return collections

collections = st.search('collection',...
    'collection label contains','GearTest',...
    'summary',true);

%% All collections
collections = st.search('collection','summary',true);

%% Return analyses **  Fails for project label contains, but works for exact

% Analyses within a project
analyses = st.search('analysis',...
    'project label exact','VWFA FOV',...
    'summary',true);

%% Freesurfer analyses in the whole stanfordlabs database
analyses = st.search('analysis',...
    'analysis label contains','freesurfer-recon-all',...
    'summary',true);

%% END