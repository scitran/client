%% Gist file from github
% https://gist.github.com/nagem/0ce6f1daf56400e782639485a9ade865
%
from flywheel import flywheel

API_KEY = 'my_api_key'

# create fw instance, login using API_KEY
## fw = scitran('scitran');

fw = Flywheel(API_KEY)

# List all projects

# projects = fw.search('projects')

projects = [ x['_source'] for x in fw.search({
    'return_type': 'project'
}).get('results', []) ]





# Needs short form
# projects = fw.search('projects','project label contains','vwfa');

projects = [ x['_source'] for x in  fw.search({
    'return_type': 'project',
    'filters': [
        {'match': {'project.label': 'ADNI'}}
    ]
}).get('results', []) ]

projectID = projects[0]['project']['_id']




# Get all the sessions within a specific collection
# [sessions, srchCmd] = fw.search('sessions in collection',...
#    'collection label contains','Anatomy Male 45-55');

sessions = [ x['_source'] for x in fw.search({
    'return_type': 'session',
    'filters': [
        {'match': {'collection.label': 'Anatomy Male 45-55'}}
    ]
}).get('results', []) ]




# Get the sessions within the first project
# sessions = fw.search('sessions','project id',projectID);

sessions = [ x['_source'] for x in fw.search({
    'return_type': 'session',
    'filters': [
        {'term': {'project._id': projectID}}
    ]
}).get('results', []) ]

sessionID = sessions[0]['session']['_id']
sessionLabel = sessions[0]['session']['label']


# Get the acquisitions inside a session

# acquisitions = fw.search('acquisitions',...
#     'session id',sessionID);
# fprintf('Found %d acquisitions in session %s\n',length(acquisitions),sessionLabel);

acquisitions = [ x['_source'] for x in fw.search({
    'return_type': 'acquisition',
    'filters': [
        {'term': {'session._id': sessionID}}
    ]
}).get('results', []) ]




# Find nifti files in the session
# files = fw.search('files',...
#     'session id',sessionID,...
#     'file type','nifti');
# nFiles = length(files);
# fprintf('Found %d nifti files in the session %s\n',nFiles,sessionLabel);

files = [ x['_source'] for x in fw.search({
    'return_type': 'file',
    'filters': [
        {'term': {'session._id': sessionID}},
        {'term': {'file.type': 'nifti'}}
    ]
}).get('results', []) ]
nFiles = len(files)
print 'Found {} nifti files in the session {}\n'.format(nFiles, sessionLabel)




# Look for analyses in the GearTest collection

# analyses = fw.search('analyses','collection label','GearTest');
# fprintf('Analyses in collections and sessions: %d\n',length(analyses));

# NOTE: this works only the way below, you currently cannot get analyses on the session in a collection by search the collection
# If this is a hard requirement, please let us know

# Analyses that are within a collection

# Returns analyses attached only to the collection, but not the sessions
# and acquisitions in the collection.

# analyses = fw.search('analysesincollection','collection label','GearTest');
# fprintf('Analyses in collections only %d\n',length(analyses));

analyses = [ x['_source'] for x in fw.search({
    'return_type': 'analysis',
    'filters': [
        {'match': {'collection.label': 'GearTest'}}
    ]
}).get('results', []) ]



# Which collection is the analysis in?
# collections = fw.search('collections','collection label','GearTest');
# fprintf('Collections found %d\n',length(collections));

collections = [ x['_source'] for x in fw.search({
    'return_type': 'collection',
    'filters': [
        {'match': {'collection.label': 'GearTest'}}
    ]
}).get('results', []) ]
print 'Collections found {}\n'.format(len(collections))



# Returns analyses attached only to the sessions in the collection,
# but not to the collection as a whole.

# analyses = fw.search('analyses in session','collection label','GearTest');
# fprintf('Analyses found %d\n',length(analyses));

# Note: functionality not currently supported. Like above, please let us know if this is a hard requirement for the fist release



 # Find a session from that collection

# sessions = fw.search('sessions','session label',sessions{1}.source.label);

sessions = [ x['_source'] for x in fw.search({
    'return_type': 'session',
    'filters': [
        {'match': {'session.label': sessionLabel}}
    ]
}).get('results', []) ]



# Count the number of sessions created in a recent time period

# sessions = fw.search('sessions',...
#     'session after time','now-16w');
# fprintf('Found %d sessions in previous four weeks \n',length(sessions))

sessions = [ x['_source'] for x in fw.search({
    'return_type': 'session',
    'filters': [
        {'range': {
            'session.created': {
                'gte': 'now-16w'
            }
        }}
    ]
}).get('results', []) ]
print 'Found {} sessions in the previous 16 weeks\n'.format(len(sessions))


# Get sessions with this subject code
# subjectCode = 'ex4842';
# sessions = fw.search('sessions','subject code','ex4842',...
#     'all_data',true);
# fprintf('Found %d sessions with subject code %s\n',length(sessions),subjectCode)

subjectCode = 'ex4842'
sessions = [ x['_source'] for x in fw.search({
    'return_type': 'session',
    'filters': [
        {'match': {'subject.code': subjectCode}}
    ]
}).get('results', []) ]
print 'Found {} sessions with subject code {}\n'.format(len(sessions), subjectCode)



# Get sessions in which the subject age is within a range

# sessions = st.search('sessions',...
#     'subject age gt', 9, ...
#     'subject age lt', 10,...
#     'summary',true);

