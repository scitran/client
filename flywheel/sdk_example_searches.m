% Example searches for use with Flywheel's Matlab sdk.
% NOTE: These examples are specific to one Flywheel Instance (Vistalab @Stanford).
% The specific search terms would need to be modified to be used with another FW instance.

%% List all projects

% projects = fw.search('projects')
searchStruct = struct('return_type', 'project');
results = fw.search(searchStruct).results;
% Extract projects from results
projects = [];
for n = 1 : length(results)
    projects{n} = results{n}.x0x5F_source;
end


%% Find project by label
% Needs short form
% projects = fw.search('projects','project label contains','vwfa');

% Define search -- return a project and match filters
%    Put _0x2E_ in the Matlab variable to create a '.' (dot) in the JSON variable
searchStruct = struct('return_type', 'project', ...
        'filters', {{struct('match', struct('project_0x2E_label', 'vwfa'))}});
results = fw.search(searchStruct);
projectID = results.results{1}.x0x5F_source.project.x0x5F_id;



%% Get all the sessions within a specific collection
% [sessions, srchCmd] = fw.search('sessions in collection',...
%    'collection label contains','Anatomy Male 45-55');
searchStruct = struct('return_type', 'session', ...
        'filters', {{struct('match', struct('collection_0x2E_label', 'Amatomy Male 45-55'))}});
results = fw.search(searchStruct).results;
% Extract sessions from results
sessions = [];
for n = 1 : length(results)
    sessions{n} = results{n}.x0x5F_source;
end



%% Get the sessions within the first project
% sessions = fw.search('sessions','project id',projectID);
searchStruct = struct('return_type', 'session', ...
        'filters', {{struct('term', struct('project_0x2E__id', projectID))}});
results = fw.search(searchStruct).results;
% Extract sessions from results
sessions = [];
for n = 1 : length(results)
    sessions{n} = results{n}.x0x5F_source;
end

sessionID = sessions{1}.session.x0x5F_id;
sessionLabel = sessions{1}.session.label;



%% Get the acquisitions inside a session

% acquisitions = fw.search('acquisitions',...
%     'session id',sessionID);
searchStruct = struct('return_type', 'acquisition', ...
        'filters', {{struct('term', struct('session_0x2E__id', sessionID))}});
results = fw.search(searchStruct).results;
% Extract sessions from results
acquisitions = [];
for n = 1 : length(results)
    acquisitions{n} = results{n}.x0x5F_source;
end



%% Find nifti files in the session
% files = fw.search('files',...
%     'session id',sessionID,...
%     'file type','nifti');
% nFiles = length(files);

searchStruct = struct('return_type', 'file', ...
        'filters', {{struct('term', struct('session_0x2E__id', sessionID)) ...
                    struct('term', struct('file_0x2E_type', 'nifti'))}});
files = fw.search(searchStruct).results;
% Display result info
fprintf('Found %d nifti files in the session: %s\n', length(files), sessionLabel);



%% Look for analyses in the GearTest collection

% analyses = fw.search('analyses','collection label','GearTest');
% fprintf('Analyses in collections and sessions: %d\n',length(analyses));

% NOTE: this works only the way below, you currently cannot get analyses on the session in a collection by search the collection
% If this is a hard requirement, please let us know

% Analyses that are within a collection

% Returns analyses attached only to the collection, but not the sessions
% and acquisitions in the collection.

% analyses = fw.search('analysesincollection','collection label','GearTest');
% fprintf('Analyses in collections only %d\n',length(analyses));
searchStruct = struct('return_type', 'analysis', ...
        'filters', {{struct('match', struct('collection_0x2E_label', 'GearTest'))}});
analyses = fw.search(searchStruct).results;


% Which collection is the analysis in?
% collections = fw.search('collections','collection label','GearTest');
% fprintf('Collections found %d\n',length(collections));
searchStruct = struct('return_type', 'collection', ...
        'filters', {{struct('match', struct('collection_0x2E_label', 'GearTest'))}});
collections = fw.search(searchStruct).results;
% Display result info
fprintf('Collections found %d', length(collections));





% Returns analyses attached only to the sessions in the collection,
% but not to the collection as a whole.

% analyses = fw.search('analyses in session','collection label','GearTest');
% fprintf('Analyses found %d\n',length(analyses));

% Note: functionality not currently supported. Like above, please let us know
%   if this is a hard requirement for the fist release

% Find a session from that collection

% sessions = fw.search('sessions','session label',sessions{1}.source.label);

searchStruct = struct('return_type', 'session', ...
        'filters', {{struct('match', struct('session_0x2E_label', ...
        'sessionLabel'))}});
sessions = fw.search(searchStruct).results;



%% Count the number of sessions created in a recent time period

% sessions = fw.search('sessions',...
%     'session after time','now-16w');
% fprintf('Found %d sessions in previous four weeks \n',length(sessions))

searchStruct = struct('return_type', 'session', ...
        'filters', {{struct('range', struct('session_0x2E_created', ...
        struct('gte', 'now-16w')))}});
sessions = fw.search(searchStruct).results;

% Display result info
fprintf('Found %d sessions in the previous 16 weeks\n', length(sessions));


%% Get sessions with this subject code
% subjectCode = 'ex4842';
% sessions = fw.search('sessions','subject code','ex4842',...
%     'all_data',true);
% fprintf('Found %d sessions with subject code %s\n',length(sessions),subjectCode)

subjectCode = 'ex4842';
searchStruct = struct('return_type', 'session', ...
        'filters', {{struct('match', struct('subject_0x2E_code', ...
        subjectCode))}});
sessions = fw.search(searchStruct).results;

% Display result info
fprintf('Found %d sessions with subject code %s\n', length(sessions), subjectCode);


