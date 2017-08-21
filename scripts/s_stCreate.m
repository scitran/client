%% s_stUpdate
%
% Illustrate how to update database fields from the Matlab client
%
% LMP/BW Scitran Team, 2017

%%
st = scitran('vistalab');

%% Create a dummy project and session
projectLabel = 'DeleteMe';
groupName    = 'wandell lab';

[status, id] = st.exist(groupName, 'groups');
groupID = id{1};

%%  Create the project

% Check if it already exists.  If it does, throw an error
% Otherwise, create it.
st.create(groupName,projectLabel);

result = st.search('projects','project label',projectLabel);
disp(result)

%% Make a session in the project and then delete it

thisSessionLabel = 'mySession';
st.create(groupName,projectLabel,...
    'session',thisSessionLabel);

result = st.search('projects','project label',projectLabel);
disp(result);

%% Update the subject code for the session
pause(3);  % Get rid of this with SDK update.
session = st.search('sessions',...
    'project label',projectLabel,...
    'session label',thisSessionLabel);

data.subject.code = sprintf('%s','My Subject');
st.update(data,'container', session{1});

%% Create an acquisition

thisAcquisitionLabel = 'myAcquisition';
st.create(groupName,projectLabel,...
    'session',thisSessionLabel,...
    'acquisition',thisAcquisitionLabel);

%% Now, delete the whole project

st.deleteProject(projectLabel,groupID);

% disp('Waiting 5 sec for elastic search to update');
% pause(5);
%%