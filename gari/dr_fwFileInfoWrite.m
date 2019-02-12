function dr_fwFileInfoWrite(serverName, collectionName)
% This function will add the AcquisitionMD information to every file. 
% Right now is fairly manual: give a server and a collection, and inside the
% file there needs to be project and file specific information to be updated. 
% SO: this dile needs to be updated every time a new project is added to the
% collection. Once this is done, the idea would be to add to a collection all
% the files that need to be updated, and launch this function. 
% Example: 
%{
    clear all; clc;

    serverName     = 'stanfordlabs';
    collectionName = 'ILLIT_FAILED';  % 'tmpCollection', 'ComputationalReproducibility', 'FWmatlabAPI_test'
    dr_fwFileInfoWrite(serverName, collectionName)
%}
%
% Another example: the dr_readCollection() function tries to read this
% information, if for some reason it does not find it, then it will add 999
% values to the file and it will add the session to the tmpCollection. Once in
% the tmpCollection, it will be checked the reason AND the info will be updated
% with this function. 
%
%
%       
% For now, it is intended to add the DWI
% information to the HCP preprocessed and bVal splitted .bval, .bvec and dwi
% files.
% 
% 2018: GLU, Vistalab garikoitz@gmail.com




%% 0.- Connect to the session where the example dicom header json is
st = scitran(serverName);
if ~st.verify
    error(fprintf('Connection to %s could not be veryfied', serverName))
end


% Read an example file to copy the header. 
% Only needed the first time or when FW implements changes
%{
egSessionID    = '56e629d9bf794e96d58c577f'; % Example session with the header
egAcqus        =  st.list('acquisition', egSessionID);
for nea=1:length(egAcqus)
    egAcqu     = egAcqus{nea};
    egFileName = '10.1_dicom.json';
    try 
        % Two ways: read the json itself or the info associated to the json
        % which is the same to the one associated to the dwi, bvec and bval
        egFile    = st.fw.getAcquisitionFileInfo(idGet(egAcqu), egFileName);
        paramJson = jsonread(st.fw.downloadFileFromAcquisition(idGet(egAcqu), ...
                                                 egFileName, ...
                                                 fullfile(afqDimPath,'local','tmp',egFileName)));
        assert(isequal(paramJson, egFile.info.struct), 'file.Info and the json file have different dicom header info')
        disp(fprintf('%s found on acquisition %s', egFileName, egAcqu.label));
    catch
        disp(fprintf('%s not found on acquisition %s', egFileName, egAcqu.label));
    end
end
%}


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
    error(fprintf('Collection %s could not be found on the server %s (verify permissions or the collection name).\n', collectionName, serverName))
else
    thisCollection        = st.fw.getCollection(collectionID);
    sessionsInCollection  = st.fw.getCollectionSessions(idGet(thisCollection));
    fprintf('There are %i sessions in the collection %s (server %s).\n', length(sessionsInCollection), collectionName, serverName)
end


%% 3.- Find all the files we want to upgrade
for ns=1:length(sessionsInCollection)
    % Get info for the session
    thisSession = sessionsInCollection{ns};
    % Get info for the project the session belong to
    thisProject = st.fw.getProject(thisSession.project);
    
    fprintf('(%d) %s >> %s (%s)\n', ns, thisProject.label, thisSession.subject.code, thisSession.label)
    switch thisProject.label
        case {'HCP_preproc'}
            % Inform the updated file. This way if some files are not being
            % updated we can see why (project config not added for example)
            fprintf('(%d) %s >> %s (%s)\n', ns, thisProject.label, thisSession.subject.code, thisSession.label)
            % FC: Create the params specific for HCP_preproc first
            % For the first time it was ok to read an example, but we create all
            % the params, so we do not need it anymore. 
            % newParams = egFile.info.struct;
            % These are all the options. I will leave some unchanged, other ''
               newParams.AcquisitionDateTime= '';
               newParams.AcquisitionMatrixPE= 96;
                 newParams.AcquisitionNumber= 1;
                   newParams.AcquisitionTime= '';
                newParams.ConversionSoftware= 'File Info Modification Test';
         newParams.ConversionSoftwareVersion= '';
                newParams.DeviceSerialNumber= '';
                          newParams.EchoTime= 0.0895;
              newParams.EffectiveEchoSpacing= 7.800e-04;
                         newParams.FlipAngle= 78;
      newParams.ImageOrientationPatientDICOM= [0.9994;0;-0.0338;0.0003;1.0000;0.0098];
                         newParams.ImageType= [{'ORIGINAL'};{'PRIMARY' };{'OTHER'}];
