%% s_stUpdate
%
% Illustrate how to update database fields from the Matlab client
%
% LMP/BW Scitran Team, 2017

%%
st = scitran('vistalab');

%% Create a dummy project and session
projectLabel = 'DeleteMe';
groupID   = 'wandell';

%%  Create the project

% Check if it already exists.  If it does, throw an error
% Otherwise, create it.
st.create(groupID,projectLabel);

st.deleteProject(projectLabel,groupID);

result = st.search('projects','project label',projectLabel);
if ~isempty(result)
    disp('Project NOT deleted properly');
end

%% Make a session in the project and then delete it

thisSessionLabel = 'mySession';
st.create(groupID,projectLabel,...
    'session',thisSessionLabel);

% disp('Waiting 5 sec for elastic search to update');
% pause(5);

st.deleteProject(projectLabel);
% disp('Waiting 5 sec for elastic search to update');
% pause(5);

result = st.search('projects','project label',projectLabel);
if ~isempty(result)
    disp('Project NOT deleted properly');
end

%% Update the subject code for the session

thisSessionLabel = 'mySession';
sessionID = st.create(groupID,projectLabel,...
    'session',thisSessionLabel);

pause(3);
session = st.search('sessions',...
    'project label',projectLabel,...
    'session label',thisSessionLabel);

data.subject.code = sprintf('%s','My Subject');
st.update(data,'container', session{1});

%%
pause(3);
st.deleteProject(projectLabel);
pause(5);

result = st.search('projects','project label',projectLabel);
if ~isempty(result)
    disp('Project NOT deleted properly');
end
%%