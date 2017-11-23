The methods named 'get<>info' return information from the info field of an object.  These info fields are a Flywheel database method for providing the user with useful information about a file or a database object.

### getdicominfo information

The dicom file info contains the header from the dicom and provides useful information about the scanning parameters.

```
st = scitran('cni');
files = st.search('file',...
          'filename exact','16504_4_1_BOLD_EPI_Ax_AP.dicom.zip',...
          'filetype','dicom',...
          'project label exact','qa');
files = st.getdicominfo(files);
files{1}.info.('EchoTime')
```

```
files{1}.info

ans = 

  struct with fields:

                       AcquisitionDate: 20171113
                     AcquisitionMatrix: [4×1 double]
                     AcquisitionNumber: 1
                       AcquisitionTime: 84103
                             AngioFlag: 'N'
                     BeatRejectionFlag: 'Y'
                         BitsAllocated: 16
                            BitsStored: 16
                      BodyPartExamined: 'HEAD'
                 CardiacNumberOfImages: 0
                               Columns: 80
                           ContentDate: 20171113
                           ContentTime: 84103
                    DeviceSerialNumber: '00000650723PSYMR'
                           EchoNumbers: 1
                              EchoTime: 30
                       EchoTrainLength: 1
                             FlipAngle: 77
                   FrameOfReferenceUID: '1.2.840.113619.2.408.15512023.2926070.30389.1510590530.266'
                             HeartRate: 0
                               HighBit: 15
               ImageOrientationPatient: '['1.00000', '-0.00000', '0.00000', '-0.00000', '1.00000', '0.00000']'
                  ImagePositionPatient: '['-110.35', '-107.95', '-0.899987']'
                             ImageType: '['ORIGINAL', 'PRIMARY', 'OTHER']'
                         ImagedNucleus: '1H'
                   ImagesInAcquisition: 9600
                      ImagingFrequency: 127.6792
         InPlanePhaseEncodingDirection: 'ROW'
                 InStackPositionNumber: 21
                        InstanceNumber: 9541
                       InstitutionName: 'CNI'
                LargestImagePixelValue: 9936
                     MRAcquisitionType: '2D'
                 MagneticFieldStrength: 3
                          Manufacturer: 'GE MEDICAL SYSTEMS'
                 ManufacturerModelName: 'DISCOVERY MR750'
                              Modality: 'MR'
                      NumberOfAverages: 1
             NumberOfTemporalPositions: 240
                            PatientAge: '000Y'
                             PatientID: 'cni/qa'
                           PatientName: 'Phantom^MR'
                       PatientPosition: 'HFS'
                         PatientWeight: 68.0400
               PercentPhaseFieldOfView: 100
                       PercentSampling: 100
                     PerformedLocation: 'MRI'
              PerformedProcedureStepID: 7.9592e+03
       PerformedProcedureStepStartDate: 20171113
       PerformedProcedureStepStartTime: 82850
                  PerformedStationName: 'cnimr'
             PhotometricInterpretation: 'MONOCHROME2'
                        PixelBandwidth: 6250
                   PixelRepresentation: 1
                          PixelSpacing: '['2.9', '2.9']'
                          ProtocolName: 'QA fMRI Stability (CNI)'
                       ReceiveCoilName: 'RM:Nova32ch'
                ReconstructionDiameter: 232
                     RefdImageSequence: 'None'
    RefdPerformedProcedureStepSequence: 'None'
                        RepetitionTime: 2000
                                  Rows: 80
                                   SAR: 0.1580
                           SOPClassUID: 'MR Image Storage'
                        SOPInstanceUID: '1.2.840.113619.2.408.15512023.2926070.28493.1510590571.401'
                       SamplesPerPixel: 1
                           ScanOptions: '['MP_GEMS', 'EPI_GEMS', 'ACC_GEMS']'
                      ScanningSequence: '['EP', 'RM']'
                       SequenceVariant: 'NONE'
                            SeriesDate: 20171113
                     SeriesDescription: 'BOLD EPI Ax A/P'
                     SeriesInstanceUID: '1.2.840.113619.2.408.15512023.2926070.30389.1510590530.280'
                          SeriesNumber: 4
                            SeriesTime: 84100
                         SliceLocation: -0.9000
                        SliceThickness: 2.9000
               SmallestImagePixelValue: 0
                      SoftwareVersions: '['27', 'LX', 'MR Software release:DV26.0_R01_1725.a']'
                  SpacingBetweenSlices: 2.9000
                  SpecificCharacterSet: 'ISO_IR 100'
                               StackID: 1
                           StationName: 'cnimr'
                             StudyDate: 20171113
                               StudyID: 16504
                      StudyInstanceUID: '1.2.840.113619.6.408.309901203445075821555628802131609298234'
                             StudyTime: 82909
            TemporalPositionIdentifier: 239
                           TriggerTime: 476550
                         TriggerWindow: 0
                 VariableFlipAngleFlag: 'N'
                          WindowCenter: 4968
                           WindowWidth: 9936
```