newParams.InPlanePhaseEncodingDirectionDICOM= 'COL';
                   newParams.InstitutionName= 'HCP';
                 newParams.MRAcquisitionType= '2D';
             newParams.MagneticFieldStrength= 3;
                      newParams.Manufacturer= 'SIEMENS';
            newParams.ManufacturersModelName= 'CONNECTOME';
                          newParams.Modality= 'MR';
                         newParams.PatientID= thisSession.subject.code;
                   newParams.PatientPosition= '';
                        newParams.PatientSex= '';
                     newParams.PatientWeight= 999;
                   newParams.PercentPhaseFOV= 100;
                 newParams.PhaseEncodingAxis= 'j';
                    newParams.PixelBandwidth= 1.9531e+03;
          newParams.ProcedureStepDescription= '';
                      newParams.ProtocolName= 'NA';
                     newParams.ReconMatrixPE= 256;
            newParams.ReferringPhysicianName= '';
                    newParams.RepetitionTime= 5.52000;
                               newParams.SAR= 999;
                       newParams.ScanOptions= '';
                  newParams.ScanningSequence= 'Spin-echo EPI';
                   newParams.SequenceVariant= 'NONE';
                 newParams.SeriesDescription= 'HCP';
                 newParams.SeriesInstanceUID= '';
                      newParams.SeriesNumber= 999;
                    newParams.SliceThickness= 1.2500;
                  newParams.SoftwareVersions= '';
              newParams.SpacingBetweenSlices= 2.5000;
                       newParams.StationName= 'HCP';
                           newParams.StudyID= '';
                  newParams.StudyInstanceUID= '';
                  newParams.TotalReadoutTime= 999;
            thisAcqus = st.list('acquisition', idGet(thisSession));
            for nta=1:length(thisAcqus)
                thisAcqu = thisAcqus{nta};
                if strcmp(thisAcqu.label, 'Diffusion')
                    for nf=1:length(thisAcqu.files)
                        thisFile=thisAcqu.files{nf};
                        st.fw.setAcquisitionFileInfo(idGet(thisAcqu),thisFile.name, newParams);
                   end
                end
            end
        case {'PRATIK'}
            % Inform the updated file. This way if some files are not being
            % updated we can see why (project config not added for example)
            fprintf('(%d) %s >> %s (%s)\n', ns, thisProject.label, thisSession.subject.code, thisSession.label)
            % FC: Create the params specific for HCP_preproc first
            % For the first time it was ok to read an example, but we create all
            % the params, so we do not need it anymore. 
            % newParams = egFile.info.struct;
            % These are all the options. I will leave some unchanged, other ''
               newParams.AcquisitionDateTime= '';
               newParams.AcquisitionMatrixPE= 96;
                 newParams.AcquisitionNumber= 1;
                   newParams.AcquisitionTime= '';
                newParams.ConversionSoftware= 'File Info Modification Test';
         newParams.ConversionSoftwareVersion= '';
                newParams.DeviceSerialNumber= '';
                          newParams.EchoTime= 0.0625;
              newParams.EffectiveEchoSpacing= 7.800e-04;
                         newParams.FlipAngle= 90;
      newParams.ImageOrientationPatientDICOM= [0.9994;0;-0.0338;0.0003;1.0000;0.0098];
                         newParams.ImageType= [{'ORIGINAL'};{'PRIMARY' };{'OTHER'}];
