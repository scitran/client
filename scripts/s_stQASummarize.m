%% Quality Assurance project on CNI - summarize data
%
%
% LMP/BW Vistasoft 2017

%% Authorization

% You may need to create a local token for your site.  You can do this
% using
%    scitran('cni','action','create');
%
% You will be queried for the apiKey on the Flywheel User Profile page.
%
fw = scitran('cni');
% fw.verify

%% List projects you can access

% I guess we should sort the projects on return.
projects = fw.search('project','summary',true,'sortlabel','project label');
for ii=1:length(projects)
    disp(projects{ii}.project.label)
end

%% Needs short form
projects = fw.search('project',...
    'summary',true,...
    'project label exact','qa');

% Save this project information
projectID    = projects{1}.project.x_id;
projectLabel = projects{1}.project.label;

%%  Here are all the acquisitions over time

% Search on BOLD returns fewer than BOLD_EPI
% Maybe they are doing something wrong with replaceField?
acquisitions = fw.search('acquisition',...
    'project label exact',projectLabel,...
    'limit',-1,...
    'acquisition label contains','BOLD_EPI',...
    'summary',true);

clear aLabels
aLabels = cell(length(acquisitions),1);
for ii=1:length(acquisitions)
    aLabels{ii} = acquisitions{ii}.acquisition.label;
end
celldisp(aLabels)

%% Here are the files in on acquisition

files = fw.search('file',...
    'project label exact',projectLabel,...
    'acquisition label exact',acquisitions{1}.acquisition.label,...
    'summary',true);

%% Implement a fw.get() function
%
% Get a dicom file from an acquisition
%
% Implement a download function, which I think is kind of like a get()
% call, or read, or something.

acq = fw.fw.getAcquisition(files{2}.parent.x_id)
acq.files{10}.info

%% Get all the sessions within a specific collection

totalFound = 0;
% Find the number of acquisitions each month over a year
daySpacing  = 30;     % Spaced montly
timeSamples = daySpacing:daySpacing:365;
stNewGraphWin; hold on;
% Choose a year up to 6.  That was when the CNI started.
for yy = 1:6
    timeSamples = timeSamples + yy*365;  % A year earlier
    found = zeros(size(timeSamples));
    kk = 1;
    for dd = timeSamples
        after = sprintf('now-%dd',dd);
        before = sprintf('now-%dd',dd-daySpacing);
        [acquisitions, srchCmd] = fw.search('acquisition',...
            'project label contains',projectLabel,...
            'acquisition label contains','BOLD_EPI_Ax_AP',...
            'session measured after time',after, ...
            'session measured before time',before);
        % 'summary',true);
        found(kk) = length(acquisitions);
        kk = kk + 1;
    end
    totalFound = totalFound + sum(found);
    plot(found);
    xlabel('Month'); ylabel('N sessions with BOLD EPI Ax AP')
    set(gca,'xtick',1:12,'ylim',[0 max(10*ceil(found/10))]); grid on
end

%% Time formatting from Flywheel to Matlab
nAcquisitions = length(acquisitions);
dtNum = zeros(nAcquisitions,1);
for ii=1:nAcquisitions
    % Two cells.  First one is interesting
    tmp = strsplit(acquisitions{ii}.session.timestamp,'+');
    % A value that should be ordered with respect to time of the
    % session
    tmp{1}
    dtNum(ii) = str2num(strrep(tmp{1}(5:10),'-',''));
end
[dtNum,acqIDX] = sort(dtNum);
stNewGraphWin; plot(dtNum,acqIDX,'.')

% dtNum(ii) = datenum(datetime(tmp{1},'Format','yyyy-MM-dd''T''HH:mm:ss'));

%% Find the acquisitions that also match some other critera




%% Get the sessions within the first project
sessions = fw.search('session',...
    'project id',projectID,...
    'summary',true);

% Save this session information
sessionID = sessions{1}.session.x_id;
sessionLabel = sessions{1}.session.label;

%% Get the acquisitions inside a session

acquisitions = fw.search('session',...
    'session id',sessionID,...
    'summary',true);

