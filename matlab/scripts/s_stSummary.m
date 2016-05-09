% stSummary
%
% Summarize the projects and number of sessions in each project for a
% scitran instance.
%
% We need an exact match here.  Check with RF because it still seems to me
% that we are returning 2x 
%
% BW, Scitran Team, 2016

%% Authorization

% The auth returns a token and the url of the flywheel instance
st = scitran('action', 'create', 'instance', 'scitran');

%%  Start building up string

str = sprintf('Summary for site %s\n\n',st.url);

clear srch
srch.path = 'projects';
projects = st.search(srch);
str =  addText(str,sprintf('There are %d projects\n',length(projects)));

%%
nSessions = 0;
for ii=1:length(projects)
    clear srch
    srch.path = 'sessions';
    pLabel = projects{ii}.source.label;
    srch.projects.match.label = projects{ii}.source.label;
    sessions = st.search(srch);
    
    nSessions = nSessions + length(sessions); 
    str2 = sprintf('\t%s (%d sessions)\n',pLabel,length(sessions))
    str  =  addText(str,str2);
end
str = addText(str,sprintf('\n  Total sessions:  %d\n',nSessions));
disp(str)

%%