%% One way to init
st = scitran('stanfordlabs');
fw = st.fw;

%% Alternative method to init SDK
api_key = 'key';

% Init SDK
fw = flywheel.Flywheel(api_key);
%% Get the session we're interested in

% Get all Flywheel Sessions
subject_code = 'HERO_gka1';
all_sessions = fw.getAllSessions;

clear scode;
for ii=1:numel(all_sessions)
    if ischar(all_sessions{ii}.subject.code)
        scode{ii} = all_sessions{ii}.subject.code;
    else
        fprintf('%d\n',ii);
        disp(all_sessions{ii}.subject.code)
    end
end
scode = unique(scode);

% Might only work after 2017a
% session = all_sessions{contains(cellfun(@(s) {s.subject.code}, all_sessions), subject_code)};
for ii=1:numel(all_sessions)
    if strcmp(all_sessions{ii}.subject.code,subject_code)
        fprintf('Found session %d\n',ii);
        session = fw.getSession(all_sessions{ii}.id);
        break;
    end
end


%% Get the analysis

session_analyses = session.analyses;
input_analysis = fw.getAnalysis(session.analyses{1}.id);


%% Download a file from analysis

% Have a look at the files
disp(cellfun(@(f) {f.name}, input_analysis.files))

% Grab the segmented image
input_file = 'HERO_gka1_aparc.a2009s+aseg.nii.gz';
dest_path = fullfile('/scratch', input_file);
fw.downloadOutputFromAnalysis(input_analysis.id, input_file, dest_path);


%% DO LOCAL ANALYIS

analysis_output = fullfile('/scratch', 'analyzed_nifti.nii.gz');
movefile(dest_path, analysis_output);


%% Create new analysis and upload data

% Build the analysis struct
analysis = [];
analysis.label = 'Wonderful Analysis TEST 2';
analysis.inputs{1} = struct('type', 'analysis', ...
                            'id', input_analysis.id,...
                            'name', input_file);

% Create the analysis, which returns the ID
my_analysis_id = fw.addSessionAnalysis(session.id, analysis);

% Upload the output files
fw.uploadOutputToAnalysis(my_analysis_id, analysis_output);

% Add a note
fw.addAnalysisNote(my_analysis_id, 'An amazing note!');

% Add analysis info
info = struct('some_key', 'somevalue', 'another_key', 10);
fw.setAnalysisInfo(my_analysis_id, info);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unstructured example code

%%

api_key = '';
fw = flywheel.Flywheel(api_key);
all_projects = fw.getAllProjects;
project_label = 'Ariel''s test project';
project = all_projects{contains(cellfun(@(p) {p.label}, all_projects), project_label)};
project_sessions = fw.getProjectSessions(project.id);

session_acquisitions = fw.getSessionAcquisitions(project_sessions{1}.id);
file_ref = struct('id', session_acquisitions{1}.id, 'type', 'acquisition', 'name', session_acquisitions{1}.files{1}.name);
analysis = struct('label', 'LMP Test7', 'inputs', {{file_ref}});
analysisId = fw.addProjectAnalysis(project.id, analysis);

% Upload the output files
analysis_output_files = {fullfile('/scratch', 'analyzed_nifti.nii.gz'), fullfile('/tmp', 'flywheel', 'T1w.pdf')};
fw.uploadOutputToAnalysis(analysisId, analysis_output_files);

analysis_output = fullfile('/scratch', 'analyzed_nifti.nii.gz');
if exist(analysis_output, 'file')
    disp('Uploading...')
    fw.uploadOutputToAnalysis(analysisId, analysis_output);
end
analysis_output = fullfile('/tmp', 'flywheel', 'T1w.pdf');
if exist(analysis_output, 'file')
    disp('Uploading...')
    fw.uploadOutputToAnalysis(analysisId, analysis_output);
end

% Add a note
fw.addAnalysisNote(analysisId, 'An amazing note!');
% Add analysis info
info = struct('some_key', 'somevalue', 'another_key', 10);
fw.setAnalysisInfo(analysisId, info);


collection = struct('public', true, 'label','Tesing Collection Public');
fw.addCollection(collection)


Collection_id = '5b23ef6a3fabdf00200e87eb';
fw.addCollectionAnalysis(Collection_id, analysis);




file_ref = {};

for NumFiles = 1:length(FilesAnalyzed)
    file_ref{end+1} = struct('id', FilesAnalyzedId{NumFiles}, 'type', 'acquisition', 'name', FilesAnalyzed{NumFiles});
end

analysis = struct('label', 'testAnalysis2', 'inputs', {file_ref});
analysisId = fw.addProjectAnalysis(project.id, analysis);

fw.uploadOutputToAnalysis(analysisId, '/private/tmp/flywheel/T1w.pdf');
fw.uploadOutputToAnalysis(analysisId, '/private/tmp/flywheel/T2w.pdf');
fw.uploadOutputToAnalysis(analysisId, '/private/tmp/flywheel/bold.pdf');
fw.uploadOutputToAnalysis(analysisId, '/private/tmp/flywheel/outliers.csv');