sessions = [ x['_source'] for x in fw.search({
    'return_type': 'session',
    'filters': [
        {'range': {
            'subject.age_in_years': {
                'gte': 31,
                'lt': 32
            }
        }}
    ]
}).get('results', []) ]
print 'Found {} sessions in the age range 9-10\n'.format(len(sessions))



# Find a session with a specific label

# sessionLabel = '20151128_1621';
# files = fw.search('files','session label contains',sessionLabel);
# fprintf('Found %d files from the session label %s\n',length(files),sessionLabel)

sessionLabel = '20151128_1621'
files = [ x['_source'] for x in fw.search({
    'return_type': 'file',
    'filters': [
        {'match': {'session.label': sessionLabel}}
    ]
}).get('results', []) ]
print 'Found {} files from session label {}'.format(len(files), sessionLabel)




# get files from a particular project and acquisition

# files = fw.search('files', ...
#     'project label','VWFA FOV', ...
#     'acquisition label','11_1_spiral_high_res_fieldmap',...
#     'file type','nifti',...
#     'summary',true);
# This is how to download the nifti file
#  fname = files{1}.source.name;
#  dl_file = stGet(files{1}, s.token, 'destination', fullfile(pwd,fname));
#  d = niftiRead(dl_file);

files = [ x['_source'] for x in fw.search({
    'return_type': 'file',
    'filters': [
        {'match': {'project.label': 'VWFA FOV'}},
        {'match': {'acquisition.label': '11_1_spiral_high_res_fieldmap'}},
        {'term': {'file.type': 'nifti'}}
    ]
}).get('results', []) ]




 # search for files in collection; find session names
# files = fw.search('files',...
#     'collection label','DWI',...
#     'acquisition label','00 Coil Survey');
# fprintf('Found %d files\n',length(files));

files = [ x['_source'] for x in fw.search({
    'return_type': 'file',
    'filters': [
        {'match': {'collection.label': 'DWI'}},
        {'match': {'acquisition.label': '00 Coil Survey'}}
    ]
}).get('results', []) ]
print 'Found {} files\n'.format(len(files))


# %% Find the session name for these files
# % Make this work.  Something wrong!
# %
# % for ii=1:length(files)
# %     % srch.sessions.match.label = files{ii}.source.session.label;
# %     files{ii}.source.session.label
# %     thisSession = st.search('sessions','session label',files{ii}.source.session.label);
# %
# %     if ~isempty(thisSession)
# %         % This should not happen.  But it does.  So fix it. (BW).
# %         ii
# %         sessionNames{ii} = thisSession{1}.source.label;
# %     end
# % end
# % %
# % sessionNames = unique(sessionNames);
# % fprintf('\n---------\n');
# % for ii=1:length(sessionNames)
# %     fprintf('%3d:  Session name %s\n',ii,sessionNames{ii});
# % end
# % fprintf('---------\n');

# If I understand the above correctly, its looking to print a unique list of session names
# for the files found in the previous search. That data is available in the results:
sessionNames = set([x['session']['label'] for x in files])
print '\n----------\n'
for sn in sessionNames:
    print sn
print '\n----------\n'




# get files in project/session/acquisition/collection
# files = fw.search('files',...
#     'collection label contains','ENGAGE',...
#     'acquisition label contains','T1w 1mm', ...
#     'summary',true); %#ok<NASGU>

files = [ x['_source'] for x in fw.search({
    'return_type': 'file',
    'filters': [
        {'match': {'collection.label': 'ENGAGE'}},
        {'match': {'acquisition.label': 'T1w 1mm'}}
    ]
}).get('results', []) ]
print 'Found {} files\n'.format(len(files))



# get files in project/session/acquisition/collection
# files = fw.search('files',...
#     'collection label','Anatomy Male 45-55',...
#     'acquisition label','Localizer',...
#     'file type','nifti');
# fprintf('Found %d matching files\n',length(files))

files = [ x['_source'] for x in fw.search({
    'return_type': 'file',
    'filters': [
        {'match': {'collection.label': 'Anatomy Male 45-55'}},
        {'match': {'acquisition.label': 'Localizer'}},
        {'term': {'file.type': 'nifti'}}
    ]
}).get('results', []) ]
print 'Found {} files\n'.format(len(files))



# Find sessions in this project that contain an analysis

# In this case, we are searching through all the data, not just the data
# that we have ownership on.

# [sessions,srchS] = fw.search('sessions',...
#     'project label','UMN', ...
#     'session contains analysis', 'AFQ', ...
#     'session contains subject','4279',...
#     'all_data',true,'summary',true);

sessions = [ x['_source'] for x in fw.search({
    'return_type': 'session',
    'all_data': True,
    'filters': [
        {'match': {'project.label': 'UMN'}},
        {'match': {'analysis.label': 'AFQ'}},
        {'term': {'subject.code': '4279'}}
    ]
}).get('results', []) ]
print 'Found {} sessions\n'.format(len(sessions))



# Find the number of projects owned by a specific group
# groupName = {'ALDIT','wandell','jwday','leanew1'}
# for ii=1:length(groupName)
#     projects = st.search('projects','project group',groupName{ii});
#     fprintf('%d projects owned by the %s group\n',length(projects), groupName{ii});
# end

# Note: I noticed an improvement that can be made to Emerald Search via this query
# We do not index _id fields a way that is useful for terms searches (exact matching a list of strings)
# Ticket added to support this behavior

groupNames = ['adni', 'wandell', 'jwday', 'leanew1']
projects = [ x['_source'] for x in fw.search({
    'return_type': 'project',
    'filters': [
        {'terms': {'group.label': groupNames}}
    ]
}).get('results', []) ]
print 'Found {} projects\n'.format(len(projects))