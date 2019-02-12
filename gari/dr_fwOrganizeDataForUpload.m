% Select project
projName = 'CoRR';
projName = 'BCBL_ILLITERATES';




switch projName
    case {'HCP'}
        warning('It is in python now, move it here')
    case {'CoRR'}
        % DATAdir in black.stanford.edu
        dataDir = '/data/localhome/glerma/PROJECTS/dr/DATA';
        destSessionLabels = {'TEST', 'RETEST', 'RETEST2', 'RETEST3', 'RETEST4', ...
                         'RETEST5', 'RETEST6', 'RETEST7', 'RETEST8', ...
                         'RETEST9', 'RETEST10','RETEST11','RETEST12'};

        % Organize the data for FW uploading 
        projDir = fullfile(dataDir, projName);

        cd(projDir);
        metaData=readtable('6720_CoRR_Data_Legend_20180626_oneHeader.csv', ...
                            'ReadVariableNames', true);
        % Remove all the empty variables (do it at the end)
        metaData = metaData;
        
        % Create destination folder
        destFolder = fullfile(projDir, 'REAP');
        wandellDir = fullfile(destFolder, 'wandell');
        fwProjDir  = fullfile(wandellDir, projName);
        mkdir(destFolder); mkdir(wandellDir); mkdir(fwProjDir); 
        metaData.AnonymizedID = categorical(metaData.AnonymizedID);
        uniqueSubjects=unique(metaData.AnonymizedID);
        for ns=1:length(uniqueSubjects)
            withThisName=metaData(metaData.AnonymizedID == uniqueSubjects(ns) , :);
            nameNum = char(uniqueSubjects(ns));
            nameNum = str2num(nameNum(2:end));
            if nameNum < 50000
                subjectsFolder = fullfile(projDir,'ipcas','dicom','triotim','mmilham','corr_28731');
                sourceSubjDir  = fullfile(subjectsFolder, char(uniqueSubjects(ns)));
            else
                subjectsFolder = fullfile(projDir,'nki','dicom','triotim','mmilham','corr_28731');
                sourceSubjDir  = fullfile(subjectsFolder, char(uniqueSubjects(ns)));
            end 
            if exist(sourceSubjDir, 'dir') > 1
                % Create the uniqueID folder
                destSubjDir = fullfile(fwProjDir, char(uniqueSubjects(ns)));
                % There is no correspondence between the number of rows
                % and the number of folders. Look at how many folders
                % there are

                % FIND BASELINE AND CONVERT TO TEST
                sourceBaselineSessions = dir(fullfile(sourceSubjDir, '*_Baseline'));
                anatSourceSessionDir = [];
                dtiSourceSessionDir  = [];
                for nt=1:length(sourceBaselineSessions)
                    % ANAT
                    anatSourceSessionDirn = dir(fullfile(sourceSubjDir,sourceBaselineSessions(nt).name,'anat_*'));
                    if  ~isempty(anatSourceSessionDirn)
                        if exist(fullfile(sourceSubjDir,sourceBaselineSessions(nt).name,anatSourceSessionDirn(1).name), 'dir') >= 1
                            anatSourceSessionDir = fullfile(sourceSubjDir,sourceBaselineSessions(nt).name,anatSourceSessionDirn(1).name);
                        end
                    end
                   % DTI 
                    dtiSourceSessionDirn = dir(fullfile(sourceSubjDir,sourceBaselineSessions(nt).name,'dti_*'));
                    if  ~isempty(dtiSourceSessionDirn)
                        if exist(fullfile(sourceSubjDir,sourceBaselineSessions(nt).name,dtiSourceSessionDirn(1).name), 'dir') >= 1
                            dtiSourceSessionDir = fullfile(sourceSubjDir,sourceBaselineSessions(nt).name,dtiSourceSessionDirn(1).name);
                        end   
                    end
                end
                if  ~isempty(dtiSourceSessionDir)
                    % Assuming that if there is a dti file, there will be anat
                    % Now we create the folder
                    mkdir(destSubjDir); 
                    % Create session folder
                    destSessDir = fullfile(destSubjDir, destSessionLabels{1}); mkdir(destSessDir);
                    % Create acquisition folders
                    structuralDir = fullfile(destSessDir, 'Structural'); mkdir(structuralDir);
                    diffusionDir = fullfile(destSessDir, 'Diffusion'); mkdir(diffusionDir);
                    % Now do the data copying
                    copyfile(fullfile(anatSourceSessionDir,'anat*'), structuralDir);
                    copyfile(fullfile(dtiSourceSessionDir,'dti*'), diffusionDir);
                    % GO INTO RETEST IF ONLY THERE IS DTI IN TEST
                    % FIND RETEST AND CONVERT TO RETEST
                    % This is an absolute mess, so I am just going to
                    % create RETEST as in HCP
                    sourceRetestSessions = dir(fullfile(sourceSubjDir, '*_Retest*'));

                    anatSourceSessionDirRT = [];
                    dtiSourceSessionDirRT  = [];
                    for nt=1:length(sourceRetestSessions)
                        % ANAT
                        anatSourceSessionDirn = dir(fullfile(sourceSubjDir,sourceRetestSessions(nt).name,'anat_*'));
                        if ~isempty(anatSourceSessionDirn)
                            if exist(fullfile(sourceSubjDir,sourceRetestSessions(nt).name,anatSourceSessionDirn(1).name), 'dir') >= 1
                                anatSourceSessionDirRT = fullfile(sourceSubjDir,sourceRetestSessions(nt).name,anatSourceSessionDirn(1).name);
                            end
                        end
                        % DTI
                        dtiSourceSessionDirn = dir(fullfile(sourceSubjDir,sourceRetestSessions(nt).name,'dti_*'));
                        if ~isempty(dtiSourceSessionDirn)
                            if exist(fullfile(sourceSubjDir,sourceRetestSessions(nt).name,dtiSourceSessionDirn(1).name), 'dir') >= 1
                                dtiSourceSessionDirRT = fullfile(sourceSubjDir,sourceRetestSessions(nt).name,dtiSourceSessionDirn(1).name);
                            end
                        end
                    end
                    if ~isempty(dtiSourceSessionDirRT)
                        % Create session folder
                        destSessDirRT = fullfile(destSubjDir, destSessionLabels{2}); mkdir(destSessDirRT);
                        % Create acquisition folders
                        structuralDirRT = fullfile(destSessDirRT, 'Structural'); mkdir(structuralDirRT);
                        diffusionDirRT  = fullfile(destSessDirRT, 'Diffusion'); mkdir(diffusionDirRT);
                        % Now do the data copying
                        if ~isempty(anatSourceSessionDirRT)
                            copyfile(fullfile(anatSourceSessionDirRT,'anat*'), structuralDirRT);
                        else
                            copyfile(fullfile(anatSourceSessionDir,'anat*'), structuralDirRT);
                        end
                        copyfile(fullfile(dtiSourceSessionDirRT,'dti*'), diffusionDirRT);
                    end
                    % END OF THE RETEST CODE
                    
                    
                    
                end

               
            end    
        end
    case {'BCBL_ILLITERATES'}
        baseDestDir  = '/bcbl/home/public/Gari/ILLITERATE/DATA/up2fw2'; mkdir(baseDestDir);
        groupDestDir = fullfile(baseDestDir, 'wandell'); mkdir(groupDestDir);
        projDestDir  = fullfile(groupDestDir, projName); mkdir(projDestDir);


        baseSrcDir  = '/bcbl/home/public/Gari/ILLITERATE/DATA/dicoms/';
        cd(baseSrcDir); 
        subs = dir('S*');
        cd(projDestDir);
        for ns=3:length(subs)
            subName = subs(ns).name;
            subSrc  = fullfile(baseSrcDir, subName);
            t1Src   = fullfile(subSrc, 'T1w.nii');
            dwiSrc  = fullfile(subSrc, 'DWI.nii');
            bvalSrc = fullfile(subSrc, 'bval');
            bvecSrc = fullfile(subSrc, 'bvec');
            if exist(t1Src,'file') && exist(dwiSrc,'file') && exist(bvalSrc,'file') && exist(bvecSrc,'file')
                
                if strcmp(subName(1:2), 'SC'); 
                    newSubName = subName;
                    subDest = fullfile(projDestDir, subName); mkdir(subDest);
                    sessionDest = fullfile(subDest, 'CONTROL'); 
                    mkdir(sessionDest); 
                end;
                if strcmp(subName(1:2), 'SI'); 
                    newSubName = subName([1,3:end]);
                    subDest = fullfile(projDestDir, newSubName); mkdir(subDest);
                    sessionDest = fullfile(subDest, 'TEST');
                    mkdir(sessionDest); 
                end;
                if strcmp(subName(1:2), 'SN'); 
                    newSubName = subName([1,3:end]);
                    subDest = fullfile(projDestDir, newSubName); mkdir(subDest);
                    sessionDest = fullfile(subDest, 'RETEST'); 
                    mkdir(sessionDest); 
                end;
                
                % Copy Structural
                acquDest = fullfile(sessionDest, 'Structural'); mkdir(acquDest);
                % Xform the T1, otherwise it does not work
                T1wRaw = niftiRead(t1Src);
                [T1w,canXform] = niftiApplyCannonicalXform(T1wRaw);
                % niftiWrite(T1w, fullfile(acquDest, 'T1w.nii.gz')); 
                % La mierda de /public no deja hacer write, escribir en tmp
                % y luego mover con 'f'
                tempDir = '/bcbl/home/home_g-m/glerma/tmp';
                niftiWrite(T1w, fullfile(tempDir, 'T1w.nii.gz'));
                movefile(fullfile(tempDir, 'T1w.nii.gz'), ...
                         fullfile(acquDest, 'T1w.nii.gz'), ...
                         'f'); 
                % Copy Diffusion
                acquDest = fullfile(sessionDest, 'Diffusion');
                gzip(dwiSrc, acquDest)
                movefile(fullfile(acquDest, 'DWI.nii.gz'), ...
                         fullfile(acquDest, 'dwi.nii.gz'), ...
                         'f');
                copyfile(bvalSrc, fullfile(acquDest, 'dwi.bval'), 'f');
                copyfile(bvecSrc, fullfile(acquDest, 'dwi.bvec'), 'f');
            end
        end

    case {'BCBL_MINI'}
    otherwise 
        warning('This project is not implemented yet.')
end