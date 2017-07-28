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
    
    thisDir = fullfile(obj.directory,obj.subjectFolders{ss});
    
    if obj.nSessions(ss) == 0
        % There is one session and thus no ses-XXX directory
        
        % gets subject data for subject s
        dataFolders = dirPlus(thisDir,...
            'ReturnDirs',true,...
            'PrependPath',false);
        
        % run through data for one subject and set in subjectData
        for kk = 1:length(dataFolders)
            if ismember(dataFolders{kk},dataTypes)
                DataInFolder = dirPlus(fullfile(thisDir,dataFolders{kk}),...
                    'PrependPath',false);
                % for example, this sets subjectData(s).anat = {'sub-01_T1w.nii.gz','sub-01_inplaneT2.nii.gz'};
                
                fnames = cell(length(DataInFolder),1);
                for ii=1:length(DataInFolder)
                    fnames{ii} = fullfile(obj.subjectFolders{ss},dataFolders{kk},DataInFolder{ii});
                end
                % Set the cell array to the structure
                obj.subjectData(ss).session(1).(dataFolders{kk}) = fnames;
            else
                [~,subject] = fileparts(obj.subjectFolders{ss});
                warning('Folder %s for subject %s not an allowable type.',dataFolders{kk},subject);
            end
        end
    else
        % Find the session folders
        sessionFolders = dirPlus(thisDir,...
            'ReturnDirs',true,...
            'PrependPath',false,...
            'DirFilter','ses');
        
        % Find the data files in session folder
        for ff=1:length(sessionFolders)
            
            % Find the data folders
            dataFolders = dirPlus(fullfile(thisDir,sessionFolders{ff}),...
                'ReturnDirs',true,...
                'PrependPath',false);
            
            % Loop through the data folders to list the files
            for kk = 1:length(dataFolders)
                if ismember(dataFolders{kk},dataTypes)
                    DataInFolder = dirPlus(fullfile(thisDir,sessionFolders{ff},dataFolders{kk}),...
                        'PrependPath',false);
                    % for example, this sets 
                    % subjectData(s).session(f).anat = {'sub-01_T1w.nii.gz','sub-01_inplaneT2.nii.gz'};
                    fnames = cell(length(DataInFolder),1);
                    for ii=1:length(DataInFolder)
                        fnames{ii} = ...
                            fullfile(obj.subjectFolders{ss},sessionFolders{ff},dataFolders{kk},DataInFolder{ii});
                    end
                    obj.subjectData(ss).session(ff).(dataFolders{kk}) = fnames;
                else
                    [~,subject] = fileparts(obj.subjectFolders{ss});
                    warning('Folder %s for subject %s not an allowable type.',dataFolders{kk},subject);
                end
            end
        end
    end
    
end

end
