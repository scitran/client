%% Download an entire project 
%
% This examples is for a BIDS compliant directory tree.  The download is
% arranged into a BIDS data structure.
%
% We need to test with more examples.
%
% This will become a method, something like
%
%    thisBids = @scitran.bidsDownload(projectLabel,'destination',destination);
%
% BW, Scitran Team, 2017

%% Location for testing
chdir(fullfile(stRootPath,'local'));

%% Open the database
st = scitran('vistalab');

%% Choose the project
projectLabel = 'BIDS-HELP';
[~, id] = st.exist(projectLabel,'projects');
projectID  = id{1};

%%  Download to a tar file
tarfile = 'deleteMe';
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

%% Here is the new bids 
newBids = bids(bidsDir);

%% Do we strip the sub-01 and rename the sub-01-XXX folders?


%%