%% Find nifti files in the session
files = fw.search('file',...
    'session id',sessionID,...
    'file type','nifti',...
    'summary',true);
for ii=1:length(files)
    fprintf('%d:  %s\n',ii,files{ii}.file.name);
end

%% Look for analyses in the GearTest collection = BUG BUG

% There is an issue - the analysis seems to be part of the session, not the
% collection.  So we can't really search for analyses in a collection, as
% we did earlier.  Not sure what we really want.  We used to have files in
% analysis, analysis in collection, stuff like that.

% This works, returns 1
sessions = fw.search('session',...
    'collection label exact','GearTest',...
    'summary',true);

% This returns 1.  Should return 4.
analyses = fw.search('analysis',...
    'session id',sessions{3}.session.x_id,...
    'summary',true);

% This should work, but it does not
analyses = fw.search('analysis',...
    'session id',sessions{3}.session.x_id,...
    'collection label contains','GearTest',...
    'summary',true);

% Fails.  Maybe because the analysis is part of the session and not the
% collection?
analyses = fw.search('analysis',...
    'collection label','GearTest', ...
    'summary', true);

%% Find a session from that collection

thisLabel = sessions{1}.session.label;
sessions = fw.search('session',...
    'session label',thisLabel,...
    'summary',true);
if ~strcmp(sessions{1}.session.label,thisLabel)
    warning('Session label does not match'); 
end

%% Count the number of sessions created in a recent time period

sessions = fw.search('session',...
    'session after time','now-16w',...
    'summary',true);

%% Get sessions with this subject code
sessions = fw.search('session',...
    'subject code','ex4842',...
    'all_data',true,...
    'summary',true);

%% Get sessions in which the subject age is within a range

sessions = fw.search('session', ...
    'subject age range',[10,11], ...
    'summary',true);

%% Find a session with a specific label

sessionLabel = '20151128_1621';  % There are two sessions with this label
sessions = fw.search('session',...
    'session label exact',sessionLabel,...
    'summary',true);

% There are a lot of files in these sessions, even a lot of nifti files.
% Why?
files = fw.search('file',...
    'session label exact',sessions{1}.session.label,...
    'filetype','nifti',...
    'summary',true);

%% get files from a particular project and acquisition

files = fw.search('file', ...
    'project label exact','VWFA FOV', ...
    'acquisition label','11_1_spiral_high_res_fieldmap',...
    'file type','nifti',...
    'summary',true);

% This is how to download the nifti file
%  fname = files{1}.source.name;
%  dl_file = stGet(files{1}, s.token, 'destination', fullfile(pwd,fname));
%  d = niftiRead(dl_file);

%% Search for files in collection; find session names
files = fw.search('file',...
    'collection label','DWI',...
    'acquisition label','00 Coil Survey',...
    'summary',true);

%% get files in project/session/acquisition/collection
files = fw.search('file',...
    'collection label contains','ENGAGE',...
    'acquisition label contains','T1w 1mm', ...
    'summary',true);

%% get files in project/session/acquisition/collection
files = fw.search('file',...
    'collection label','Anatomy Male 45-55',...
    'acquisition label','Localizer',...
    'file type','nifti',...
    'summary',true);

%% Find sessions in a project that contain an analysis and subject code
   
% In this case, we are searching through all the data, not just the data
% that we have ownership on.
[sessions,srchS] = fw.search('session',...
    'project label exact','UMN', ...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'all_data',true,'summary',true);

[sessions,srchS] = fw.search('session',...
    'project label contains','UMN', ...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'all_data',true,'summary',true);

[sessions,srchS] = fw.search('session',...
    'analysis label contains', 'AFQ', ...
    'subject code','4279',...
    'all_data',true,'summary',true);

sessions = fw.search(srchS,'all_data',true,'summary',true);

%%  Find the number of projects owned by a specific group

groupName = 'wandell';
[projects,srchS] = fw.search('project',...
    'project group',groupName,...
    'summary',true);

groupName = {'aldit','jwday','leanew1'};
for ii=1:length(groupName)
    projects = fw.search('project',...
        'project group',groupName{ii},...
        'summary',true);
end

%%
