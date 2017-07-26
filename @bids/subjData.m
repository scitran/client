function subjData(obj)

% Make a list of the data types for one subject

% check: does this subject have sessions?
%   if no sessions: do the following
%   if sessions: TODO

for s = 1:obj.nParticipants

    % gets subject data for subject s
    ThisSubjData = dirPlus(obj.subjectFolders{s},...
        'ReturnDirs',true,...
        'PrependPath',false);

    if isequal('ses',ThisSubjData{1}(1:3)) % there are multiple sessions
        error('function can not yet handle multiple session data')   
    end

    % run through data for one subject and set in subjectData
    for k = 1:length(ThisSubjData)
        DataInFolder = dirPlus([obj.subjectFolders{s} '/' ThisSubjData{k}],...
            'PrependPath',false);
        % for example, this sets subjectData(s).anat = {'sub-01_T1w.nii.gz','sub-01_inplaneT2.nii.gz'};
        obj.subjectData(s).(ThisSubjData{k}) = DataInFolder;
    end
end