%% Get sessions in which the subject age is within a range

% sessions = st.search('sessions',...
%     'subject age gt', 9, ...
%     'subject age lt', 10,...
%     'summary',true);

searchStruct = struct('return_type', 'session', ...
        'filters', {{struct('range', ...
        struct('subject_0x2E_age_in_years', ...
        struct('gte', 9, 'lt', 10) ...
        ))}});
sessions = fw.search(searchStruct).results;

% Display result info
fprintf('Found %d sessions in the age range 9-10\n', length(sessions));


%% Find a session with a specific label

% sessionLabel = '20151128_1621';
% files = fw.search('files','session label contains',sessionLabel);
% fprintf('Found %d files from the session label %s\n',length(files),sessionLabel)

sessionLabel = '20151128_1621';
searchStruct = struct('return_type', 'file', ...
        'filters', {{struct('match', ...
        struct('session_0x2E_label', sessionLabel) ...
        )}});
files = fw.search(searchStruct).results;

% Display result info
fprintf('Found %d files from session label %s\n', length(files), sessionLabel);



%% Get files from a particular project and acquisition

% files = fw.search('files', ...
%     'project label','VWFA FOV', ...
%     'acquisition label','11_1_spiral_high_res_fieldmap',...
%     'file type','nifti',...
%     'summary',true);
% This is how to download the nifti file
%  fname = files{1}.source.name;
%  dl_file = stGet(files{1}, s.token, 'destination', fullfile(pwd,fname));
%  d = niftiRead(dl_file);

searchStruct = struct('return_type', 'file', ...
        'filters', ...
        {{struct('match', struct('project_0x2E_label', 'VWFA FOV')), ...
        struct('match', struct('acquisition_0x2E_label', '11_1_spiral_high_res_fieldmap')), ...
        struct('term', struct('file_0x2E_type', 'nifti')), ...
        }});
files = fw.search(searchStruct).results;


%% Search for files in collection; find session names
% files = fw.search('files',...
%     'collection label','DWI',...
%     'acquisition label','00 Coil Survey');
% fprintf('Found %d files\n',length(files));

searchStruct = struct('return_type', 'file', ...
        'filters', ...
        {{struct('match', struct('collection_0x2E_label', 'DWI')), ...
        struct('match', struct('acquisition_0x2E_label', '00 Coil Survey')), ...
        }});
files = fw.search(searchStruct).results;

% Display result info
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

% If I understand the above correctly, its looking to print a unique list of session names
% for the files found in the previous search. That data is available in the results:

sessionNames = [];
for ii=1:length(files)
    sessionNames{ii} = files{ii}.x0x5F_source.session.label
end

sessionsNames = unique(sessionNames);
fprintf('\n---------\n');
for ii=1:length(sessionNames)
    fprintf('%3d:  Session name %s\n',ii,sessionNames{ii});
end
fprintf('---------\n');



%% Get files in project/session/acquisition/collection
% files = fw.search('files',...
%     'collection label contains','ENGAGE',...
%     'acquisition label contains','T1w 1mm', ...
%     'summary',true); %#ok<NASGU>

searchStruct = struct('return_type', 'file', ...
        'filters', ...
        {{struct('match', struct('collection_0x2E_label', 'ENGAGE')), ...
        struct('match', struct('acquisition_0x2E_label', 'T1w 1mm')), ...
        }});
files = fw.search(searchStruct).results;
% Display result info
fprintf('Found %d files\n',length(files));






%% Get files in project/session/acquisition/collection
% files = fw.search('files',...
%     'collection label','Anatomy Male 45-55',...
%     'acquisition label','Localizer',...
%     'file type','nifti');
% fprintf('Found %d matching files\n',length(files))

searchStruct = struct('return_type', 'file', ...
        'filters', ...
        {{struct('match', struct('collection_0x2E_label', 'Anatomy Male 45-55')), ...
        struct('match', struct('acquisition_0x2E_label', 'Localizer')), ...
        struct('term', struct('file_0x2E_type', 'nifti')), ...
        }});
files = fw.search(searchStruct).results;
% Display result info
fprintf('Found %d files\n',length(files));




%% Find sessions in this project that contain an analysis

% In this case, we are searching through all the data, not just the data
% that we have ownership on.

% [sessions,srchS] = fw.search('sessions',...
%     'project label','UMN', ...
%     'session contains analysis', 'AFQ', ...
%     'session contains subject','4279',...
%     'all_data',true,'summary',true);

searchStruct = struct('return_type', 'session', ...
        'all_data', true, ...
        'filters', ...
        {{struct('match', struct('project_0x2E_label', 'UMN')), ...
        struct('match', struct('analysis_0x2E_label', 'AFQ')), ...
        struct('term', struct('subject_0x2E_code', '4279')), ...
        }});
sessions = fw.search(searchStruct).results;
% Display result info
fprintf('Found %d sessions\n',length(sessions));





%% Find the number of projects owned by a specific group
% groupName = {'ALDIT','wandell','jwday','leanew1'}
% for ii=1:length(groupName)
%     projects = st.search('projects','project group',groupName{ii});
%     fprintf('%d projects owned by the %s group\n',length(projects), groupName{ii});
% end

% Note: I noticed an improvement that can be made to Emerald Search via this query
% We do not index _id fields a way that is useful for terms searches (exact matching a list of strings)
% Ticket added to support this behavior

groupName = {{'adni', 'wandell', 'jwday', 'leanew1'}};
for ii=1:length(groupName)
    searchStruct = struct('return_type', 'project', ...
        'filters', ...
        {{struct('term', struct('group_0x2E_label', groupName{ii})), ...
        }});
    projects = fw.search(searchStruct).results;
    fprintf('%d projects owned by the %s group\n',length(projects), groupName{ii});
end
