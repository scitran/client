% Upload local analysis output to Flywheel

%% Get the session we're interested in

% Get all Flywheel Sessions
subject_code = '';
all_sessions = fw.getAllSessions;
session = all_sessions{contains(cellfun(@(s) {s.subject.code}, all_sessions), subject_code)};
session = fw.getSession(session.id);

%% DO LOCAL ANALYIS


%% Create new analysis

% Build the analysis struct
analysis = [];
analysis.label = 'Local Analysis Example';

% Here we point to the data in Flywheel that was used as input to the local analysis.
% To do that you need the type of the file's parent container, the id of that container
% and the name of the file

% TODO
containerType = 'acquisition'; 
acquisiton = fw.getAcquisition('');
inputFileName = '';

% Build analysis input struct
analysis.inputs{1} = struct('type', containerType, ...
                            'id', acquisition.id,...
                            'name', inputFileName);


% Create the analysis, which returns the analysis ID we'll need to upload local outputs
analysis_id = fw.addSessionAnalysis(session.id, analysis);


%% Upload local analysis results

% Once the local analysis is done you can point to the output file(s)
analysis_output = '';

% Upload the local analysis file(s)
fw.uploadOutputToAnalysis(analysis_id, analysis_output);


%% Additional tasks

% Add a note to the analysis
fw.addAnalysisNote(my_analysis_id, 'Local Analysis Test Note');

% Add analysis info (metadata)
info = struct('config parameter 1', 'some value', 'another_key', 10);
fw.setAnalysisInfo(my_analysis_id, info);

