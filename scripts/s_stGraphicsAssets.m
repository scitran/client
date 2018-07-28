%% Examples of searches and lists for graphics assets
%
%
% ZL/BW Vistasoft

% Searching for cars on spaceships
carSession = st.search('session',...
    'project label exact','Graphics assets',...
    'session label exact','spaceship');

% These files are within an acquisition (dataFile)
zipFiles = st.dataFileList('session',...
    idGet(carSession{1},'data type','session'),...
    'archive');


