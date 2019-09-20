function dt = dr_fwLaunchJobs(serverName, collectionName, gearName, gearVersion)
% .


% Example inputs to make it work
%{

% Select SERVER and COLLECTION

clc; clear all;
serverName     = 'stanfordlabs';
collectionName = 'tmpCollection';
% collectionName = 'ComputationalReproducibility';
% collectionName = 'CompRepCheck';
% collectionName = 'WestonHavens_AFQ_Match-Engage';
% collectionName = 'ILLITERATES';
% collectionName = 'BCBL_BERTSO';
% collectionName = 'HCPTEST';
% collectionName = 'Mareike';


% Select GEAR, VERSION and DEFAULTS
% gearName = 'fslmerge'            ; gearVersion    = '0.1.1';
% gearName = 'freesurfer-recon-all'; gearVersion    = '0.1.4';
% gearName = 'acpc-anat'           ; gearVersion    = '1.0.3';
% gearName = 'mrtrix3preproc'      ; gearVersion    = '1.0.2';
% gearName = 'neuro-detect'        ; gearVersion    = '0.3.1';
% gearName = 'dwi-flip-bvec'       ; gearVersion    = '1.0.0';
% gearName = 'dtiinit'             ; gearVersion    = '0.2.2';
gearName = 'afq-pipeline'        ; gearVersion    = '3.0.7';
gearName = 'afq-pipeline-3'        ; gearVersion    = '3.0.2'; % MAreike

    dr_fwLaunchJobs(serverName, collectionName, gearName, gearVersion)

%}

%% 0.- Connect to the session where the example dicom header json is
st = scitran(serverName);
% st.verify

%% 2.- Connect to the collection, verify it and show the number of sessions for verification
% FC: obtain collection ID from the collection name
collectionID = '';
collections  = st.fw.getAllCollections();
for nc=1:length(collections)
    if strcmp(collections{nc}.label, collectionName)
        collectionID = collections{nc}.id;
    end
end

if isempty(collectionID)
    error(sprintf('Collection %s could not be found on the server %s (verify permissions or the collection name).', collectionName, serverName))
else
    thisCollection        = st.fw.getCollection(collectionID);
    sessionsInCollection  = st.fw.getCollectionSessions(idGet(thisCollection));
    fprintf('There are %i sessions in the collection %s (server %s).\n', length(sessionsInCollection), collectionName, serverName)
end

% This is in stanfordlabs.flywheel.io
% If sthg is not going right for a subject, it will add it here

%% 3.- Config related
% FC: make this to the list.m or search.m as a function
allGears = st.fw.getAllGears();
thisGearId = [];
for nag=1:length(allGears)
    if strcmp(allGears{nag}.gear.name, gearName) & strcmp(allGears{nag}.gear.version, gearVersion)
        thisGearId = allGears{nag}.id;
    end
end
if isempty(thisGearId)
    error(sprintf('Could not find %s (%s) in %s\n', gearName, gearVersion, serverName))
end
% endFC

% Create default configuration for gear
gear = st.fw.getGear(thisGearId);
gearCfg = struct(gear.gear.config);
config = struct;
keys = fieldnames(gearCfg);
for i = 1:numel(keys)
  val = gearCfg.(keys{i});
  if isfield(val, 'default')
    config.(keys{i}) = val.default;
  else
    fprintf('No default value for %s\n', keys{i});
  end
end

% Add the config params. Read the config to see the defaults and edit required ones
% configDefaults = st.fw.getGear(thisGearId).gear.config.struct;
% THIS ARE THE DEFAULT FOR ALL THE PROJECTS
% Usually we will want to change the defaults per every diferent project. 
% Look below
labelStr = '';
switch gearName
    case {'fslmerge'}
        configDefault = config;
        fprintf('No changes to default for  %s\n', gearName);
    case {'freesurfer-recon-all'}
        configDefault = config;
        configDefault.license_email     = 'garikoitz@gmail.com';
        configDefault.license_key       = '*Cgjn1v7PIXnk';
        configDefault.license_number    = '13015';
        configDefault.license_reference = 'FSzCsgR1FSKMs';
    case {'acpc-anat'}
        configDefault = config;
        fprintf('No changes to default for  %s\n', gearName);        
    case {'dwi-flip-bvec'}
        configDefault = config;
        fprintf('No changes to default for  %s\n', gearName);
    case {'mrtrix3preproc'}
        configDefault = config;
    case {'dtiinit'}
        configDefault = config;
        configDefault.eddyCorrect = -1;
    case {'neuro-detect'}
        configDefault = config;
        fprintf('No changes to default for  %s\n', gearName);        
    case {'afq-pipeline','afq-pipeline-3'}
        % This file doesn' have the last values...
        % configParamDefaultsFileName = 'afq-pipeline-config-param-defaults.mat';
        % load(fullfile(afqDimPath,'DATA','FW_datatools', configParamDefaultsFileName))
        % This changes to defaults will affect to all projects
        configDefault                     = config;
        configDefault.ET_numberFibers     = 400000;
        configDefault.life_num_iterations = 10;  % Before 250, 10
        configDefault.ET_runET            = true;
        configDefault.life_runLife        = true;
        configDefault.eddyCorrect         = -1;
        configDefault.maxDist             = 4;
        configDefault.maxLen              = 4;

        configDefault.mrtrix_useACT       = false;
        configDefault.mrtrix_autolmax     = true;
        configDefault.mrtrix_lmax         = 6;
        configDefault.mrtrix_multishell   = true;     
        configDefault.track_faThresh      = 0.05; % 0.2 % 0.05;  % 0.1;  
        configDefault.ET_minlength        = 20;   
        configDefault.ET_maxlength        = 250; 
        configDefault.track_nfibers       = 400000;

        % Add common label for the analysis based on parametrs
        % labelStr = 'AllV03:v3.0.6:10LiFE:min20max250:0.1cutoff:';
        % labelStr = 'min20max250:0.05cutoff:v3.0.2';
        labelStr = 'v.3.0.7:min20max250:0.05cutoff:';
        
        
        % CAREFUL, REMOVE, this is for the 1 subject test
        % configDefault.mrtrix_mrTrixAlgo   = 'SD_Stream';
    otherwise
        error(sprintf('Not recognized gearName %s', gearName))
end


% Now loop over all the sessions, and in our case, over all the bvalues. 

