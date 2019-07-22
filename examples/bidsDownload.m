function bidsDir = bidsDownload(st,projectLabel,varargin)
% Download a FW project conforming to the BIDS organization
%
% Input
%   projectLabel
%
% Parameters
%   destination - Directory name for the BIDS data 
%
% Returns:
%  bidsDir - the directory with the @bids data.  bids(bidsDir) produces the
%            @bids structure.
%
% There is no particular checking that the project conforms to the BIDS
% format.  You can do some checking by running the validate method, as
% below.
%
% Example:
%    bidsDir = fw.bidsDownload('BIDS-HELP','destination',fullfile(stRootPath,'local'));
%    thisBIDS = bids(bidsDir);
%    thisBIDS.validate;
%
% BW/DH Scitran Team, 2017

%% Input

p = inputParser;
p.addRequired('projectLabel',@ischar);
p.addParameter('destination',pwd,@ischar);
p.parse(projectLabel,varargin{:});
destination = p.Results.destination;
if ~exist(destination,'dir')
    error('Destination directory %s does not exist'); 
end

%% Find the project ID

[~, id] = st.exist(projectLabel,'projects');
projectID  = id{1};

%%  Download the project to a temporary tar file

download = tempname;
st.download('project',projectID,'destination',[download,'.tar']);

%% Untar, move the directory to the destination

untar([download,'.tar'],download);

% How do we get the group label, in this case 'wandell'?
movefile(fullfile(download,'scitran','wandell',projectLabel),destination);

% Clean up
delete([download,'.tar'])
rmdir(download,'s');

%% Rearrange the bids@files attached to the project to the BIDS organization 

% This stage will change once FW has a proper subject organization we can
% access.  Should happen by October, 2017
bidsDir = fullfile(destination,projectLabel);
subjectMetaFiles = dirPlus(bidsDir,...
            'ReturnDirs',false,...
            'PrependPath',false,...
            'FileFilter','bids@sub');
fprintf('Moving %d subject metadata files\n',length(subjectMetaFiles));

curDir = pwd; 
chdir(bidsDir);
for ii=1:length(subjectMetaFiles)
    % Move the files into the appropriate sub folder,  This code is not yet
    % adequately general across different directory names.  Just a start.

    % The subject data are stored as bids@sub-01_<...>
    splitName = strsplit(subjectMetaFiles{ii},'@');
    
    % Get the subject name from the front of the 2nd part
    subName    = strsplit(splitName{2},'_');
    
    % Move the file into the folder with the subject name
    movefile(subjectMetaFiles{ii},fullfile(subName{1},splitName{2}));
end
chdir(curDir);

end
