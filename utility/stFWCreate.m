function [sessiondir,basedir] = stFWCreate(dstruct,acquisitionlabels)
% Create fw import directory tree for a particular session
%
% Syntax
%   [sessiondir,basedir] = stFWCreate(groupid,projectlabel,subjectcode,sessionlabel,acquisitionlabels)
%
% Brief description
%    Create a directory tree for the CLI upload
%
%         fw import folder foldername
%
% Inputs
%   dstruct - a struct containing directory information
%    .groupID - string
%    .projectlabel - string
%    .subjectcode  - string
%    .sessionlabel - string
%   acquisitionlabels - cell array of strings for the acquisition labels 
%
% Optional key/value pairs
%    N/A
%
% Return
%   sessiondir - directory that contains the acquisitions
%   acquisitionlabels - cell array of strings
%
% Description
%  The flywheel cli (usually /usr/local/bin/fw) expects a particularly
%  directory organization when importing to a Flywheel project.  This
%  function creates the right directory tree for a single session with
%  multiple acquisitions.  You can put the files you would like
%  to upload into the acquisition directories, and then invoke the
%  'fw' command, using 
%
%        scitran.fwImportFolder(basedir);
%
% Wandell, 2019.12.20
%
% See also
%    scitran.fwImportFolder

% Notes about the Flywheel folder directory tree.  
%    fw is usually located here:  /usr/local/bin/fw
%    You can make sure /usr/local/bin is on your Matlab path by using
%        stDockerConfig;
%
%    You can test by running this
%        [s,r] = system('which /usr/local/bin/fw')
%
%    Help  by
%     fw import folder --help
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
  clear d
  chdir(fullfile(stRootPath,'local'))
  d.groupid = 'oraleye';
  d.projectlabel = 'Dental';
  d.subjectcode = '001';
  d.sessionlabel = [datestr(now,'yyyy-mm-dd'),'-test'];
  acquisitionlabels = {'a1','a2'};
  sDir = stFWCreate(d,acquisitionlabels);
  aDirs = stDir(sDir); 
%}

%% Parse
p = inputParser;
p.addRequired('dstruct',@isstruct);

p.addRequired('acquisitionlabels',@iscellstr);
p.parse(dstruct,acquisitionlabels);

fnames = fieldnames(dstruct);
assert(ismember('groupid',fnames));
assert(ismember('projectlabel',fnames));
assert(ismember('subjectcode',fnames));
assert(ismember('sessionlabel',fnames));

%% Make the directory tree for a session
basedir = pwd;
groupdir = fullfile(basedir,dstruct.groupid);
stDirCreate(groupdir);

projectdir = fullfile(groupdir,dstruct.projectlabel);
stDirCreate(projectdir);

subjectdir = fullfile(projectdir,dstruct.subjectcode);
stDirCreate(subjectdir);

sessiondir = fullfile(subjectdir,dstruct.sessionlabel);
stDirCreate(sessiondir);

chdir(sessiondir);
for ii=1:numel(acquisitionlabels)
    thisAcquisition = fullfile(sessiondir,acquisitionlabels{ii});
    stDirCreate(thisAcquisition);
end

end