newParams.InPlanePhaseEncodingDirectionDICOM= 'COL';
                   newParams.InstitutionName= 'PRATIK';
                 newParams.MRAcquisitionType= '2D';
             newParams.MagneticFieldStrength= 3;
                      newParams.Manufacturer= 'GE';
            newParams.ManufacturersModelName= 'Signa Excite';
                          newParams.Modality= 'MR';
                         newParams.PatientID= thisSession.subject.code;
                   newParams.PatientPosition= '';
                        newParams.PatientSex= '';
                     newParams.PatientWeight= 999;
                   newParams.PercentPhaseFOV= 100;
                 newParams.PhaseEncodingAxis= 'j';
                    newParams.PixelBandwidth= 1.9531e+03;
          newParams.ProcedureStepDescription= '';
                      newParams.ProtocolName= 'NA';
                     newParams.ReconMatrixPE= 256;
            newParams.ReferringPhysicianName= '';
                    newParams.RepetitionTime= 7.00000;
                               newParams.SAR= 999;
                       newParams.ScanOptions= '';
                  newParams.ScanningSequence= 'Spin-echo EPI';
                   newParams.SequenceVariant= 'NONE';
                 newParams.SeriesDescription= 'PRATIK';
                 newParams.SeriesInstanceUID= '';
                      newParams.SeriesNumber= 999;
                    newParams.SliceThickness= 1.2500;
    if strcmp(collectionName, 'PRATIKv12')
                  newParams.SoftwareVersions= 'v12';
                                   bvecName = 'GradientTable-GE-v12-55dir+1b0.bvec';
                                   bvalName = 'GradientTable-GE-v12-55dir+1b0.bval';
    elseif strcmp(collectionName, 'PRATIKv14')
                  newParams.SoftwareVersions= 'v14';
                                   bvecName = 'GE-v14-55dir+7b0.bvec.bvec';
                                   bvalName = 'GE-v14-55dir+7b0.bval';
    end
              newParams.SpacingBetweenSlices= 2.5000;
                       newParams.StationName= 'PRATIK';
                           newParams.StudyID= '';
                  newParams.StudyInstanceUID= '';
                  newParams.TotalReadoutTime= 999;

        st.fw.setProjectFileInfo(thisProject.id, bvecName, newParams)
        st.fw.setProjectFileInfo(thisProject.id, bvalName, newParams)
        case {'Weston Havens'}
            % Inform the updated file. This way if some files are not being
            % updated we can see why (project config not added for example)
            % FC: Create the params specific for HCP_preproc first
            % For the first time it was ok to read an example, but we create all
            % the params, so we do not need it anymore. 
            % 
            % In this project we want to read the info from the dwi.nii.gz for
            % the b1000 and the b2000 cases, and then we want take this
            % information and add it manually to our structure and then write it
            % to the bvals and the bvecs, for b1000 and b2000
            acqu1000  = dr_fwSearchAcquAnalysis(st,thisSession,'acquisition','1000');
            acqu2000  = dr_fwSearchAcquAnalysis(st,thisSession,'acquisition','2000');
            dwiName1000 = dr_fwFileName(acqu1000, 'nii.gz');
            dwiName2000 = dr_fwFileName(acqu2000, 'nii.gz');
            bvecName1000 = dr_fwFileName(acqu1000, 'bvec');
            bvecName2000 = dr_fwFileName(acqu2000, 'bvec');
            bvalName1000 = dr_fwFileName(acqu1000, 'bval');
            bvalName2000 = dr_fwFileName(acqu2000, 'bval');
            config1000 = st.fw.getAcquisitionFileInfo(acqu1000.id, dwiName1000).info.struct.fslhd;
            config2000 = st.fw.getAcquisitionFileInfo(acqu2000.id, dwiName2000).info.struct.fslhd;
            
            % DO THE b1000
            % newParams = egFile.info.struct;
            % These are all the options. I will leave some unchanged, other ''
               newParams.AcquisitionDateTime= '';
               newParams.AcquisitionMatrixPE= 96;
                 newParams.AcquisitionNumber= 1;
                   newParams.AcquisitionTime= '';
                newParams.ConversionSoftware= 'File Info Modification Test';
         newParams.ConversionSoftwareVersion= '';
                newParams.DeviceSerialNumber= '';
                          newParams.EchoTime= 0.0831;
              newParams.EffectiveEchoSpacing= 7.800e-04;
                         newParams.FlipAngle= 90;
      newParams.ImageOrientationPatientDICOM= [0.9994;0;-0.0338;0.0003;1.0000;0.0098];
                         newParams.ImageType= [{'ORIGINAL'};{'PRIMARY' };{'OTHER'}];
