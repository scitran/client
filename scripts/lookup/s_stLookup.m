%% s_stLookup
%
% Illustrating lookup and findFirst and find for data. At the end for Gears
% is illustrated, too.
%
% BW Scitran Team, 2019
%
% See also
%

%%
st = scitran('stanfordlabs');

%% Lookup a group
myGroup = st.lookup('wandell');
disp(myGroup)

%% Three projects you are part of
projects = st.search('project','group id','wandell','summary',true,'limit',3);
pLabels = stPrint(projects,'project','label');

lookupString = fullfile(myGroup.id,pLabels{1});
project = st.lookup(lookupString);

%% Now find the data for a subject in a project = findFirst illustrated
thisSession = project.sessions.findFirst();
subject = thisSession.subject.code; % A Weston-Havens subject
lookupString = fullfile(myGroup.id,pLabels{1},subject);

thisSubject = st.lookup(lookupString);
disp(thisSubject)

%% Next level

sLabel = thisSession.label;
lookupString = fullfile(myGroup.id,pLabels{1},subject,sLabel);
thisSession2 = st.lookup(lookupString);
assert(isequal(thisSession.id,thisSession2.id))

%% Next level - findFirst illustrated

thisAcquisition = thisSession.acquisitions.findFirst;
aLabel = thisAcquisition.label;
lookupString = fullfile(myGroup.id,pLabels{1},subject,sLabel,aLabel);
thisAcquisition2 = st.lookup(lookupString);
assert(isequal(thisAcquisition2.id,thisAcquisition.id))

%% Next level - the file

thisFile = thisAcquisition.files{1};
fLabel = thisFile.name;
lookupString = fullfile(myGroup.id,pLabels{1},subject,sLabel,aLabel)
lookupString = sprintf('%s/files/%s',lookupString,fLabel);
thisFile2 = st.lookup(lookupString);

%% Look up all Gears.  This uses the 'name' field, not the label field.

gears = st.fw.gears.find();
gNames = stPrint(gears,'gear','name');
idx = strcmp(gNames,'mriqc');
gLabel = gears{idx}.gear.name;

%%  Find the gear named 'mriqc'

str = fullfile('gears',gLabel);
thisGear = st.lookup(str);
disp(thisGear)
thisGear.gear

%%  Find with a label
project = st.lookup('wandell/VWFA');
thisSession = project.sessions.find('label=20151127_1332');
disp(thisSession{1})

%%