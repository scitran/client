function acquMD = dr_fwObtainAcquMD(st, thisSession, thisAnalysis, collectionName)
%DR_FWOBTAINACQUMD Summary of this function goes here
%   Detailed explanation goes here


% Get info for the project the session belong to
thisProject = st.fw.getProject(thisSession.project);

tmpCollectionID='5d4c9b022d28760046707931';
%{
    Now we need to find the files used in this analysis, and the
    acquisition parameters. Usually this could be solved with the gear
    type, but for example in HCP is not the case, as we have splitted
    the original values into b1000-b2000-b3000. This means that from
    the GEAR we have to go back to the acquisitions files and obtain
    the parameters. 
    What are we interested in? All, but make a list here, since the
    HCP data has no dicom headers...
    - scanAcquSiteName: 'StanfordCNI', 'BCBL', 'HCP'...
    - scanVendorName: 'Siemens', 'GE'...
    - scanModel: 'trio', 'prisma',...
    - scanTeslas: '1.5', '3', '4', '7', ...
    - scanSeqName: 'MPRAGE', 'ME-MPRAGE', 'SPGRE', ...
    - scanbValue: '1000', '2000', '2500', ...
    - scanNumDirs: '30', '60', '96', ...
    - ...
    - ... (if there is a default in FS load it)
    FC: make this into an independent function as well
       - If there is only one file, read all the params
       - If there is more than one, select by the type. 
       - Ideal: same set of params always, if there is none add
         manually of by config/function. e.g. if HCP: obtain from here
%}

% BUG: if I have the id of the input file, I should get its
% parameters right?
% Workaround: find the file parameters using the filename
% FC: make this into a function that will give parameters with use
%     cases and all (so, there will be HCP use case, for example)
% function [acquMD_dt_row] = acquMD_get(thisAnalysis)
if length(thisAnalysis.inputs) < 1
    error(fprintf('No input files for analysis %s, and it was expected', thisAnalysis.label))
end

