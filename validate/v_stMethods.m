%% Illustrate scitran class methods
%
%  BW, SCITRAN Team, 2017

%%
st = scitran('vistalab');

%% Browse the site
st.browser;

%% Search to count the projects
st.search('projects','summary',true);

%% Check for the existence of ...
% .exist (not working)
%

%% Search for templates with a name

p = st.search('projects','project label contains','Template');
for ii=1:length(p)
    p{ii}.source.label
end

%% Exact match to project label
projectLabel = 'VWFA FOV';
[project, sessions, acquisitions] = st.projectHierarchy(projectLabel);

% The acquisitions are associated with each of the sessions
nAcquisitions = 0;
for ii=1:length(sessions)
    nAcquisitions = nAcquisitions + length(acquisitions{ii});
end

fprintf('%s project\n%d sessions\n%d acquisitions\n',...
    projectLabel,length(sessions),nAcquisitions);

%% 
token = st.showToken;
fprintf('Token: %s\n',token);

%%