%% 4.- Launch a job for a specific subject
for ns=1:length(sessionsInCollection)
    % Get info for the session
    thisSession = st.fw.getSession(idGet(sessionsInCollection{ns}));
    % Get info for the project the session belong to
    thisProject = st.fw.getProject(thisSession.project);
    fprintf('(%d) Gear %s in session: %s >> %s (Session: %s)\n', ns, gearName, thisProject.label, thisSession.subject.code, thisSession.label)
    switch thisProject.label
        case {'HCP_preproc'}
            fprintf('Launching %s sessions now...\n', ns, thisProject.label)
            if configDefault.mrtrix_multishell
                bvalues = {'MS'};
            else
                bvalues = {'1000', '2000', '3000'};
            end
            for bval=bvalues
                config = configDefault;
                switch gearName
                    case {'neuro-detect'}
                        % Obtain the acquisitionsIDs:
                        acqus = st.list('acquisition', idGet(thisSession));
                        diffacqu = [];
                        for na=1:length(acqus)
                            acqu = st.fw.getAcquisition(idGet(acqus{na}));
                            if strcmp(acqu.label,'Diffusion');diffacqu=acqu;end
                        end
                        % Diffusion files, loop over the bval values              
                        bvecfile = struct('type', 'acquisition','id', idGet(diffacqu), ...
                                          'name', [thisSession.subject.code '_dwi_' bval{:} '.bvec']);
                        bvalfile = struct('type', 'acquisition','id', idGet(diffacqu), ...
                                          'name', [thisSession.subject.code '_dwi_' bval{:} '.bval']);
                        dwifile  = struct('type', 'acquisition','id', idGet(diffacqu), ...
                                          'name', [thisSession.subject.code '_dwi_' bval{:} '.nii.gz']);              
                        inputs   = struct('bvec'      , bvecfile, ...
                                          'bval'      , bvalfile, ...
                                          'dwi'       , dwifile);
                        % create the job with all the involved files in a struct
                        thisJob = struct('gear_id', thisGearId, ...
                                         'inputs', inputs, ...
                                         'config', config);
                        body    = struct('label', [labelStr 'neuro-detect OK bVal: ' bval{:} ], ...
                                         'job'  , thisJob); 
                    case {'afq-pipeline','afq-pipeline-3'}
                        % Edit the config defaults specific to this project
                            config.dwOutMm_1           = 1.25;
                            config.dwOutMm_2           = 1.25;
                            config.dwOutMm_3           = 1.25;
                        % Create the body
                        fprintf('   ... bValue: %s\n', bval{:})
                        % Obtain the required acquisitions
                        stracqu  = dr_fwSearchAcquAnalysis(st, thisSession, ...
                                             'acquisition','Structural','last');
                        diffacqu = dr_fwSearchAcquAnalysis(st, thisSession, ...
                                             'acquisition', 'Diffusion','last');
                                                % Check if any of those is empty, if not, continue
                        if isempty(stracqu) || isempty(diffacqu) 
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Obtain the file names. In some cases if we
                            % prepared the data we will know all names will be
                            % the same, but it is not true for all projects...
                            % The following function will check if the file name
                            % contains the string below, and it will return
                            % either an empty string or the name. If more than
                            % one are encountered, the last one will be
                            % returned.
                            % IT is unnecessary for HCP, as we pass the whole name
                            T1wFile       = dr_fwFileName(stracqu, 'T1w_acpc_dc_restore_1.25.nii.gz');
                            aparcasegFile = dr_fwFileName(stracqu, 'aparc+aseg');
                            % I should make sure that there always will be an
                            % apar+aseg, but just to be sure...
                            if isempty(aparcasegFile); aparcasegFile = T1wFile; end
                            % Here separate the bValues
                            if strcmp(bval{:},'MS'); bvalStr = 'dwi';
                            else                     bvalStr = ['dwi_' bval{:}];
                            end
                            bvecfile      = dr_fwFileName(diffacqu, [bvalStr '.bvec']);
                            bvalfile      = dr_fwFileName(diffacqu, [bvalStr '.bval']);
                            dwifile       = dr_fwFileName(diffacqu, [bvalStr '.nii.gz']);
                            
                            % Create the inputs struct of structs for FW
                            inputs=struct(...
                                'anatomical',struct('type','acquisition','id',stracqu.id ,'name',T1wFile), ...
                                'aparcaseg' ,struct('type','acquisition','id',stracqu.id ,'name',aparcasegFile), ...   
                                'bvec'      ,struct('type','acquisition','id',diffacqu.id,'name',bvecfile), ...
                                'bval'      ,struct('type','acquisition','id',diffacqu.id,'name',bvalfile), ...
                                'dwi'       ,struct('type','acquisition','id',diffacqu.id,'name',dwifile));

                            % create the job with all the involved files in a struct
                            thisJob = struct('gearId', thisGearId, ...
                                             'inputs', inputs, ...
                                             'config', config);
                            body    = struct('label', [labelStr 'Analysis ' gearName '  bVal: ' bval{:} ], ...
                                             'job'  , thisJob);      
                            % Launch the job
                            st.fw.addSessionAnalysis(idGet(thisSession), body);
                        end
                    otherwise
                        disp(fprintf('No changes for project %s and gear  %s\n', thisProject.label, gearName))
                end
            end
        case {'HCP_Depression'}
            fprintf('Launching %s sessions now...\n', ns, thisProject.label)
            if configDefault.mrtrix_multishell
                bvalues = {'MS'};
            else
                error('HCP_Depression is not ready for independent shell analysis')
            end
            for bval=bvalues    % ;bval;end
                config = configDefault;
                switch gearName
                    case {'neuro-detect'}
                        % Obtain the acquisitionsIDs:
                        acqus = st.list('acquisition', idGet(thisSession));
                        diffacqu = [];
                        for na=1:length(acqus)
                            acqu = st.fw.getAcquisition(idGet(acqus{na}));
                            if strcmp(acqu.label,'Diffusion');diffacqu=acqu;end
                        end
                        % Diffusion files, loop over the bval values              
                        bvecfile = struct('type', 'acquisition','id', idGet(diffacqu), ...
                                          'name', [thisSession.subject.code '_dwi_' bval{:} '.bvec']);
                        bvalfile = struct('type', 'acquisition','id', idGet(diffacqu), ...
                                          'name', [thisSession.subject.code '_dwi_' bval{:} '.bval']);
                        dwifile  = struct('type', 'acquisition','id', idGet(diffacqu), ...
                                          'name', [thisSession.subject.code '_dwi_' bval{:} '.nii.gz']);              
                        inputs   = struct('bvec'      , bvecfile, ...
                                          'bval'      , bvalfile, ...
                                          'dwi'       , dwifile);
                        % create the job with all the involved files in a struct
                        thisJob = struct('gear_id', thisGearId, ...
                                         'inputs', inputs, ...
                                         'config', config);
                        body    = struct('label', [labelStr 'neuro-detect OK bVal: ' bval{:} ], ...
                                         'job'  , thisJob); 
                    case {'afq-pipeline','afq-pipeline-3'}
                        % Edit the config defaults specific to this project
                            config.dwOutMm_1           = 1.5;
                            config.dwOutMm_2           = 1.5;
                            config.dwOutMm_3           = 1.5;
                        % Create the body
                        fprintf('   ... bValue: %s\n', bval{:})
                        % Obtain the required acquisitions
                        stracqu  = dr_fwSearchAcquAnalysis(st, thisSession, ...
                                             'acquisition','Structural','last');
                        aparcAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, ...
                                             'acquisition','Structural','last');
                        diffacqu = dr_fwSearchAcquAnalysis(st, thisSession, ...
                                             'acquisition', 'Diffusion','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(stracqu) || isempty(diffacqu) 
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Obtain the file names. In some cases if we
                            % prepared the data we will know all names will be
                            % the same, but it is not true for all projects...
                            % The following function will check if the file name
                            % contains the string below, and it will return
                            % either an empty string or the name. If more than
                            % one are encountered, the last one will be
                            % returned.
                            % IT is unnecessary for HCP, as we pass the whole name
                            T1wFile       = dr_fwFileName(stracqu, 'T1w');
                            aparcasegFile = dr_fwFileName(aparcAcqu, 'aparc+aseg');
                            % I should make sure that there always will be an
                            % apar+aseg, but just to be sure...
                            if isempty(aparcasegFile); aparcasegFile = T1wFile; end
                            % Here separate the bValues
                            if strcmp(bval{:},'MS'); bvalStr = '';
                            else                     bvalStr = ['dwi_' bval{:}];
                            end
                            bvecfile      = dr_fwFileName(diffacqu, [bvalStr '.bvec']);
                            bvalfile      = dr_fwFileName(diffacqu, [bvalStr '.bval']);
                            dwifile       = dr_fwFileName(diffacqu, [bvalStr '.nii.gz']);
                            
                            % Create the inputs struct of structs for FW
                            inputs=struct(...
                                'anatomical',struct('type','acquisition','id',stracqu.id ,'name',T1wFile), ...
                                'aparcaseg' ,struct('type','acquisition','id',aparcAcqu.id ,'name',aparcasegFile), ...   
                                'bvec'      ,struct('type','acquisition','id',diffacqu.id,'name',bvecfile), ...
                                'bval'      ,struct('type','acquisition','id',diffacqu.id,'name',bvalfile), ...
                                'dwi'       ,struct('type','acquisition','id',diffacqu.id,'name',dwifile));

                            % create the job with all the involved files in a struct
                            thisJob = struct('gearId', thisGearId, ...
                                             'inputs', inputs, ...
                                             'config', config);
                            body    = struct('label', [labelStr 'Analysis ' gearName '_bVal: ' bval{:} ], ...
                                             'job'  , thisJob);      
                            % Launch the job
                            st.fw.addSessionAnalysis(idGet(thisSession), body);
                        end
                    otherwise
                        disp(fprintf('No changes for project %s and gear  %s\n', thisProject.label, gearName))
                end
            end
        case {'BCBL_BERTSO'}
                % Edit the config defaults specific to this project
                config = configDefault;
                switch gearName
                    case {'acpc-anat'}
                        % Edit the config defaults specific to this project
                        % No changes to the defaults
                        % And now create the body for the analysis
                        % Obtain the acquisitionsIDs:
                        anatAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'Structural','last');
                        if isempty(anatAcqu)
                            fprintf('No acquisition found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            anatomicalName  = dr_fwFileName(anatAcqu, 'T1w.nii.gz');
                            % Introduce check that if any of those is empty, add
                            % the subject to the tmpCollection
                            if isempty(anatomicalName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('anatomical'  , struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatomicalName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                 'inputs', inputs, ...
                                                 'config', config);
                                % Launch the job
                                jobId = st.fw.addJob(thisJob);  
                            end
                        end
                    case {'mrtrix3preproc'}
                        % Edit the config defaults specific to this project
                        config.acpc = true;
                        % And now create the body for the analysis
                        T1wAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'T1w','last');
                        % Obtain the diffusion ID:
                        diffAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'DWI','last');
                        % Check if any of those is empty, if not, continue
                        if (isempty(diffAcqu) || isempty(T1wAcqu))
                            fprintf('Diffusion Acquisition missing, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            T1wName   = dr_fwFileName(T1wAcqu, 'rawavg.nii.gz');  %'T1w.nii.gz'); 
                            dwiName   = dr_fwFileName(diffAcqu, '.nii.gz'); 
                            bvecName  = dr_fwFileName(diffAcqu, '.bvec'); 
                            bvalName  = dr_fwFileName(diffAcqu, '.bval'); 
                            % Check if we have the file(s) and continue
                            if (isempty(T1wName)  || isempty(dwiName)  || isempty(bvecName) || isempty(bvalName)) 
                                fprintf('At least one file missing, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('ANAT'  , struct('type', 'acquisition','id', idGet(T1wAcqu),  'name', T1wName), ...
                                                  'BVEC'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', bvecName), ...
                                                  'BVAL'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', bvalName), ...
                                                  'DIFF'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', dwiName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr gearName ':' gearVersion ' analysis'], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end

                        end                                               
                    case {'dwi-flip-bvec'}
                        config.xFlip = true;
                        % Find the bvec file inside the result of the analysis
                        bvecAnalysis  = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'v02bmrtrix3preproc','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(bvecAnalysis)
                            fprintf('No analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            bvecName   = dr_fwFileName(bvecAnalysis, '.bvecs');
                            % Check if we have the file(s) and continue
                            if isempty(bvecName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs = struct('bvec' , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName));
                                
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                % Launch the job
                                % jobId = st.fw.addJob(thisJob);
                                % If the job is launched as a utility gear it will
                                % overwrite the output of the analysis. Launch
                                % it as an analysis gear.
                                % create the job with all the involved files in a struct
                                body    = struct('label', [labelStr 'flipX gear: ' gearName], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end 
                        end
                    case {'neuro-detect'}
                        preprocAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        % bvecAnalysis    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipY','last');  
                        % Check if any of those is empty, if not, continue
                        if isempty(preprocAnalysis) %  || isempty(bvecAnalysis)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % bvecName = dr_fwFileName(bvecAnalysis, '.bvecs'); % 
                            bvecName      = dr_fwFileName(preprocAnalysis, '.bvecs');
                            bvalName      = dr_fwFileName(preprocAnalysis, '.bvals');
                            diffusionName = dr_fwFileName(preprocAnalysis, '.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('bvec'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvecName), ...% 'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName), ... % 
                                                  'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvalName), ...
                                                  'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', diffusionName));

                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr 'neuro-detect KO'], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end
                        end                                                                        
                    case {'afq-pipeline','afq-pipeline-3'}
                        % Edit the config defaults specific to this project
                        fprintf('Changing defaults for project %s and gear %s\n', thisProject.label, gearName);
                        % config.rotateBvecsWithCanXform = 1; % Philips requires to be onee
                        % config.phaseEncodeDir          = 2; % A >> P = 2, In Philips (Fold-Over) = Siemens (Phase-Encoding)
                        % Edit the config defaults specific to this project
                        config.dwOutMm_1               =  1.8; % This data is 1.8 x 1.8 x 1.8
                        config.dwOutMm_2               =  1.8;
                        config.dwOutMm_3               =  1.8;
                        config.rotateBvecsWithCanXform =  1; 
                        
                        % fsAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'freesurfer-recon-all:0.1.4 analysis','last');
                        % It is not finding the file!!!!!!! Let's look in the acqu
                        anatAcqu        = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'T1w','last');
                        preprocAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'v02bmrtrix3preproc','last');
                        bvecAnalysis    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'v02bflipX','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(anatAcqu) || isempty(preprocAnalysis) || isempty(bvecAnalysis)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            % anatName          = dr_fwFileName(fsAnalysis, 'T1.nii.gz');
                            % dtiInit is failing when we use the output of FS
                            % pipeline, so we use the acpc-anat for now
                            % Find the file, it can have several names
                            anatName   = dr_fwFileName(anatAcqu, 'T1w.nii.gz');
                            aparcasegName = dr_fwFileName(anatAcqu, 'aparcaseg.nii.gz');
                            bvecName      = dr_fwFileName(bvecAnalysis, '.bvecs');
                            bvalName      = dr_fwFileName(preprocAnalysis, '.bvals');
                            diffusionName = dr_fwFileName(preprocAnalysis, 'dwi.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(anatName) || isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('anatomical', struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatName), ...
                                                  'aparcaseg' ,struct('type','acquisition','id',anatAcqu.id ,'name',aparcasegName), ...   
                                                      'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName), ...
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvalName), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', diffusionName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr 'X flipped Allv02b: Analysis ' gearName], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end
                        end                        
                    otherwise
                        disp(fprintf('No changes for project %s and gear  %s\n', thisProject.label, gearName))
                end           
        case {'BCBL_ILLITERATES'}
                % Edit the config defaults specific to this project
                config = configDefault;
                switch gearName
                    case {'acpc-anat'}
                        % Edit the config defaults specific to this project
                        % No changes to the defaults
                        % And now create the body for the analysis
                        % Obtain the acquisitionsIDs:
                        anatAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'Structural','last');
                        if isempty(anatAcqu)
                            fprintf('No acquisition found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            anatomicalName  = dr_fwFileName(anatAcqu, 'T1w.nii.gz');
                            % Introduce check that if any of those is empty, add
                            % the subject to the tmpCollection
                            if isempty(anatomicalName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('anatomical'  , struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatomicalName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                 'inputs', inputs, ...
                                                 'config', config);
                                % Launch the job
                                jobId = st.fw.addJob(thisJob);  
                            end
                        end
                    case {'mrtrix3preproc'}
                        % Edit the config defaults specific to this project
                        % And now create the body for the analysis
                        % Obtain the diffusion ID:
                        diffAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'Diffusion','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(diffAcqu)
                            fprintf('Diffusion Acquisition missing, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            dwiName   = dr_fwFileName(diffAcqu, '.nii.gz'); 
                            bvecName  = dr_fwFileName(diffAcqu, '.bvec'); 
                            bvalName  = dr_fwFileName(diffAcqu, '.bval'); 
                            % Check if we have the file(s) and continue
                            if (isempty(dwiName)  || isempty(bvecName) || isempty(bvalName)) 
                                fprintf('At least one file missing, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('BVEC'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', bvecName), ...
                                                  'BVAL'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', bvalName), ...
                                                  'DIFF'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', dwiName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr gearName ':' gearVersion ' analysis'], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end

                        end                                               
                    case {'dwi-flip-bvec'}
                        config.yFlip = true;
                        % Find the bvec file inside the result of the analysis
                        bvecAnalysis  = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(bvecAnalysis)
                            fprintf('No analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            bvecName   = dr_fwFileName(bvecAnalysis, 'dwi.bvecs');
                            % Check if we have the file(s) and continue
                            if isempty(bvecName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs = struct('bvec' , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName));
                                
                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                % Launch the job
                                % jobId = st.fw.addJob(thisJob);
                                % If the job is launched as a utility gear it will
                                % overwrite the output of the analysis. Launch
                                % it as an analysis gear.
                                % create the job with all the involved files in a struct
                                body    = struct('label', [labelStr 'flipY gear: ' gearName], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end 
                        end
                    case {'neuro-detect'}
                        preprocAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        % bvecAnalysis    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipY','last');  
                        % Check if any of those is empty, if not, continue
                        if isempty(preprocAnalysis) %  || isempty(bvecAnalysis)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % bvecName = dr_fwFileName(bvecAnalysis, '.bvecs'); % 
                            bvecName      = dr_fwFileName(preprocAnalysis, '.bvecs');
                            bvalName      = dr_fwFileName(preprocAnalysis, '.bvals');
                            diffusionName = dr_fwFileName(preprocAnalysis, '.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('bvec'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvecName), ...% 'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName), ... % 
                                                  'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvalName), ...
                                                  'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', diffusionName));

                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr 'neuro-detect KO'], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end
                        end                                                                        
                    case {'afq-pipeline','afq-pipeline-3'}
                        % Edit the config defaults specific to this project
                        fprintf('Changing defaults for project %s and gear %s\n', thisProject.label, gearName);
                        % config.rotateBvecsWithCanXform = 1; % Philips requires to be onee
                        % config.phaseEncodeDir          = 2; % A >> P = 2, In Philips (Fold-Over) = Siemens (Phase-Encoding)
                        % Edit the config defaults specific to this project
                        config.dwOutMm_1               =  2; % This data is 1.8 x 1.8 x 1.8
                        config.dwOutMm_2               =  2;
                        config.dwOutMm_3               =  2;
                        config.rotateBvecsWithCanXform =  1; 
                        
                        % fsAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'freesurfer-recon-all:0.1.4 analysis','last');
                        % It is not finding the file!!!!!!! Let's look in the acqu
                        anatAcqu        = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'Structural','last');
                        preprocAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        bvecAnalysis    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipY','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(anatAcqu) || isempty(preprocAnalysis) || isempty(bvecAnalysis)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            % anatName          = dr_fwFileName(fsAnalysis, 'T1.nii.gz');
                            % dtiInit is failing when we use the output of FS
                            % pipeline, so we use the acpc-anat for now
                            % Find the file, it can have several names
                            anatName   = dr_fwFileName(anatAcqu, 'autoMNI.nii.gz');
                            
                            bvecName      = dr_fwFileName(bvecAnalysis, '.bvecs');
                            bvalName      = dr_fwFileName(preprocAnalysis, '.bvals');
                            diffusionName = dr_fwFileName(preprocAnalysis, 'dwi.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(anatName) || isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('anatomical', struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatName), ...
                                                      'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName), ...
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvalName), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', diffusionName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr 'Y flipped Allv01: Analysis ' gearName], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end
                        end                        
                    otherwise
                        disp(fprintf('No changes for project %s and gear  %s\n', thisProject.label, gearName))
                end
        case {'CoRR'}
                % Edit the config defaults specific to this project
                config = configDefault;
                switch gearName
                    case {'acpc-anat'}
                        % Edit the config defaults specific to this project
                        % No changes to the defaults
                        % And now create the body for the analysis
                        % Obtain the acquisitionsIDs:
                        anatAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'Structural','last');
                        if isempty(anatAcqu)
                            fprintf('No acquisition found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            anatomicalName  = dr_fwFileName(anatAcqu, 'anat.nii.gz');
                            % Introduce check that if any of those is empty, add
                            % the subject to the tmpCollection
                            if isempty(anatomicalName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('anatomical'  , struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatomicalName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                 'inputs', inputs, ...
                                                 'config', config);
                                % Launch the job
                                jobId = st.fw.addJob(thisJob);  
                            end
                        end
                    case {'mrtrix3preproc'}
                        % Edit the config defaults specific to this project
                        % And now create the body for the analysis
                        % Obtain the diffusion ID:
                        diffAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'Diffusion','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(diffAcqu)
                            fprintf('Diffusion Acquisition missing, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            dwiName   = dr_fwFileName(diffAcqu, '.nii.gz'); 
                            bvecName  = dr_fwFileName(diffAcqu, '.bvec'); 
                            bvalName  = dr_fwFileName(diffAcqu, '.bval'); 
                            % Check if we have the file(s) and continue
                            if (isempty(dwiName)  || isempty(bvecName) || isempty(bvalName)) 
                                fprintf('At least one file missing, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('BVEC'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', bvecName), ...
                                                  'BVAL'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', bvalName), ...
                                                  'DIFF'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', dwiName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr gearName ':' gearVersion ' analysis'], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end

                        end                                               
                    case {'dwi-flip-bvec'}
                        config.xFlip = true;
                        % Find the bvec file inside the result of the analysis
                        bvecAnalysis  = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(bvecAnalysis)
                            fprintf('No analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            bvecName   = dr_fwFileName(bvecAnalysis, 'dwi.bvecs');
                            % Check if we have the file(s) and continue
                            if isempty(bvecName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs = struct('bvec' , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName));
                                
                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                % Launch the job
                                % jobId = st.fw.addJob(thisJob);
                                % If the job is launched as a utility gear it will
                                % overwrite the output of the analysis. Launch
                                % it as an analysis gear.
                                % create the job with all the involved files in a struct
                                body    = struct('label', [labelStr 'flipX gear: ' gearName], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end 
                        end
                    case {'neuro-detect'}
                        preprocAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        % bvecAnalysis    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(preprocAnalysis) % || isempty(bvecAnalysis) 
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % bvecName      = dr_fwFileName(bvecAnalysis, '.bvecs'); % 
                            bvecName      = dr_fwFileName(preprocAnalysis, '.bvecs');
                            bvalName      = dr_fwFileName(preprocAnalysis, '.bvals');
                            diffusionName = dr_fwFileName(preprocAnalysis, '.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('bvec'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvecName), ...% 'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName), ... % 
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvalName), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', diffusionName));

                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr 'neuro-detect OK'], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end
                        end                                                
                    case {'afq-pipeline','afq-pipeline-3'}
                        % Edit the config defaults specific to this project
                        fprintf('Changing defaults for project %s and gear %s\n', thisProject.label, gearName);
                        % config.rotateBvecsWithCanXform = 1; % Philips requires to be onee
                        % config.phaseEncodeDir          = 2; % A >> P = 2, In Philips (Fold-Over) = Siemens (Phase-Encoding)
                        % Edit the config defaults specific to this project
                        config.dwOutMm_1               =  2; % This data is 1.8 x 1.8 x 1.8
                        config.dwOutMm_2               =  2;
                        config.dwOutMm_3               =  2;
                        config.rotateBvecsWithCanXform =  1; 
                        
                        % fsAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'freesurfer-recon-all:0.1.4 analysis','last');
                        % It is not finding the file!!!!!!! Let's look in the acqu
                        anatAcqu        = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'Structural','last');
                        preprocAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        bvecAnalysis    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(anatAcqu) || isempty(preprocAnalysis) || isempty(bvecAnalysis)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            % anatName          = dr_fwFileName(fsAnalysis, 'T1.nii.gz');
                            % dtiInit is failing when we use the output of FS
                            % pipeline, so we use the acpc-anat for now
                            % Find the file, it can have several names
                            anatName   = dr_fwFileName(anatAcqu, 'autoMNI.nii.gz');
                            
                            bvecName      = dr_fwFileName(bvecAnalysis, '.bvecs');
                            bvalName      = dr_fwFileName(preprocAnalysis, '.bvals');
                            diffusionName = dr_fwFileName(preprocAnalysis, 'dwi.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(anatName) || isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('anatomical', struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatName), ...
                                                      'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName), ...
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvalName), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', diffusionName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr 'X flipped Allv01: Analysis ' gearName], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end
                        end                        
                    otherwise
                        disp(fprintf('No changes for project %s and gear  %s\n', thisProject.label, gearName))
                end                
        case {'networks_mrtrix3'}
                % Edit the config defaults specific to this project
                config = configDefault;
                switch gearName
                    case {'acpc-anat'}
                        % Edit the config defaults specific to this project
                        % No changes to the defaults
                        % And now create the body for the analysis
                        % Obtain the acquisitionsIDs:
                        anatAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'Structural','last');
                        if isempty(anatAcqu)
                            fprintf('No acquisition found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            anatomicalName  = dr_fwFileName(anatAcqu, 'anat.nii.gz');
                            % Introduce check that if any of those is empty, add
                            % the subject to the tmpCollection
                            if isempty(anatomicalName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('anatomical'  , struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatomicalName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                 'inputs', inputs, ...
                                                 'config', config);
                                % Launch the job
                                jobId = st.fw.addJob(thisJob);  
                            end
                        end
                    case {'mrtrix3preproc'}
                        % Edit the config defaults specific to this project
                        % And now create the body for the analysis
                        % Obtain the diffusion ID:
                        diffAcqu  = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'dMRI','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(diffAcqu)
                            fprintf('Diffusion Acquisition missing, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            dwiName   = dr_fwFileName(diffAcqu, '.nii.gz'); 
                            bvecName  = dr_fwFileName(diffAcqu, '.bvec'); 
                            bvalName  = dr_fwFileName(diffAcqu, '.bval'); 
                            % Check if we have the file(s) and continue
                            if (isempty(dwiName)  || isempty(bvecName) || isempty(bvalName)) 
                                fprintf('At least one file missing, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('BVEC'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', bvecName), ...
                                                  'BVAL'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', bvalName), ...
                                                  'DIFF'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', dwiName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr gearName ':' gearVersion ' analysis'], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end

                        end                                               
                    case {'dwi-flip-bvec'}
                        config.xFlip = true;
                        % Find the bvec file inside the result of the analysis
                        bvecAnalysis  = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(bvecAnalysis)
                            fprintf('No analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            bvecName   = dr_fwFileName(bvecAnalysis, 'dwi.bvecs');
                            % Check if we have the file(s) and continue
                            if isempty(bvecName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs = struct('bvec' , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName));
                                
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                % Launch the job
                                % jobId = st.fw.addJob(thisJob);
                                % If the job is launched as a utility gear it will
                                % overwrite the output of the analysis. Launch
                                % it as an analysis gear.
                                % create the job with all the involved files in a struct
                                body    = struct('label', [labelStr 'flipX gear: ' gearName], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end 
                        end
                    case {'neuro-detect'}
                        preprocAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        % bvecAnalysis    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(preprocAnalysis) % || isempty(bvecAnalysis) 
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % bvecName      = dr_fwFileName(bvecAnalysis, '.bvecs'); % 
                            bvecName      = dr_fwFileName(preprocAnalysis, 'dwi.bvecs');
                            bvalName      = dr_fwFileName(preprocAnalysis, 'dwi.bvals');
                            diffusionName = dr_fwFileName(preprocAnalysis, 'dwi.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('bvec'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvecName), ...% 'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName), ... % 
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvalName), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', diffusionName));

                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr 'neuro-detect OK'], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end
                        end                                                
                    case {'afq-pipeline','afq-pipeline-3'}
                        % Edit the config defaults specific to this project
                        fprintf('Changing defaults for project %s and gear %s\n', thisProject.label, gearName);
                        % config.rotateBvecsWithCanXform = 1; % Philips requires to be onee
                        % config.phaseEncodeDir          = 2; % A >> P = 2, In Philips (Fold-Over) = Siemens (Phase-Encoding)
                        % Edit the config defaults specific to this project
                        config.dwOutMm_1               =  2;
                        config.dwOutMm_2               =  2;
                        config.dwOutMm_3               =  2;
                        config.rotateBvecsWithCanXform =  1; 
                        config.eddyCorrect             =  -1; 
                        config.ET_numberFibers         = 500000;
                        config.mrtrix_useACT           = true;
                        config.mrtrix_autolmax         = true;
                        
                        
                        % fsAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'freesurfer-recon-all:0.1.4 analysis','last');
                        % It is not finding the file!!!!!!! Let's look in the acqu
                        anatAcqu        = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 't1','last');
                        preprocAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrtrix3preproc','last');
                        bvecAnalysis    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(anatAcqu) || isempty(preprocAnalysis) || isempty(bvecAnalysis)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            % anatName          = dr_fwFileName(fsAnalysis, 'T1.nii.gz');
                            % dtiInit is failing when we use the output of FS
                            % pipeline, so we use the acpc-anat for now
                            % Find the file, it can have several names
                            anatName      = dr_fwFileName(anatAcqu, 't1.nii.gz');
                            aparcasegName = dr_fwFileName(anatAcqu, 'aparc+aseg.nii.gz');
                            
                            bvecName      = dr_fwFileName(bvecAnalysis, '.bvecs');
                            bvalName      = dr_fwFileName(preprocAnalysis, 'dwi.bvals');
                            diffusionName = dr_fwFileName(preprocAnalysis, 'dwi.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(anatName) || isempty(diffusionName) || isempty(bvecName) || isempty(bvalName) || isempty(aparcasegName)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('anatomical', struct('type', 'acquisition','id', idGet(anatAcqu)       , 'name', anatName     ), ...
                                                  'aparcaseg' , struct('type', 'acquisition','id', idGet(anatAcqu)       , 'name', aparcasegName), ...  
                                                  'bvec'      , struct('type', 'analysis'   ,'id', idGet(bvecAnalysis)   , 'name', bvecName     ), ...
                                                  'bval'      , struct('type', 'analysis'   ,'id', idGet(preprocAnalysis), 'name', bvalName     ), ...
                                                  'dwi'       , struct('type', 'analysis'   ,'id', idGet(preprocAnalysis), 'name', diffusionName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr 'ET:noACT:LiFE 2.5M: X flipped: Analysis ' gearName ':' gearVersion], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end
                        end                        
                    otherwise
                        disp(fprintf('No changes for project %s and gear  %s\n', thisProject.label, gearName))
                end                                
        case {'PRATIK'}       
                % Edit the config defaults specific to this project
                config = configDefault;
                switch gearName
                    case {'fslmerge'}
                        % Edit the config defaults specific to this project
                        % No changes to the defaults
                        % And now create the body for the analysis
                        % Obtain the acquisitionsIDs:
                        acqus = st.list('acquisition', idGet(thisSession));
                        %%%%%%%%%%% EDIT %%%%%%%%%%%%%
                        pratikStep1 = false;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if pratikStep1
                            for na=1:length(acqus)
                                acqu = st.fw.getAcquisition(idGet(acqus{na}));
                                if strcmp(acqu.label,'hardi553-b0+13/55'); diff1of4 = acqu; end
                                if strcmp(acqu.label,'hardi554-14/55');    diff2of4 = acqu; end
                                if strcmp(acqu.label,'hardi555-14/55');    diff3of4 = acqu; end
                                if strcmp(acqu.label,'hardi556-14/55');    diff4of4 = acqu; end
                            end
                            % JOB1: Add a struct with input file(s). These are FileReference objects, which are in
                            bvec1Name  = dr_fwFileName(diff1of4, '1001.bvec');  % Works with contains, do not use *
                            bval1Name  = dr_fwFileName(diff1of4, '1001.bval');
                            nifti1Name = dr_fwFileName(diff1of4, '1001.nii.gz');
                            bvec2Name  = dr_fwFileName(diff2of4, '1001.bvec');
                            bval2Name  = dr_fwFileName(diff2of4, '1001.bval');
                            nifti2Name = dr_fwFileName(diff2of4, '1001.nii.gz');
                            % Introduce check that if any of those is empty, add
                            % the subject to the tmpCollection
                            inputs   = struct('BVEC_1'  , struct('type', 'acquisition','id', idGet(diff1of4), 'name', bvec1Name), ...
                                              'BVAL_1'  , struct('type', 'acquisition','id', idGet(diff1of4),'name', bval1Name), ...
                                              'NIFTI_1' , struct('type', 'acquisition','id', idGet(diff1of4),'name', nifti1Name), ...
                                              'BVEC_2'  , struct('type', 'acquisition','id', idGet(diff2of4), 'name', bvec2Name), ...
                                              'BVAL_2'  , struct('type', 'acquisition','id', idGet(diff2of4),'name', bval2Name), ...
                                              'NIFTI_2' , struct('type', 'acquisition','id', idGet(diff2of4),'name', nifti2Name));
                            % create the job with all the involved files in a struct
                            thisJob = struct('gear_id', thisGearId, ...
                                             'inputs', inputs, ...
                                             'config', config);
                            body1    = struct('label', [labelStr 'Analysis first half ' gearName], ...
                                             'job'  , thisJob);                         
                            
                            % JOB2: Add a struct with input file(s). These are FileReference objects, which are in
                            bvec1Name  = dr_fwFileName(diff3of4, '1001.bvec');  % Works with contains, do not use *
                            bval1Name  = dr_fwFileName(diff3of4, '1001.bval');
                            nifti1Name = dr_fwFileName(diff3of4, '1001.nii.gz');
                            bvec2Name  = dr_fwFileName(diff4of4, '1001.bvec');
                            bval2Name  = dr_fwFileName(diff4of4, '1001.bval');
                            nifti2Name = dr_fwFileName(diff4of4, '1001.nii.gz');
                            inputs   = struct('BVEC_1'  , struct('type', 'acquisition','id', idGet(diff3of4), 'name', bvec1Name), ...
                                              'BVAL_1'  , struct('type', 'acquisition','id', idGet(diff3of4),'name', bval1Name), ...
                                              'NIFTI_1' , struct('type', 'acquisition','id', idGet(diff3of4),'name', nifti1Name), ...
                                              'BVEC_2'  , struct('type', 'acquisition','id', idGet(diff4of4), 'name', bvec2Name), ...
                                              'BVAL_2'  , struct('type', 'acquisition','id', idGet(diff4of4),'name', bval2Name), ...
                                              'NIFTI_2' , struct('type', 'acquisition','id', idGet(diff4of4),'name', nifti2Name));
                            % create the job with all the involved files in a struct
                            thisJob = struct('gear_id', thisGearId, ...
                                             'inputs', inputs, ...
                                             'config', config);
                            body2    = struct('label', [labelStr 'Analysis second half ' gearName], ...
                                             'job'  , thisJob);         
                                         
                                         
                            % Launch the jobs
                            st.fw.addSessionAnalysis(idGet(thisSession), body1);
                            st.fw.addSessionAnalysis(idGet(thisSession), body2);
                        end
                        % Launch the job
                        if ~pratikStep1
                            st.fw.addSessionAnalysis(idGet(thisSession), body);
                        end
                    case {'acpc-anat'}
                        % Edit the config defaults specific to this project
                        % No changes to the defaults
                        % And now create the body for the analysis
                        % Obtain the acquisitionsIDs:
                        acqus     = st.list('acquisition', idGet(thisSession));
                        anatAcqu  = [];
                        for na=1:length(acqus)
                            acqu = st.fw.getAcquisition(idGet(acqus{na}));
                            if strcmp(acqu.label,'3D SAG IR FSPGR'); anatAcqu = acqu; end
                            if strcmp(acqu.label,'3D IR FSPGR');     anatAcqu = acqu; end
                        end
                        if isempty(anatAcqu)
                            fprintf('No acquisition found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            anatomicalName  = dr_fwFileName(anatAcqu, '1001.nii.gz');  % Works with contains, do not use *
                            % Introduce check that if any of those is empty, add
                            % the subject to the tmpCollection
                            if isempty(anatomicalName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('anatomical'  , struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatomicalName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gearId', thisGearId, ...
                                                 'inputs', inputs, ...
                                                 'config', config);
                                % Launch the job
                                jobId = st.fw.addJob(thisJob);  
                            end
                        end
                    case {'mrtrix3preproc'}
                        % Edit the config defaults specific to this project
                        % And now create the body for the analysis
                        % Obtain the acquisitionsIDs:
                        if strcmp('PRATIKv12', collectionName)
                            bvecName = 'GradientTable-GE-v12-55dir+1b0.bvec';
                            bvalName = 'GradientTable-GE-v12-55dir+1b0.bval';
                            acqus = st.list('acquisition', idGet(thisSession));
                            anatAcqu = [];
                            for na=1:length(acqus)
                                acqu = st.fw.getAcquisition(idGet(acqus{na}));
                                if strcmp(acqu.label,'3D SAG IR FSPGR'); anatAcqu = acqu; end
                                if strcmp(acqu.label,'3D IR FSPGR');     anatAcqu = acqu; end
                            end
                            % Find the DWI file inside the result of the analysis
                            analyses = st.fw.getSessionAnalyses(idGet(thisSession));
                            diffAnalysis  = [];
                            for nas=1:length(analyses)
                                analysis = st.fw.getSessionAnalysis(idGet(thisSession), idGet(analyses{nas}));
                                if strcmp(analysis.label,'fslmerge the whole thing'); diffAnalysis = analysis; end
                            end
                            % Check if any of those is empty, if not, continue
                            if isempty(anatAcqu) && isempty(diffAnalysis)
                                fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            elseif ~isempty(anatAcqu) && isempty(diffAnalysis)
                                fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')                            
                            elseif isempty(anatAcqu) && ~isempty(diffAnalysis)
                                % Add a struct with input file(s). These are FileReference objects, which are in
                                diffusionName   = dr_fwFileName(diffAnalysis, '1001.nii.gz');  % Works with contains, do not use *
                                % Check if we have the file(s) and continue
                                if isempty(diffusionName)
                                    fprintf('No file found, adding session to the tmpCollection...\n') 
                                    dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                                else
                                    inputs   = struct('BVEC'  , struct('type', 'project','id', idGet(thisProject), 'name', bvecName), ...
                                                      'BVAL'  , struct('type', 'project','id', idGet(thisProject), 'name', bvalName), ...
                                                      'DIFF'  , struct('type', 'analysis','id', idGet(diffAnalysis), 'name', diffusionName));
                                    % create the job with all the involved files in a struct
                                    thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                    body    = struct('label', [labelStr 'Analysis gear: ' gearName 'with defaults.'], ...
                                                     'job'  , thisJob);
                                    % Launch the job
                                    st.fw.addSessionAnalysis(idGet(thisSession), body);
                                end
                            else
                                % Add a struct with input file(s). These are FileReference objects, which are in
                                anatomicalName  = dr_fwFileName(anatAcqu, 'autoMNI.nii.gz');  % Works with contains, do not use *
                                diffusionName   = dr_fwFileName(diffAnalysis, '1001.nii.gz');  % Works with contains, do not use *
                                % Check if we have the file(s) and continue
                                if isempty(anatomicalName) | isempty(diffusionName)
                                    fprintf('No file found, adding session to the tmpCollection...\n') 
                                    dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                                else
                                    inputs   = struct('ANAT'  , struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatomicalName), ...
                                                      'BVEC'  , struct('type', 'project','id', idGet(thisProject), 'name', bvecName), ...
                                                      'BVAL'  , struct('type', 'project','id', idGet(thisProject), 'name', bvalName), ...
                                                      'DIFF'  , struct('type', 'analysis','id', idGet(diffAnalysis), 'name', diffusionName));
                                    % create the job with all the involved files in a struct
                                    thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                    body    = struct('label', [labelStr 'Analysis gear: ' gearName 'with defaults.'], ...
                                                     'job'  , thisJob);
                                    % Launch the job
                                    st.fw.addSessionAnalysis(idGet(thisSession), body);
                                end
                                
                            end
                            
                        elseif strcmp('PRATIKv14', collectionName)
                            bvecName = 'GE-v14-55dir+7b0.bvec.bvec';
                            bvalName = 'GE-v14-55dir+7b0.bval';
                            acqus = st.list('acquisition', idGet(thisSession));
                            anatAcqu = [];
                            diffAcqu = [];
                            for na=1:length(acqus)
                                acqu = st.fw.getAcquisition(idGet(acqus{na}));
                                if strcmp(acqu.label,'3D SAG IR FSPGR'); anatAcqu = acqu; end
                                if strcmp(acqu.label,'hardi55 b=1000 1.8mm');diffAcqu = acqu; end
                            end
                            % Check if any of those is empty, if not, continue
                            if isempty(anatAcqu) && isempty(diffAcqu)
                                fprintf('No acquisition found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            elseif ~isempty(anatAcqu) && isempty(diffAcqu)
                                fprintf('No acquisition found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')    
                            elseif isempty(anatAcqu) && ~isempty(diffAcqu)
                                % Add a struct with input file(s). These are FileReference objects, which are in
                                diffusionName   = dr_fwFileName(diffAcqu, '1001.nii.gz');  % Works with contains, do not use *
                                % Check if we have the file(s) and continue
                                if isempty(diffusionName)
                                    fprintf('No file found, adding session to the tmpCollection...\n') 
                                    dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                                else
                                    inputs   = struct('BVEC'  , struct('type', 'project','id', idGet(thisProject), 'name', bvecName), ...
                                                      'BVAL'  , struct('type', 'project','id', idGet(thisProject), 'name', bvalName), ...
                                                      'DIFF'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', diffusionName));
                                    % create the job with all the involved files in a struct
                                    thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                    body    = struct('label', [labelStr 'Analysis gear: ' gearName 'with defaults.'], ...
                                                     'job'  , thisJob);
                                    % Launch the job
                                    st.fw.addSessionAnalysis(idGet(thisSession), body);
                                end

                            else
                                % Add a struct with input file(s). These are FileReference objects, which are in
                                anatomicalName  = dr_fwFileName(anatAcqu, 'autoMNI.nii.gz');  % Works with contains, do not use *
                                diffusionName   = dr_fwFileName(diffAcqu, '1001.nii.gz');  % Works with contains, do not use *
                                % Check if we have the file(s) and continue
                                if isempty(anatomicalName) | isempty(diffusionName)
                                    fprintf('No file found, adding session to the tmpCollection...\n') 
                                    dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                                else
                                    inputs   = struct('ANAT'  , struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatomicalName), ...
                                                      'BVEC'  , struct('type', 'project','id', idGet(thisProject), 'name', bvecName), ...
                                                      'BVAL'  , struct('type', 'project','id', idGet(thisProject), 'name', bvalName), ...
                                                      'DIFF'  , struct('type', 'acquisition','id', idGet(diffAcqu), 'name', diffusionName));
                                    % create the job with all the involved files in a struct
                                    thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                    body    = struct('label', [labelStr 'Analysis gear: ' gearName 'with defaults.'], ...
                                                     'job'  , thisJob);
                                    % Launch the job
                                    st.fw.addSessionAnalysis(idGet(thisSession), body);
                                end
                                
                            end
                        end
                    case {'dwi-flip-bvec'}
                        config.xFlip = true;
                        % Find the bvec file inside the result of the analysis
                        analyses = st.fw.getSessionAnalyses(idGet(thisSession));
                        bvecAnalysis  = [];
                        for nas=1:length(analyses)
                            analysis = st.fw.getSessionAnalysis(idGet(thisSession), idGet(analyses{nas}));
                            if (strcmp(analysis.label,'Analysis gear: mrtrix3preproc: with defaults.') & ...
                               (strcmp(analysis.job.state, 'complete'))); 
                                bvecAnalysis = analysis; 
                            end
                        end
                        % Check if any of those is empty, if not, continue
                        if isempty(bvecAnalysis)
                            fprintf('No analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            bvecName   = dr_fwFileName(bvecAnalysis, 'dwi.bvecs');  % Works with contains, do not use *
                            % Check if we have the file(s) and continue
                            if isempty(bvecName)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs = struct('bvec'  , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                 'inputs', inputs, ...
                                                 'config', config);
                                % Launch the job
                                % jobId = st.fw.addJob(thisJob);
                                % If the job is launched as a utility gear it will
                                % overwrite the output of the analysis. Launch
                                % it as an analysis gear.
                                % create the job with all the involved files in a struct
                                body    = struct('label', [labelStr 'flipX: Analysis gear: ' gearName '.'], ...
                                                 'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                                
                            end 
                        end
                    case {'neuro-detect'}
                        preprocAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'Analysis gear: mrtrix3preproc: with defaults.','last');
                        % bvecAnalysis    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX: Analysis gear: dwi-flip-bvec.','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(preprocAnalysis) % || isempty(bvecAnalysis)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % bvecName = dr_fwFileName(bvecAnalysis, '.bvecs');  % 
                            bvecName      = dr_fwFileName(preprocAnalysis, '.bvecs');
                            bvalName      = dr_fwFileName(preprocAnalysis, '.bvals');
                            diffusionName = dr_fwFileName(preprocAnalysis, '.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs   = struct('bvec'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvecName), ...% 'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis), 'name', bvecName), ... % 
                                                  'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', bvalName), ...
                                                  'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis), 'name', diffusionName));

                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                body    = struct('label', [labelStr 'neuro-detect OK'], ...
                                                     'job'  , thisJob);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end
                        end                        
                    case {'afq-pipeline','afq-pipeline-3'}
                        % Edit the config defaults specific to this project
                        disp(fprintf('Changing defaults for project %s and gear  %s\n', thisProject.label, gearName))
                        % config.rotateBvecsWithCanXform = 1; % Philips requires to be onee
                        % config.phaseEncodeDir          = 2; % A >> P = 2, In Philips (Fold-Over) = Siemens (Phase-Encoding)
                        % Edit the config defaults specific to this project
                        config.dwOutMm_1               =  2;
                        config.dwOutMm_2               =  2;
                        config.dwOutMm_3               =  2;
                        config.rotateBvecsWithCanXform =  1; 
                        config.rotateBvecsWithRx       =  0; % Just for testing the new gear
                            acqus = st.list('acquisition', idGet(thisSession));
                            anatAcqu = [];
                            for na=1:length(acqus)
                                acqu = st.fw.getAcquisition(idGet(acqus{na}));
                                if strcmp(acqu.label,'3D SAG IR FSPGR'); anatAcqu = acqu; end
                                if strcmp(acqu.label,'3D IR FSPGR');     anatAcqu = acqu; end
                            end
                            % Find the DWI file inside the result of the analysis
                            analyses = st.fw.getSessionAnalyses(idGet(thisSession));
                            diffAnalysis  = [];
                            flipAnalysis  = [];
                            for nas=1:length(analyses)
                                analysis = st.fw.getSessionAnalysis(idGet(thisSession), idGet(analyses{nas}));
                                if strcmp(analysis.label,'Analysis gear: mrtrix3preproc: with defaults.'); diffAnalysis = analysis; end
                                if strcmp(analysis.label,'flipX: Analysis gear: dwi-flip-bvec.'); flipAnalysis = analysis; end
                            end
                            % Check if any of those is empty, if not, continue
                            if isempty(anatAcqu) && isempty(diffAnalysis)
                                fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            elseif ~isempty(anatAcqu) && isempty(diffAnalysis)
                                fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')                            
                            elseif isempty(anatAcqu) && ~isempty(diffAnalysis)
                                % Add a struct with input file(s). These are FileReference objects, which are in
                                bvecName      = dr_fwFileName(flipAnalysis, '.bvecs');
                                bvalName      = dr_fwFileName(diffAnalysis, 'dwi.bvals');
                                diffusionName = dr_fwFileName(diffAnalysis, 'dwi.nii.gz');
                                % Check if we have the file(s) and continue
                                if isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                    fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                    dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                                else
                                    inputs   = struct('bvec'      , struct('type', 'analysis','id', idGet(flipAnalysis), 'name', bvecName), ...
                                                      'bval'      , struct('type', 'analysis','id', idGet(diffAnalysis), 'name', bvalName), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(diffAnalysis), 'name', diffusionName));
                                    % create the job with all the involved files in a struct
                                    thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                    body    = struct('label', [labelStr 'Analysis ' gearName], ...
                                                     'job'  , thisJob);
                                    % Launch the job
                                    st.fw.addSessionAnalysis(idGet(thisSession), body);
                                end
                            else
                                % Add a struct with input file(s). These are FileReference objects, which are in
                                anatName      = dr_fwFileName(anatAcqu, 'autoMNI.nii.gz');
                                bvecName      = dr_fwFileName(flipAnalysis, '.bvecs');
                                bvalName     = dr_fwFileName(diffAnalysis, 'dwi.bvals');
                                diffusionName = dr_fwFileName(diffAnalysis, 'dwi.nii.gz');
                                % Check if we have the file(s) and continue
                                if isempty(anatName) || isempty(diffusionName) || isempty(bvecName) || isempty(bvalName)
                                    fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                    dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                                else
                                    inputs   = struct('anatomical', struct('type', 'acquisition','id', idGet(anatAcqu), 'name', anatName), ...
                                                      'bvec'      , struct('type', 'analysis','id', idGet(flipAnalysis), 'name', bvecName), ...
                                                      'bval'      , struct('type', 'analysis','id', idGet(diffAnalysis), 'name', bvalName), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(diffAnalysis), 'name', diffusionName));
                                    % create the job with all the involved files in a struct
                                    thisJob = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs, ...
                                                     'config', config);
                                    body    = struct('label', [labelStr 'Analysis ' gearName], ...
                                                     'job'  , thisJob);
                                    % Launch the job
                                    st.fw.addSessionAnalysis(idGet(thisSession), body);
                                end
                            end
                    otherwise
                        disp(fprintf('No changes for project %s and gear  %s\n', thisProject.label, gearName))
                end
        case {'Weston Havens'}       
                % Edit the config defaults specific to this project
                config = configDefault;
                switch gearName
                    case {'freesurfer-recon-all'}
                        % Edit the config defaults specific to this project
                        % No changes to the defaults
                        config.subject_id = thisSession.subject.code;
                        % And now create the body for the analysis
                        % Obtain the acquisitionsIDs:
                        analyses = st.fw.getSessionAnalyses(idGet(thisSession));
                        thisAnalysis = [];
                        for na=1:length(analyses)
                            analysis = st.fw.getAnalysis(idGet(analyses{na}));
                            if strcmp(analysis.label,'mrQ_Synthesized_T1'); thisAnalysis = analysis; end
                        end
                        if isempty(thisAnalysis)
                            fprintf('No T1w found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Now find the files. 
                            T1wAcpcName  = dr_fwFileName(thisAnalysis, 't1w_acpc.nii.gz');
                            T1wRawName   = dr_fwFileName(thisAnalysis, 't1w_raw.nii.gz');
                            T1wFs4Name   = dr_fwFileName(thisAnalysis, 'T1wfs_4.nii.gz');
                            
                            T1wName      = [];
                            if ~isempty(T1wAcpcName)
                                T1wName  = T1wAcpcName;
                            elseif (isempty(T1wAcpcName) && ~isempty(T1wRawName))
                                T1wName  = T1wRawName;
                            elseif (isempty(T1wAcpcName) && ~isempty(T1wFs4Name))
                                T1wName  = T1wFs4Name;
                            end
                            
                            if isempty(T1wName)
                                fprintf('No T1w found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                % Introduce check that if any of those is empty, add
                                % the subject to the tmpCollection
                                inputs   = struct('anatomical'  , struct('type', 'analysis','id', idGet(thisAnalysis), 'name', T1wName));
                                % create the job with all the involved files in a struct
                                thisJob = struct('gear_id', thisGearId, ...
                                                 'inputs', inputs, ...
                                                 'config', config);
                                body    = struct('label', [labelStr gearName ':' gearVersion ' analysis' ], ...
                                                 'job'  , thisJob);         
                                % Launch the jobs
                                st.fw.addSessionAnalysis(idGet(thisSession), body);
                            end   
                        end
                    case {'mrtrix3preproc'}
                        % Edit the config defaults specific to this project
                        % And now create the body for the analysis
                        % Obtain the acquisitionsIDs:
                        acqus = st.list('acquisition', idGet(thisSession));
                        diffAcqu1000 = [];
                        diffAcqu2000 = [];
                        for na=1:length(acqus)
                            acqu = st.fw.getAcquisition(idGet(acqus{na}));
                            if contains(acqu.label,'b1000'); diffAcqu1000 = acqu; end
                            if contains(acqu.label,'b2000'); diffAcqu2000 = acqu; end
                        end
                        % Check if any of those is empty, if not, continue
                        if isempty(diffAcqu1000) || isempty(diffAcqu2000)
                            fprintf('b1000 or b2000 or both are missing, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            dwi1000Name   = dr_fwFileName(diffAcqu1000, '.nii.gz'); 
                            dwi2000Name   = dr_fwFileName(diffAcqu2000, '.nii.gz'); 
                            bvec1000Name  = dr_fwFileName(diffAcqu1000, '.bvec'); 
                            bvec2000Name  = dr_fwFileName(diffAcqu2000, '.bvec'); 
                            bval1000Name  = dr_fwFileName(diffAcqu1000, '.bval'); 
                            bval2000Name  = dr_fwFileName(diffAcqu2000, '.bval'); 
                            % Check if we have the file(s) and continue
                            if (isempty(dwi1000Name)  || isempty(dwi2000Name)  || ...
                                isempty(bvec1000Name) || isempty(bvec2000Name) || ...
                                isempty(bval1000Name) || isempty(bval2000Name))
                                fprintf('At least one file missing, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs1000   = struct('BVEC'  , struct('type', 'acquisition','id', idGet(diffAcqu1000), 'name', bvec1000Name), ...
                                                      'BVAL'  , struct('type', 'acquisition','id', idGet(diffAcqu1000), 'name', bval1000Name), ...
                                                      'DIFF'  , struct('type', 'acquisition','id', idGet(diffAcqu1000), 'name', dwi1000Name));
                                inputs2000   = struct('BVEC'  , struct('type', 'acquisition','id', idGet(diffAcqu2000), 'name', bvec2000Name), ...
                                                      'BVAL'  , struct('type', 'acquisition','id', idGet(diffAcqu2000), 'name', bval2000Name), ...
                                                      'DIFF'  , struct('type', 'acquisition','id', idGet(diffAcqu2000), 'name', dwi2000Name));
                                % create the job with all the involved files in a struct
                                thisJob1000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs1000, ...
                                                     'config', config);
                                thisJob2000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs2000, ...
                                                     'config', config);
                                body1000    = struct('label', [labelStr 'b1000 ' gearName ':' gearVersion ' analysis'], ...
                                                     'job'  , thisJob1000);
                                body2000    = struct('label', [labelStr 'b2000 ' gearName ':' gearVersion ' analysis'], ...
                                                     'job'  , thisJob2000);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body1000);
                                st.fw.addSessionAnalysis(idGet(thisSession), body2000);
                            end

                        end                            
                    case {'dwi-flip-bvec'}
                        config.xFlip = true;
                        % Find the bvec file inside the result of the analysis
                        bvecAnalysis1000  = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'b1000 mrtrix3preproc:1.0.2 analysis','last');
                        bvecAnalysis2000  = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'b2000 mrtrix3preproc:1.0.2 analysis','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(bvecAnalysis1000) || isempty(bvecAnalysis2000)
                            fprintf('No analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            bvecName1000   = dr_fwFileName(bvecAnalysis1000, 'dwi.bvecs');
                            bvecName2000   = dr_fwFileName(bvecAnalysis2000, 'dwi.bvecs');
                            % Check if we have the file(s) and continue
                            if isempty(bvecName1000) || isempty(bvecName2000)
                                fprintf('No file found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs1000 = struct('bvec' , struct('type', 'analysis','id', idGet(bvecAnalysis1000), 'name', bvecName1000));
                                inputs2000 = struct('bvec' , struct('type', 'analysis','id', idGet(bvecAnalysis2000), 'name', bvecName2000));
                                % create the job with all the involved files in a struct
                                thisJob1000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs1000, ...
                                                     'config', config);
                                thisJob2000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs2000, ...
                                                     'config', config); 
                                % Launch the job
                                % jobId = st.fw.addJob(thisJob);
                                % If the job is launched as a utility gear it will
                                % overwrite the output of the analysis. Launch
                                % it as an analysis gear.
                                % create the job with all the involved files in a struct
                                body1000    = struct('label', [labelStr 'flipX b1000 gear: ' gearName], ...
                                                     'job'  , thisJob1000);
                                body2000    = struct('label', [labelStr 'flipX b2000 gear: ' gearName], ...
                                                     'job'  , thisJob2000);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body1000);
                                st.fw.addSessionAnalysis(idGet(thisSession), body2000);
                                
                            end 
                        end
                    case {'dtiinit'}
                        % Edit the config defaults specific to this project
                        fprintf('Changing defaults for project %s and gear %s\n', thisProject.label, gearName);
                        % config.rotateBvecsWithCanXform = 1; % Philips requires to be onee
                        % config.phaseEncodeDir          = 2; % A >> P = 2, In Philips (Fold-Over) = Siemens (Phase-Encoding)
                        % Edit the config defaults specific to this project
                        config.dwOutMm0x2D1            =  4; % This is for training the neural network only
                        config.dwOutMm0x2D2            =  4;
                        config.dwOutMm0x2D3            =  4;
                        config.rotateBvecsWithCanXform =  1; 
                        config.rotateBvecsWithRx       =  0; % Just for testing the new gear
                        
                        preprocAnalysis1000 = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'b1000 mrtrix3preproc:1.0.2 analysis','last');
                        preprocAnalysis2000 = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'b2000 mrtrix3preproc:1.0.2 analysis','last');
                        bvecAnalysis1000    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX b1000 gear: dwi-flip-bvec','last');
                        bvecAnalysis2000    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX b2000 gear: dwi-flip-bvec','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(preprocAnalysis1000) || isempty(preprocAnalysis2000) || isempty(bvecAnalysis1000) || isempty(bvecAnalysis2000)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % bvecName1000      = dr_fwFileName(bvecAnalysis1000, '.bvecs');
                            bvecName1000      = dr_fwFileName(preprocAnalysis1000, '.bvecs');
                            bvalName1000      = dr_fwFileName(preprocAnalysis1000, 'dwi.bvals');
                            diffusionName1000 = dr_fwFileName(preprocAnalysis1000, 'dwi.nii.gz');
                            % bvecName2000      = dr_fwFileName(bvecAnalysis2000, '.bvecs');
                            bvecName2000      = dr_fwFileName(preprocAnalysis2000, '.bvecs');
                            bvalName2000      = dr_fwFileName(preprocAnalysis2000, 'dwi.bvals');
                            diffusionName2000 = dr_fwFileName(preprocAnalysis2000, 'dwi.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(diffusionName1000) || isempty(bvecName1000) || isempty(bvalName1000)|| isempty(diffusionName2000) || isempty(bvecName2000) || isempty(bvalName2000)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs1000   = struct('bvec'      , struct('type', 'analysis','id', idGet(preprocAnalysis1000), 'name', bvecName1000), ...%'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis1000), 'name', bvecName1000), ...
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis1000), 'name', bvalName1000), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis1000), 'name', diffusionName1000));
                                inputs2000   = struct('bvec'      , struct('type', 'analysis','id', idGet(preprocAnalysis2000), 'name', bvecName2000), ...%'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis2000), 'name', bvecName2000), ...
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis2000), 'name', bvalName2000), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis2000), 'name', diffusionName2000));
                                % create the job with all the involved files in a struct
                                thisJob1000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs1000, ...
                                                     'config', config);
                                thisJob2000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs2000, ...
                                                     'config', config);
                                body1000    = struct('label', [labelStr 'noFlip (ko) Allv01: Analysis b1000 ' gearName], ...%struct('label', [labelStr 'Xflip (ok) Allv01: Analysis b1000 ' gearName], ...
                                                     'job'  , thisJob1000);
                                body2000    = struct('label', [labelStr 'noFlip (ko) Allv01: Analysis b2000 ' gearName], ...%struct('label', [labelStr 'Xflip (ok) Allv01: Analysis b2000 ' gearName], ...
                                                     'job'  , thisJob2000);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body1000);
                                st.fw.addSessionAnalysis(idGet(thisSession), body2000);
                            end
                        end
                    case {'neuro-detect'}
                        preprocAnalysis1000 = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'b1000 mrtrix3preproc:1.0.2 analysis','last');
                        preprocAnalysis2000 = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'b2000 mrtrix3preproc:1.0.2 analysis','last');
                        % bvecAnalysis1000    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX b1000 gear: dwi-flip-bvec','last');
                        % bvecAnalysis2000    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX b2000 gear: dwi-flip-bvec','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(preprocAnalysis1000) || isempty(preprocAnalysis2000) % || isempty(bvecAnalysis1000) || isempty(bvecAnalysis2000)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % bvecName1000      = dr_fwFileName(bvecAnalysis1000, '.bvecs');
                            bvecName1000      = dr_fwFileName(preprocAnalysis1000, '.bvecs');
                            bvalName1000      = dr_fwFileName(preprocAnalysis1000, '.bvals');
                            diffusionName1000 = dr_fwFileName(preprocAnalysis1000, '.nii.gz');
                            
                            % bvecName2000      = dr_fwFileName(bvecAnalysis2000, '.bvecs');
                            bvecName2000      = dr_fwFileName(preprocAnalysis2000, '.bvecs');
                            bvalName2000      = dr_fwFileName(preprocAnalysis2000, '.bvals');
                            diffusionName2000 = dr_fwFileName(preprocAnalysis2000, '.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(diffusionName1000) || isempty(bvecName1000) || isempty(bvalName1000)|| isempty(diffusionName2000) || isempty(bvecName2000) || isempty(bvalName2000)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                inputs1000   = struct('bvec'      , struct('type', 'analysis','id', idGet(preprocAnalysis1000), 'name', bvecName1000), ...% 'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis1000), 'name', bvecName1000), ... % 
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis1000), 'name', bvalName1000), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis1000), 'name', diffusionName1000));
                                inputs2000   = struct('bvec'      , struct('type', 'analysis','id', idGet(preprocAnalysis2000), 'name', bvecName2000), ...%'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis2000), 'name', bvecName2000), ...  % 
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis2000), 'name', bvalName2000), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis2000), 'name', diffusionName2000));
                                % create the job with all the involved files in a struct
                                thisJob1000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs1000, ...
                                                     'config', config);
                                thisJob2000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs2000, ...
                                                     'config', config);
                                body1000    = struct('label', [labelStr 'neuro-detect OK b1000'], ...
                                                     'job'  , thisJob1000);
                                body2000    = struct('label', [labelStr 'neuro-detect OK b2000'], ...
                                                     'job'  , thisJob2000);
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body1000);
                                st.fw.addSessionAnalysis(idGet(thisSession), body2000);
                            end
                        end
                    case {'afq-pipeline','afq-pipeline-3'}
                        % Edit the config defaults specific to this project
                        fprintf('Changing defaults for project %s and gear %s\n', thisProject.label, gearName)
                        % config.rotateBvecsWithCanXform = 1; % Philips requires to be onee
                        % config.phaseEncodeDir          = 2; % A >> P = 2, In Philips (Fold-Over) = Siemens (Phase-Encoding)
                        % Edit the config defaults specific to this project
                        config.dwOutMm_1               =  2; % This data is 0.8 x 0.8 x 2
                        config.dwOutMm_2               =  2;
                        config.dwOutMm_3               =  2;
                        config.rotateBvecsWithCanXform =  1; 
                        config.rotateBvecsWithRx       =  0; % Just for testing the new gear
                        % fsAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'freesurfer-recon-all:0.1.4 analysis','last');
                        % It is not finding the file!!!!!!! Let's look in the acqu
                        fsAnalysis = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'mrQ_Synthesized_T1','last');
                        % fsAcqu     = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', '2178_11_1_SPGR_1mm_4deg','last');
                        preprocAnalysis1000 = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'b1000 mrtrix3preproc:1.0.2 analysis','last');
                        preprocAnalysis2000 = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'b2000 mrtrix3preproc:1.0.2 analysis','last');
                        bvecAnalysis1000    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX b1000 gear: dwi-flip-bvec','last');
                        bvecAnalysis2000    = dr_fwSearchAcquAnalysis(st, thisSession, 'analysis', 'flipX b2000 gear: dwi-flip-bvec','last');
                        % Check if any of those is empty, if not, continue
                        if isempty(fsAnalysis) || isempty(preprocAnalysis1000) || isempty(preprocAnalysis2000) || isempty(bvecAnalysis1000) || isempty(bvecAnalysis2000)
                            fprintf('No acquisition or analysis found, adding session to the tmpCollection...\n') 
                            dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                        else
                            % Add a struct with input file(s). These are FileReference objects, which are in
                            % anatName          = dr_fwFileName(fsAnalysis, 'T1.nii.gz');
                            % dtiInit is failing when we use the output of FS
                            % pipeline, so we use the acpc-anat for now
                            % Find the file, it can have several names
                            anatName   = dr_fwFileName(fsAnalysis, 't1w_acpc.nii.gz');
                            % anatName   = dr_fwFileName(fsAcqu, 'T1_RAS.nii.gz');
                            if isempty(anatName)
                                anatName   = dr_fwFileName(fsAnalysis, 't1w_raw.nii.gz');
                            end
                            if isempty(anatName)
                                anatName   = dr_fwFileName(fsAnalysis, 'T1wfs_4.nii.gz');
                            end
                            
                            bvecName1000      = dr_fwFileName(bvecAnalysis1000, 'X.bvecs');
                            bvalName1000      = dr_fwFileName(preprocAnalysis1000, 'dwi.bvals');
                            diffusionName1000 = dr_fwFileName(preprocAnalysis1000, 'dwi.nii.gz');
                            bvecName2000      = dr_fwFileName(bvecAnalysis2000, 'X.bvecs');
                            bvalName2000      = dr_fwFileName(preprocAnalysis2000, 'dwi.bvals');
                            diffusionName2000 = dr_fwFileName(preprocAnalysis2000, 'dwi.nii.gz');
                            % Check if we have the file(s) and continue
                            if isempty(anatName) || isempty(diffusionName1000) || isempty(bvecName1000) || isempty(bvalName1000)|| isempty(diffusionName2000) || isempty(bvecName2000) || isempty(bvalName2000)
                                fprintf('Not all files found, adding session to the tmpCollection...\n') 
                                dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
                            else
                                % inputs1000   = struct('anatomical', struct('type', 'acquisition','id', idGet(fsAcqu), 'name', anatName), ...    
                                
                                inputs1000   = struct('anatomical', struct('type', 'analysis','id', idGet(fsAnalysis), 'name', anatName), ...
                                                      'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis1000), 'name', bvecName1000), ...
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis1000), 'name', bvalName1000), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis1000), 'name', diffusionName1000));
                                inputs2000   = struct('anatomical', struct('type', 'analysis','id', idGet(fsAnalysis), 'name', anatName), ...
                                                      'bvec'      , struct('type', 'analysis','id', idGet(bvecAnalysis2000), 'name', bvecName2000), ...
                                                      'bval'      , struct('type', 'analysis','id', idGet(preprocAnalysis2000), 'name', bvalName2000), ...
                                                      'dwi'       , struct('type', 'analysis','id', idGet(preprocAnalysis2000), 'name', diffusionName2000));
                                % create the job with all the involved files in a struct
                                thisJob1000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs1000, ...
                                                     'config', config);
                                thisJob2000 = struct('gear_id', thisGearId, ...
                                                     'inputs', inputs2000, ...
                                                     'config', config);
                                body1000    = struct('label', [labelStr 'Analysis b1000 ' gearName], ...
                                                     'job'  , thisJob1000);
                                body2000    = struct('label', [labelStr 'Analysis b2000 ' gearName], ...
                                                     'job'  , thisJob2000);  
                                % Launch the job
                                st.fw.addSessionAnalysis(idGet(thisSession), body1000);
                                st.fw.addSessionAnalysis(idGet(thisSession), body2000);
                            end
                        end
                    otherwise
                        disp(fprintf('No changes for project %s and gear  %s\n', thisProject.label, gearName))
                end
        otherwise
            disp('Not implemented yet')
    end