% Obtain the gear info to know what this analysis should be.
% Depending onthe type of the analysis, we want different AcquMD
% FC: [gearID, thisGear, thisGearName, thisGearVersion] = gearInfoObtainFromAnalysis(thisAnalysis)
gearId            = thisAnalysis.job.gearId;
thisGear          = st.fw.getGear(gearId);
thisGearName      = thisGear.gear.name;
thisGearVersion   = thisGear.gear.version;
% NOTE: we can not use fileInfo = thisAnalysis.inputs{1}.info;
% It returns a copy of the file info, if it has been edited after
% the analysis is run, changes will not be returnes. 
% This is because the file is associated to the analysis.
% We have to find the original file in the session>acquisition and
% read the info from there. 
switch thisGearName
    % Note1: FW now uses dcm2niix, in this process it will read the 
    % dicom headers and independent of the vendor, it will write the 
    % same set of header parameters into the nifti custom info params. 
    % Note2: swithcing is required because if the gear is FS, we will
    % have T1w and maybe T2w and the acqu. parameters will be different
    % from what is found in DWI acquisitions.
    % Note3: HCP data is preprocessed niftis, no dicoms to convert
    % from, so no custom fields. We will need to upload them
    % manually using the function modifyAcquisitionFileInfo()
    case {'afq-pipeline-3', 'afq-pipeline'}
        switch thisProject.label
            case {'HCP_preproc'}
                % FC: create a indep. func. that will: 
                % Task1: read bValue from the bval file, 
                % Task2: read number of directions from bval or bvec 
                % Task3: read the rest of default params from the dwi nifti header
                %        update: bval, bvec and dwi share the same info, it
                %        seems that reading the bval will be enough for
                %        everything.
                % Task4: return everything as a table with 1 row.
                % FC: thisAnalysis.inputs{1}.info does not return the info,
                % create a func that finds the
                % fileName in the session>acquisition. We will do this just
                % fot the DWI file, because the other files we can read. 
                % First, find the bval fileName in the analysis.inputFiles
                bvalFileName = [];
                for naf=1:length(thisAnalysis.inputs)
                    fileName = thisAnalysis.inputs{naf}.name;
                    if strcmp(fileName(length(fileName)-3:end), 'bval') || strcmp(fileName(length(fileName)-4:end), 'bvals')
                        bvalFileName = fileName;
                    end
                end
                % Now find all acqus. in session and all files in acqu, and
                % compare the name
                acqus = st.list('acquisition', idGet(thisSession));
                sameInputFile    = []; % initialize so that we can do isempty() below
                whichIsInThisAcq = [];
                scanNumDirs      = [];
                scanbValue       = [];
                for nacqu=1:length(acqus)
                    inputFiles = st.list('files', idGet(acqus{nacqu}));
                    for nif=1:length(inputFiles)
                        if strcmp(inputFiles{nif}.name, bvalFileName)
                            sameInputFile    = inputFiles{nif};
                            whichIsInThisAcq = acqus{nacqu};
                        end
                    end
                end
                bvalStruct = sameInputFile.info.struct;
                % The reason why we are doing is because
                % thisAnalysis.inputs{1}.info ~= sameInputFile.info
                % if we added or modified custom fields to the file after
                % the analysis was done
                % Read the bval file
                % Read the bValue:
                bval = dlmread(st.fw.downloadFileFromAcquisition(idGet(whichIsInThisAcq), ...
                                    sameInputFile.name, ...
                                    fullfile(stRootPath,'local','tmp',sameInputFile.name)));
            case {'PRATIK'}
                % First search what was the name of the bval used to know if it
                % is a v12 or a v14
                analysis = dr_fwSearchAcquAnalysis(st, thisSession, ...
                                         'analysis', 'Analysis gear: mrtrix3preproc: with defaults.', 'last');   
                if isempty(analysis)
                    fprintf('No analysis found, adding session to the tmpCollection...\n') 
                    dr_fwAddSession2tmpCollection(st, thisSession)
                else
                    bvalName = dr_fwFileName(analysis, 'b0.bval', 'input');
                    if isempty(bvalName)
                        fprintf('No analysis found, adding session to the tmpCollection...\n') 
                        dr_fwAddSession2tmpCollection(st, thisSession)
                    else
                        if strcmp(bvalName, 'GradientTable-GE-v12-55dir+1b0.bval')
                            bvalStruct = st.fw.getProjectFileInfo(thisProject.id, bvalName);
                            bvalStruct = bvalStruct.info.struct;
                            bval = dlmread(st.fw.downloadFileFromProject(thisProject.id, bvalName, ...
                                                fullfile(stRootPath,'local','tmp',bvalName)));
                        elseif strcmp(bvalName, 'GE-v14-55dir+7b0.bval')
                            bvalStruct = st.fw.getProjectFileInfo(thisProject.id, bvalName);
                            bvalStruct = bvalStruct.info.struct;
                            bval = dlmread(st.fw.downloadFileFromProject(thisProject.id, bvalName, ...
                                                fullfile(stRootPath,'local','tmp',bvalName)));
                        end
                    end
                end
            case {'Weston Havens'}
                % The dwi files have information, but they do not have the same
                % fields as in HCP for example. And the bval files have no
                % information associated, this is what I will do: 
                % 1.- Read the info in the dwi file, for both the b1000 and b2000
                % 2.- Take the HCP information template (which is the same as
                %     the latest dcm2niix generates in FW) and edit manually
                %     with the correct information
                % 3.- Write the information in the corresponding bval files
                % 4.- Read and return the information to the main function
                bvalFromLabel = '1000';
                if ~contains(thisAnalysis.label, bvalFromLabel)
                    bvalFromLabel = '2000';
                end
                if ~contains(thisAnalysis.label, bvalFromLabel)
                    warning('b value not found in label, will add to tmpCollection later')
                    bvalFromLabel = 'ThrowAnError';
                end
                
                acqu = dr_fwSearchAcquAnalysis(st,thisSession,'acquisition',bvalFromLabel, 'last');
                if isempty(acqu)
                    fprintf('No analysis found, adding session to the tmpCollection...\n') 
                    dr_fwAddSession2tmpCollection(st, thisSession)
                else
                    bvalName = dr_fwFileName(acqu, 'bval');
                    if isempty(bvalName)
                        fprintf('No analysis found, adding session to the tmpCollection...\n') 
                        dr_fwAddSession2tmpCollection(st, thisSession)
                    else
                        bvalStruct = st.fw.getAcquisitionFileInfo(acqu.id, bvalName);
                        bvalStruct = bvalStruct.info.struct;
                        bval = dlmread(st.fw.downloadFileFromAcquisition(acqu.id, bvalName, ...
                                            fullfile(stRootPath,'local','tmp',bvalName)));
                    end
                end  
            case {'BCBL_ILLITERATES'}
                % The dwi files have information, but they do not have the same
                % fields as in HCP for example. And the bval files have no
                % information associated, this is what I will do: 
                % 1.- Read the info in the dwi file, for both the b1000 and b2000
                % 2.- Take the HCP information template (which is the same as
                %     the latest dcm2niix generates in FW) and edit manually
                %     with the correct information
                % 3.- Write the information in the corresponding bval files
                % 4.- Read and return the information to the main function
                acqu = dr_fwSearchAcquAnalysis(st,thisSession,'acquisition','Diffusion', 'last');
                if isempty(acqu)
                    fprintf('No analysis found, adding session to the tmpCollection...\n') 
                    dr_fwAddSession2tmpCollection(st, thisSession)
                else
                    bvalName = dr_fwFileName(acqu, 'bval');
                    if isempty(bvalName)
                        fprintf('No analysis found, adding session to the tmpCollection...\n') 
                        dr_fwAddSession2tmpCollection(st, thisSession)
                    else
                        bvalStruct = st.fw.getAcquisitionFileInfo(acqu.id, bvalName);
                        bvalStruct = bvalStruct.info.struct;
                        bval = dlmread(st.fw.downloadFileFromAcquisition(acqu.id, bvalName, ...
                                            fullfile(stRootPath,'local','tmp',bvalName)));
                    end
                end                  
            case {'HCP_Depression'}
                % The dwi files have information, but they do not have the same
                % fields as in HCP for example. And the bval files have no
                % information associated, this is what I will do:
                % 1.- Read the info in the dwi file, for both the b1000 and b2000
                % 2.- Take the HCP information template (which is the same as
                %     the latest dcm2niix generates in FW) and edit manually
                %     with the correct information
                % 3.- Write the information in the corresponding bval files
                % 4.- Read and return the information to the main function
                acqu = dr_fwSearchAcquAnalysis(st,thisSession,'acquisition','Diffusion', 'last');
                if isempty(acqu)
                    fprintf('No analysis found, adding session to the tmpCollection...\n') 
                    dr_fwAddSession2tmpCollection(st, thisSession)
                else
                    bvalName = dr_fwFileName(acqu, 'bval');
                    if isempty(bvalName)
                        fprintf('No analysis found, adding session to the tmpCollection...\n') 
                        dr_fwAddSession2tmpCollection(st, thisSession)
                    else
                        bvalStruct = st.fw.getAcquisitionFileInfo(acqu.id, bvalName);
                        bvalStruct = bvalStruct.info.struct;
                        bval = dlmread(st.fw.downloadFileFromAcquisition(acqu.id, bvalName, ...
                                            fullfile(stRootPath,'local','tmp',bvalName)));
                    end
                end  
            case {'BCBL_BERTSO'}
                % The dwi files have information, but they do not have the same
                % fields as in HCP for example. And the bval files have no
                % information associated, this is what I will do: 
                % 1.- Read the info in the dwi file, for both the b1000 and b2000
                % 2.- Take the HCP information template (which is the same as
                %     the latest dcm2niix generates in FW) and edit manually
                %     with the correct information
                % 3.- Write the information in the corresponding bval files
                % 4.- Read and return the information to the main function

                acqu = dr_fwSearchAcquAnalysis(st,thisSession,'acquisition','DWI','last');
                if isempty(acqu)
                    fprintf('No analysis found, adding session to the tmpCollection...\n') 
                    dr_fwAddSession2tmpCollection(st, thisSession)
                else
                    bvalName = dr_fwFileName(acqu, 'bval');
                    if isempty(bvalName)
                        fprintf('No analysis found, adding session to the tmpCollection...\n') 
                        dr_fwAddSession2tmpCollection(st, thisSession)
                    else
                        bvalStruct = st.fw.getAcquisitionFileInfo(acqu.id, bvalName);
                        bvalStruct = bvalStruct.info.struct;
                        bval = dlmread(st.fw.downloadFileFromAcquisition(acqu.id, bvalName, ...
                        fullfile(stRootPath,'local','tmp',bvalName)));
                    end
                end
            case {'HCP-DES'}
                % The dwi files have information, but they do not have the same
                % fields as in HCP for example. And the bval files have no
                % information associated, this is what I will do:
                % 1.- Read the info in the dwi file, for both the b1000 and b2000
                % 2.- Take the HCP information template (which is the same as
                %     the latest dcm2niix generates in FW) and edit manually
                %     with the correct information
                % 3.- Write the information in the corresponding bval files
                % 4.- Read and return the information to the main function
                acqu = dr_fwSearchAcquAnalysis(st,thisSession,'acquisition','DWI', 'last');
                if isempty(acqu)
                    fprintf('No analysis found, adding session to the tmpCollection...\n') 
                    dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                else
                    bvalName = dr_fwFileName(acqu, 'bval');
                    if isempty(bvalName)
                        fprintf('No analysis found, adding session to the tmpCollection...\n') 
                        dr_fwAddSession2tmpCollection(st, thisSession)
                    else
                        bvalStruct = st.fw.getAcquisitionFileInfo(acqu.id, bvalName);
                        bvalStruct = bvalStruct.info.struct;
                        bval = dlmread(st.fw.downloadFileFromAcquisition(acqu.id, bvalName, ...
                                            fullfile(stRootPath,'local','tmp',bvalName)));
                    end
                end  

            otherwise
                error('Project %s not recognized', thisProject.label)
        end
        
        % The function should return a datatable:
        acquMD = struct2table(bvalStruct, 'AsArray', true);
        if isempty(acquMD)
            warning('No acquMD found, added NaN acquMD and added the session to the tmpCollection, so that the info can be updated.')
            tmp    = load(fullfile(stRootPath,'gari','DATA','defaults','acquMD999.mat'));
            acquMD = struct2table(tmp.acquMD999, 'AsArray', true);
            % add session to collection
            % st.fw.addSessionsToCollection(tmpCollectionID, idGet(thisSession])
            % Justin explained that the previous function is not
            % working, he propossed this temporary fix
            nodes = {flywheel.model.CollectionNode('level', 'session', 'id', idGet(thisSession)) };
            contents = flywheel.model.CollectionOperation('operation', 'add', 'nodes', nodes);
            st.fw.modifyCollection(tmpCollectionID, flywheel.model.Collection('contents', contents));
        end

        
        % Here we could include other checks, for example making
        % sure that 0 is 0 and not 0<100, or that 2000 is not
        % 990>1100, but in our case we needed to do that in the
        % previous step before inputing to afq-pipeline. dtiInit is
        % going to fail if there is not a single bValue. We are
        % going to leave it with minimum checks at the moment. 
        bvalzeros   = bval(bval==0);
        bvalnozeros = bval(bval > 100);
        bvalnozeros  = 100 * round(bvalnozeros/100);
        scanDirs    = length(bvalnozeros);
        scanbValue  = unique(bvalnozeros);
        assert(isequal(length(bval), length(bvalnozeros)+length(bvalzeros)), ...
            'bval file: not possible to separate zero and non zero values.')
        if length(scanbValue) > 1
%            error('There are more than 1 bValues in the .bval file.')
        elseif length(scanbValue) == 0
            error('There are no b values in the .bval file.')
        end

        % Add it to the datatable row
        acquMD.scanDirs   = scanDirs;
        acquMD.scanbValue = scanbValue;
        
        
        % Sthg changed in their code, make sure everything is string, no char
        fnames = acquMD.Properties.VariableNames;
        for nb=1:length(fnames)
            fname = fnames{nb};
            if iscell(acquMD.(fname))
                if ischar(acquMD.(fname){:})
                    acquMD.(fname) = string(acquMD.(fname));
                elseif isnumeric(acquMD.(fname){:})
                    acquMD.(fname) = string(fname);  % cell2table(acquMD.(fname));
                else
                    acquMD.(fname) = string(fname);
                end
            else
                if ischar(acquMD.(fname))
                    acquMD.(fname) = string(acquMD.(fname));
                end
            end
        end

    case {'freesurfer'} % look for the real options
        warning('freesurfer acquMD read not yet implemented')
    otherwise
        % If we did not specify the case, throw a warning and read
        % the info on the first file
        warning(fprintf('The gear %s was not specified, the info of the first input file will be used.\n', ...
                        thisGearName))
end
% endFC



end

