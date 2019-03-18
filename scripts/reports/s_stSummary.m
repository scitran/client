%% s_stSummary
%
% Print out the number of sessions in each project.
%
% BW, Scitran Team, 2016

%% Authorization

% The auth returns a token and the url of the flywheel instance
st = scitran('stanfordlabs');

%%  Start building up string

% Choose a group.  Could be 'all' to count everything.
group = 'wandell'; % 'all'

% List is better than search for this case.
myGroup = st.lookup(group);
projects = myGroup.projects();
pLabels = stPrint(projects,'label');

% First print out
str =  sprintf('\n** Found %d projects in group "%s" **\n\n',length(projects),group);

%%  Add up the number of sessions in each project

nSessions = 0;
for ii=1:length(projects)
    fprintf('Project label:  %s\n',pLabels{ii});
    project = st.lookup(fullfile(group,pLabels{ii}));
    increment = numel(project.sessions());
    nSessions = nSessions + increment; 
    str2 = sprintf('\t%s (%d sessions)\n',projectLabels{ii},increment)
    str  =  addText(str,str2);
end
str = addText(str,sprintf('\n  Total sessions:  %d\n',nSessions));
disp(str)

%%