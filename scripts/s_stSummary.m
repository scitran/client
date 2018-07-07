%% s_stSummary
%
% Summarize the projects and number of sessions in each project.
%
% BW, Scitran Team, 2016

%% Authorization

% The auth returns a token and the url of the flywheel instance
st = scitran('stanfordlabs');

%%  Start building up string

% Choose a group.  Could be 'all' to count everything.
group = 'wandell'; % 'all'

% List is better than search for this case.
projects = st.list('project',group);

% Store the labels and ids.  This might become a function because we seem
% to use it a lot.
projectLabels = cellfun(@(x)(x.label),projects,'UniformOutput',false);
projectID = cellfun(@(x)(x.id),projects,'UniformOutput',false);

% First print out
str =  sprintf('\n** Found %d projects in group "%s" **\n\n',length(projects),group);

%%  Add up the number of sessions in each project

nSessions = 0;
for ii=1:length(projects)
    sessions = st.list('session',projectID{ii});
    nSessions = nSessions + length(sessions); 
    str2 = sprintf('\t%s (%d sessions)\n',projectLabels{ii},length(sessions));
    str  =  addText(str,str2);
end
str = addText(str,sprintf('\n  Total sessions:  %d\n',nSessions));
disp(str)

%%