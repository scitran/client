function subjData(obj)
%SUBJDATA - - Make a list of the data types for one subject
%
%   @bids.subjData;
%
% Fills the subjectData slot in the bids object.
%
% Programming
%  check: does this subject have sessions?
%    if no sessions: do the following
%    if sessions: TODO
%
% DH Scitran 2017

dataTypes  =  obj.dataTypes;

for ss = 1:obj.nParticipants
    
    if obj.nSessions(ss) == 0
        % There is one session and thus no ses-XXX directory
        
        % gets subject data for subject s
        dataFolders = dirPlus(obj.subjectFolders{ss},...
            'ReturnDirs',true,...
            'PrependPath',false);
        
        % run through data for one subject and set in subjectData
        for kk = 1:length(dataFolders)
            if ismember(dataFolders{kk},dataTypes)
                DataInFolder = dirPlus([obj.subjectFolders{ss} '/' dataFolders{kk}],...
                    'PrependPath',false);
                % for example, this sets subjectData(s).anat = {'sub-01_T1w.nii.gz','sub-01_inplaneT2.nii.gz'};
                obj.subjectData(ss).session(1).(dataFolders{kk}) = DataInFolder;
            else
                [~,subject] = fileparts(obj.subjectFolders{ss});
                warning('Folder %s for subject %s not an allowable type.',dataFolders{kk},subject);
            end
        end
    else
        % Find the session folders
        sessionFolders = dirPlus(obj.subjectFolders{ss},...
            'ReturnDirs',true,...
            'PrependPath',true,...
            'DirFilter','ses');
        
        % Find the data files in session folder
        for ff=1:length(sessionFolders)
            
            % Find the data folders
            dataFolders = dirPlus(sessionFolders{ff},...
                'ReturnDirs',true,...
                'PrependPath',false);
            
            % Loop through the data folders to list the files
            for kk = 1:length(dataFolders)
                if ismember(dataFolders{kk},dataTypes)
                    DataInFolder = dirPlus(fullfile(sessionFolders{ff},dataFolders{kk}),...
                        'PrependPath',false);
                    % for example, this sets subjectData(s).session(f).anat = {'sub-01_T1w.nii.gz','sub-01_inplaneT2.nii.gz'};
                    obj.subjectData(ss).session(ff).(dataFolders{kk}) = DataInFolder;
                else
                    [~,subject] = fileparts(obj.subjectFolders{ss});
                    warning('Folder %s for subject %s not an allowable type.',dataFolders{kk},subject);
                end
            end
        end
    end
    
end

end