end   

%% Pratik's data need to run fslmerge twice...
%{


% Now we need to concatenate the results of the analyses
JL = dr_fwCheckJobs(serverName, collectionName);
% FILTER
state       = 'complete';
T = JL(JL.state==state & JL.gearName==gearName & ...
    JL.gearVersion==gearVersion & ...
    JL.TRT == 'Exam2-ACC28',:);
subs = unique(T.SubjID);
for ns=1:length(subs)
    t = T(T.SubjID == subs(ns),:);
    if height(t)==2
        an1 = t(t.label=='Analysis first half fslmerge',:).Analysis;
        an2 = t(t.label=='Analysis second half fslmerge',:).Analysis;
        bvec1Name  = dr_fwFileName(an1, '1001.bvec');  % Works with contains, do not use *
        bval1Name  = dr_fwFileName(an1, '1001.bval');
        nifti1Name = dr_fwFileName(an1, '1001.nii.gz');
        bvec2Name  = dr_fwFileName(an2, '1001.bvec');
        bval2Name  = dr_fwFileName(an2, '1001.bval');
        nifti2Name = dr_fwFileName(an2, '1001.nii.gz');    
        inputs   = struct('BVEC_1'  , struct('type', 'analysis','id', an1.id, 'name', bvec1Name), ...
                          'BVAL_1'  , struct('type', 'analysis','id', an1.id,'name', bval1Name), ...
                          'NIFTI_1' , struct('type', 'analysis','id', an1.id,'name', nifti1Name), ...
                          'BVEC_2'  , struct('type', 'analysis','id', an2.id, 'name', bvec2Name), ...
                          'BVAL_2'  , struct('type', 'analysis','id', an2.id,'name', bval2Name), ...
                          'NIFTI_2' , struct('type', 'analysis','id', an2.id,'name', nifti2Name));
        % create the job with all the involved files in a struct
        thisJob = struct('gear_id', t.Analysis(1).gearInfo.id, ...
                         'inputs', inputs, ...
                         'config', config);
        body    = struct('label', [labelStr 'fslmerge the whole thing'], ...
                         'job'  , thisJob);
        thisSession = st.fw.getSession(t.Analysis(1).parent.id); 
        st.fw.addSessionAnalysis(idGet(thisSession), body);
    elseif height(t)==3
        fprintf('%s has been already processed, ignoring', thisSession.subject.code)
    else
        fprintf('There are no two halfs in %s, session added to tmpCollection', thisSession.subject.code)
        nodes = {flywheel.model.CollectionNode('level', 'session', 'id', idGet(thisSession)) };
        contents = flywheel.model.CollectionOperation('operation', 'add', 'nodes', nodes);
        st.fw.modifyCollection(tmpCollectionID, flywheel.model.Collection('contents', contents));
    end
    
end


%}