newParams.InPlanePhaseEncodingDirectionDICOM= 'COL';
                   newParams.InstitutionName= 'CNI';
                 newParams.MRAcquisitionType= '2D';
             newParams.MagneticFieldStrength= 3;
                      newParams.Manufacturer= 'GE';
            newParams.ManufacturersModelName= 'Discovery MR750';
                          newParams.Modality= 'MR';
                         newParams.PatientID= thisSession.subject.code;
                   newParams.PatientPosition= '';
                        newParams.PatientSex= '';
                     newParams.PatientWeight= 999;
                   newParams.PercentPhaseFOV= 100;
                 newParams.PhaseEncodingAxis= 'j';
                    newParams.PixelBandwidth= 1.9531e+03;
          newParams.ProcedureStepDescription= '';
                      newParams.ProtocolName= 'NA';
                     newParams.ReconMatrixPE= 256;
            newParams.ReferringPhysicianName= '';
                    newParams.RepetitionTime= 7.00000;
                               newParams.SAR= 999;
                       newParams.ScanOptions= '';
                  newParams.ScanningSequence= 'Spin-echo EPI';
                   newParams.SequenceVariant= 'NONE';
                 newParams.SeriesDescription= 'PRATIK';
                 newParams.SeriesInstanceUID= '';
                      newParams.SeriesNumber= 999;
                    newParams.SliceThickness= 1.2500;
                  newParams.SoftwareVersions= '999';
              newParams.SpacingBetweenSlices= 2.5000;
                       newParams.StationName= 'CNI';
                           newParams.StudyID= '';
                  newParams.StudyInstanceUID= '';
                  newParams.TotalReadoutTime= 999;
        newParams1000 = newParams;
                  
            % DO THE b2000
            % newParams = egFile.info.struct;
            % These are all the options. I will leave some unchanged, other ''

        newParams2000 = newParams;
                  
                  
                  

        st.fw.setAcquisitionFileInfo(acqu1000.id, bvecName1000, newParams1000);
        st.fw.setAcquisitionFileInfo(acqu2000.id, bvecName2000, newParams2000);
        st.fw.setAcquisitionFileInfo(acqu1000.id, bvalName1000, newParams1000);
        st.fw.setAcquisitionFileInfo(acqu2000.id, bvalName2000, newParams2000);
        
        case {'CoRR'}
            % Inform the updated file. This way if some files are not being
            % updated we can see why (project config not added for example)
            fprintf('(%d) %s >> %s (%s)\n', ns, thisProject.label, thisSession.subject.code, thisSession.label)
            % FC: Create the params specific for HCP_preproc first
            % For the first time it was ok to read an example, but we create all
            % the params, so we do not need it anymore. 
            % newParams = egFile.info.struct;
            % These are all the options. I will leave some unchanged, other ''
               newParams.AcquisitionDateTime= '';
               newParams.AcquisitionMatrixPE= 96;
                 newParams.AcquisitionNumber= 1;
                   newParams.AcquisitionTime= '';
                newParams.ConversionSoftware= 'File Info Modification Test';
         newParams.ConversionSoftwareVersion= '';
                newParams.DeviceSerialNumber= '';
                          newParams.EchoTime= 0.0895;
              newParams.EffectiveEchoSpacing= 7.800e-04;
                         newParams.FlipAngle= 78;
      newParams.ImageOrientationPatientDICOM= [0.9994;0;-0.0338;0.0003;1.0000;0.0098];
                         newParams.ImageType= [{'ORIGINAL'};{'PRIMARY' };{'OTHER'}];
