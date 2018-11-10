%% File search test 
%
% These examples run on the stanfordlabs site.  Changing the site in line
% scitran call should make them run on any site.
%
% BW, Scitran Team, 2017

%% Open up object
st = scitran('stanfordlabs');

%% List all projects

projects   = st.list('project','all');
pLabels    = stPrint(projects,'label');
pHierarchy = st.projectHierarchy(pLabels{1},'limit',2);

%% Search for a file

% On different sites there will be different projects and files.  So we use
% list here to find a project with some files, and then we search for it.
[pID,pType] = st.objectParse(projects{1},'project');
p = st.search('project','project id',pID);

files = st.search('file','project label exact',projects{1}.label,...
    'acquisition id',pHierarchy.acquisitions{1}{1}.id,...
    'summary',true);
stPrint(files,'file','name');

%%