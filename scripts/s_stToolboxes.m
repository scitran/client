%% s_stToolboxes
%
%  Many scripts or functions need custom toolboxes to run.  We use the
%  @scitran.toolbox method to install these custom toolboxes.
%
%  The idea is this: We store a JSON file on the scitran site that defines
%  how to get the toolboxes.  Typically from github. The scitran toolbox
%  function reads this JSON file and then executes the downloads and adds
%  the toolbox to the path.
%
%  A key purpose of this method is to help reproduciblility of the scripts
%  and the ability to run them at other sites.
%
% BW Scitran Team, 2017

%% Illustrates use of the @scitran toolbox method

% Open a scitran object
st = scitran('vistalab');

% Find the toolboxes file for a
tbxFile = st.search('files',...
    'project label','ALDIT',...
    'file name','dtiError.json');

% Checks for the toolboxes and installs if necessary.
st.toolbox('project','ALDIT','file','dtiError.json');

%% Alternatively, get the tbx and install separately

% Build toolbox object from the file, but don't install
tbx = st.toolbox(tbxFile{1},'install',false);

% Install the toolboxes when ready.
tbx.install;

%% This is for a different project


% Find the toolboxes file for a
tbxFile = st.search('files',...
    'project label','EJ Apricot',...
    'file name','toolboxes.json');

% Checks for the toolboxes and installs if necessary.
st.toolbox(tbxFile{1});

%%