newParams.InPlanePhaseEncodingDirectionDICOM= 'COL';
                   newParams.InstitutionName= 'HCP';
                 newParams.MRAcquisitionType= '2D';
             newParams.MagneticFieldStrength= 3;
                      newParams.Manufacturer= 'SIEMENS';
            newParams.ManufacturersModelName= 'CONNECTOME';
                          newParams.Modality= 'MR';
                         newParams.PatientID= thisSession.subject.code;
                   newParams.PatientPosition= '';
                        newParams.PatientSex= '';
                     newParams.PatientWeight= 999;
                   newParams.PercentPhaseFOV= 100;
                 newParams.PhaseEncodingAxis= 'j';
                    newParams.PixelBandwidth= 1.9531e+03;
          newParams.ProcedureStepDescription= '';
                      newParams.ProtocolName= 'NA';
                     newParams.ReconMatrixPE= 256;
            newParams.ReferringPhysicianName= '';
                    newParams.RepetitionTime= 5.52000;
                               newParams.SAR= 999;
                       newParams.ScanOptions= '';
                  newParams.ScanningSequence= 'Spin-echo EPI';
                   newParams.SequenceVariant= 'NONE';
                 newParams.SeriesDescription= 'HCP';
                 newParams.SeriesInstanceUID= '';
                      newParams.SeriesNumber= 999;
                    newParams.SliceThickness= 1.2500;
                  newParams.SoftwareVersions= '';
              newParams.SpacingBetweenSlices= 2.5000;
                       newParams.StationName= 'HCP';
                           newParams.StudyID= '';
                  newParams.StudyInstanceUID= '';
                  newParams.TotalReadoutTime= 999;
            thisAcqus = st.list('acquisition', idGet(thisSession));
            for nta=1:length(thisAcqus)
                thisAcqu = thisAcqus{nta};
                if strcmp(thisAcqu.label, 'Diffusion')
                    for nf=1:length(thisAcqu.files)
                        thisFile=thisAcqu.files{nf};
                        st.fw.setAcquisitionFileInfo(idGet(thisAcqu),thisFile.name, newParams);
                   end
                end
            end         
        case {'BCBL_ILLITERATES'}
            % Inform the updated file. This way if some files are not being
            % updated we can see why (project config not added for example)
            % FC: Create the params specific for HCP_preproc first
            % For the first time it was ok to read an example, but we create all
            % the params, so we do not need it anymore. 
            % newParams = egFile.info.struct;
            % These are all the options. I will leave some unchanged, other ''
               newParams.AcquisitionDateTime= '';
               newParams.AcquisitionMatrixPE= 96;
                 newParams.AcquisitionNumber= 1;
                   newParams.AcquisitionTime= '';
                newParams.ConversionSoftware= 'I used mrtrix manually in bcbl with an RA, dcm2niix not working';
         newParams.ConversionSoftwareVersion= '';
                newParams.DeviceSerialNumber= '';
                          newParams.EchoTime= 0.075;
              newParams.EffectiveEchoSpacing= 7.800e-04;
                         newParams.FlipAngle= 78;
      newParams.ImageOrientationPatientDICOM= [0.9994;0;-0.0338;0.0003;1.0000;0.0098];
                         newParams.ImageType= [{'ORIGINAL'};{'PRIMARY' };{'OTHER'}];
newParams.InPlanePhaseEncodingDirectionDICOM= 'COL';
                   newParams.InstitutionName= 'IllitIndia';
                 newParams.MRAcquisitionType= '2D';
             newParams.MagneticFieldStrength= 3;
                      newParams.Manufacturer= 'PHILIPS';
            newParams.ManufacturersModelName= '999';
                          newParams.Modality= 'MR';
                         newParams.PatientID= thisSession.subject.code;
                   newParams.PatientPosition= '';
                        newParams.PatientSex= '';
                     newParams.PatientWeight= 999;
                   newParams.PercentPhaseFOV= 100;
                 newParams.PhaseEncodingAxis= 'j';
                    newParams.PixelBandwidth= 1.9531e+03;
          newParams.ProcedureStepDescription= '';
                      newParams.ProtocolName= '';
                     newParams.ReconMatrixPE= 256;
            newParams.ReferringPhysicianName= '';
                    newParams.RepetitionTime= 8.000;
                               newParams.SAR= 999;
                       newParams.ScanOptions= '';
                  newParams.ScanningSequence= 'SENSE';
                   newParams.SequenceVariant= '999';
                 newParams.SeriesDescription= 'IllitIndia';
                 newParams.SeriesInstanceUID= '';
                      newParams.SeriesNumber= 999;
                    newParams.SliceThickness= 1.2500;
                  newParams.SoftwareVersions= '';
              newParams.SpacingBetweenSlices= 2.5000;
                       newParams.StationName= 'IllitInia';
                           newParams.StudyID= '';
                  newParams.StudyInstanceUID= '';
                  newParams.TotalReadoutTime= 999;
            thisAcqu = dr_fwSearchAcquAnalysis(st, thisSession, 'acquisition', 'Diffusion');
            for nf=1:length(thisAcqu.files)
                thisFile=thisAcqu.files{nf};
                st.fw.setAcquisitionFileInfo(idGet(thisAcqu),thisFile.name, newParams);
            end
        case {'BCBL'}
            disp('not implemented yet.')
        otherwise
            disp('')
    end

end


















