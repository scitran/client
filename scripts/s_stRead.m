% s_stRead
%
% Test the data reading methods
%

%% Open the scitran client

% The auth returns a token and the url of the flywheel instance.  These are
% fixed as part of 's' throughout the examples, below.
st = scitran('action', 'create', 'instance', 'scitran');

%%  Get an example nifti file

% From the VWFA project
clear srch
srch.path = 'sessions';
srch.projects.match.label = 'VWFA'; 
sessions = st.search(srch);
sessionID = sessions{1}.id;

clear srch
srch.path = 'files';
srch.sessions.match.x0x5F_id = sessionID;
srch.files.match.type = 'nifti';
files = st.search(srch);

[data, destination] = st.read(files{1},'fileType','nifti');
niftiView(data);
delete(destination);
if ismac
   % There is an mriCro app for Mac and we could use that for some
   % glamorous visualization of the NIFTI data.
   % https://itunes.apple.com/us/app/mricro/id942363246?ls=1&mt=12
end


%% Matlab data

% From the showdes (logothetis) project
clear srch
srch.path = 'files';
srch.projects.match.label = 'showdes'; 
srch.files.match.name = 'e11au1_roidef.mat';
files = st.search(srch);

[data, destination] = st.read(files{1},'fileType','mat');
delete(destination);

%% OBJ files for visualization