% Creating a utility or converter job:
% You'll also need a destination container (where output files will be written), in the form of container type and container id:
% dest = struct('type', 'acquisition', 'id', acquisition.id);
% Once you have those pieces, you can add the job to the system:
% fw.addJob(struct('gearId', gear.id, 'inputs', struct('dicom', dicomInput), 'destination', dest, 'config', config));

% Creating job-based analysis:
% If you want to create an analysis object as part of job execution, you can 
% instead call add<Container>Analysis:

% 



%% 5.- Check if the jobs were launched succesfully
%{
    clear all; clc; 
    serverName     = 'stanfordlabs';
    collectionName = 'ComputationalReproducibility';
    collectionName = 'ILLITERATES';

    % GET ALL JOBS FROM COLLECTION
    JL = dr_fwCheckJobs(serverName, collectionName);

    % FILTER
    date_After  = '06-Feb-2018 00:00:00';  % neuro-detect KO ... I forgot to change the name in some of them

    gearName    = 'acpc-anat';
    gearVersion = '1.0.3';
    gearName    = 'mrtrix3preproc';
    gearVersion = '1.0.2';
    gearName    = 'dwi-flip-bvec';
    gearVersion = '1.0.0';
	gearName    = 'freesurfer-recon-all';
	gearVersion = '0.1.4';
    gearName    = 'afq-pipeline';,'afq-pipeline-3'
    gearVersion = '3.0.0';
    gearName    = 'neuro-detect';
    gearVersion = '0.2.1';


    state = 'complete' ; complete  = JL(JL.state==state & JL.gearName==gearName & JL.gearVersion==gearVersion & JL.JobCreated>date_After,:);
    state = 'running'  ; running   = JL(JL.state==state & JL.gearName==gearName & JL.gearVersion==gearVersion & JL.JobCreated>date_After,:);
    state = 'failed'   ; failed    = JL(JL.state==state & JL.gearName==gearName & JL.gearVersion==gearVersion & JL.JobCreated>date_After,:);
    state = 'cancelled'; cancelled = JL(JL.state==state & JL.gearName==gearName & JL.gearVersion==gearVersion & JL.JobCreated>date_After,:);
    state = 'pending'  ; pending   = JL(JL.state==state & JL.gearName==gearName & JL.gearVersion==gearVersion & JL.JobCreated>date_After,:);
    state = 'uploaded' ; uploaded  = JL(JL.state==state & JL.gearName==gearName & JL.gearVersion==gearVersion & JL.JobCreated>date_After,:);

    fprintf('Pending: %d\n', height(pending))
    fprintf('running: %d\n', height(running))
    fprintf('complete: %d\n', height(complete))
    fprintf('failed: %d\n', height(failed))
    fprintf('cancelled: %d\n', height(cancelled))
    fprintf('Sum is: %d\n',height(running)+height(pending)+height(complete)+height(failed)+height(cancelled))


% DELETE SESSIONS
toDelete = [complete;failed;cancelled]; height(toDelete)
% toDelete2000 = [failed([1],:)]; height(toDelete2000)
% toDelete1000 = [failed([1],:)]; height(toDelete1000)


toDelete = failed;

st = scitran('stanfordlabs');

for ns=1:height(toDelete)
    thisAnalysisID = toDelete(ns,:).Analysis.id;
    thisSessionID = toDelete(ns,:).Analysis.parent.id;
    result = st.fw.deleteSessionAnalysis(thisSessionID, thisAnalysisID);
end


% ADD FAILED TO TEMP
% Make sure it is empty first
if isempty(st.fw.getCollectionSessions('5b605d3fd294db0016bb3b96'))
    for ns=1:height(toDelete)
        thisAnalysisID = toDelete(ns,:).Analysis.id;
        thisSessionID  = toDelete(ns,:).Analysis.parent.id;
        thisSession    = st.fw.getSession(thisSessionID);
        dr_fwAddSession2tmpCollection(st, thisSession,'tmpCollection')
    end
else
    error('tmpCollection is not empty')
end

%}


%     for ns=1:length(sessionsInCollection)
%         dr_fwAddSession2tmpCollection(st, sessionsInCollection{ns},'ComputationalReproducibility')
%     end












