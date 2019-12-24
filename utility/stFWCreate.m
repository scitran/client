function basedir = stFWCreate(groupID,projectLabel,sessionLabel, acquisitionLabels)
% Create fw import directory tree
%
% Syntax
%
% Brief description
%
% Inputs
%   groupID - string
%   projectLabel - string
%   sessionLabel - string
%   acquisitionLabel - cell array of strings 
%
% Optional key/value pairs
%    N/A
%
% Return
%    basedir - directory that contains the groupID
%
% Wandell, 2019.12.20
%
% See also
%    fw (usually /usr/local/bin/fw)
%    [s,r] = system('which /usr/local/bin/fw')
%
%

%{
root-folder
??? group-id
    ??? project-label
        ??? subject-label
            ??? session-label
                ??? acquisition-label
                    ??? dicom
                    ?   ??? 1.dcm
                    ?   ??? 2.dcm
                    ??? data.foo
                    ??? scan.nii.gz
%}

% Examples:
%{
  clear d, sess
  d.group = 'oraleye';
  d.project = 'Dental';
  d.subject(1).label = '001';
  d.subject(2).label = '002';
  sess(1).label = 'sessLabel1';
  sess(1).acquisitions(1).label = 'first'; 
  sess(1).acquisitions(2).label = 'second';
  sess(2).label = 'sessLabel2';
  sess(2).acquisitions(1).label  = 'first';


  d.subject(1).sess = sess;
  d.subject(2).sess = sess;
%}
