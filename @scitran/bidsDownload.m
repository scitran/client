function bidsData = bidsDownload(projectLabel,varargin)
%
%
% Required Input
%   projectLabel
%
% Parameter inputs
%   destination - Directory name for output
%
% Example
% 
% BW/DH Scitran Team, 2017

%% Find the project ID
% projectLabel = 'BIDS-HELP';
[~, id] = st.exist(projectLabel,'projects');
projectID  = id{1};

%%  Download the project to a tar file
tarfile = tempname;
destination = st.download('project',projectID,'destination',[tarfile,'.tar']);

%% Untar and move the directory up
untar(destination,tarfile);

% How do we get the group label, in this case 'wandell'?
movefile(fullfile(pwd,tarfile,'scitran','wandell',projectLabel),fullfile(pwd));
delete(destination)
rmdir(tarfile,'s');

%% Now, rearrange the files to be in the BIDS organization
bidsDir = fullfile(pwd,projectLabel);
subjectMetaFiles = dirPlus(bidsDir,...
            'ReturnDirs',false,...
            'PrependPath',false,...
            'FileFilter','bids@sub');
fprintf('Moving %d subject metadata files\n',length(subjectMetaFiles));

curDir = pwd; chdir(bidsDir);
for ii=1:length(subjectMetaFiles)
    % Move the files into the appropriate sub folder,  This code is not yet
    % adequately general across different directory names.  Just a start.

    % The subject data are stored as bids@sub-01_<...>
    splitName = split(subjectMetaFiles{ii},'@');
    
    % Get the subject name from the front of the 2nd part
    subName    = split(splitName{2},'_');
    
    % Move the file into the folder with the subject name
    movefile(subjectMetaFiles{ii},fullfile(subName{1},splitName{2}));
end
chdir(curDir);


end
