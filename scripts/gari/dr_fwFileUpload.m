function dr_fwFileUpload(serverName, collectionName)
% Function created to upload the bvec files to Pratik's data.
%   i.e., the same file will be uploaded to all acquisitions in the collection.
% I will upload files locally, but these files have been copied from the
% attachment secition of the wandell/PRATIK project in stanfordlabs.flywheel.io
% Example: 
%{
    clear all; clc;

    serverName     = 'stanfordlabs';
    collectionName = 'deleteCollection2'; 
    
%}
%

% 2018: GLU, Vistalab garikoitz@gmail.com




%% 0.- Connect to the session where the example dicom header json is
st = scitran(serverName);
if ~st.verify
    error(fprintf('Connection to %s could not be veryfied', serverName))
end



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
    
    % Only apply it to HCP for now, or use this to discriminate between projects
    % when upgrading
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
            
        case {'BCBL'}
            disp('not implemented yet.')
        otherwise
            disp('')
    end

end


















