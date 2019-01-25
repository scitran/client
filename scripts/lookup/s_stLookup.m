%% s_stLookup
%
% Experimenting with lookup for data, and then at the end for Gears.
%
%
% BW Scitran Team, 2019
%
% See also
%
%%
st = scitran('stanfordlabs');

%% Your group
myGroup = st.lookup('wandell');
disp(myGroup)

%% Three projects you are part of
projects = st.search('project','group id','wandell','summary',true,'limit',3);
pLabels = stPrint(projects,'project','label');

lookupString = sprintf('%s/%s',myGroup.id,pLabels{1});
project = st.lookup(lookupString);

%% Now find the data for a subject in a project
thisSession = project.sessions.findFirst();
subject = thisSession.subject.code; % A Weston-Havens subject
lookupString = sprintf('%s/%s/%s',myGroup.id,pLabels{1},subject);

st.lookup(lookupString);

%% Next level
sLabel = thisSession.label;
lookupString = sprintf('%s/%s/%s/%s',myGroup.id,pLabels{1},subject,sLabel);
thisSession2 = st.lookup(lookupString);
assert(isequal(thisSession.id,thisSession2.id))

%% Next level
thisAcquisition = thisSession.acquisitions.findFirst;
aLabel = thisAcquisition.label;
lookupString = sprintf('%s/%s/%s/%s/%s',myGroup.id,pLabels{1},subject,sLabel,aLabel);
thisAcquisition2 = st.lookup(lookupString);
assert(isequal(thisAcquisition2.id,thisAcquisition.id))

%% Get a gear so you can run a job

gears = st.fw.gears.find();
gNames = stPrint(gears,'gear','name');
str = fullfile('gears',gNames{1})
thisGear = st.lookup(str);
