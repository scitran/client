% stSummary
%
% Summarize the projects and number of sessions in each project for a
% scitran instance
%
% Seems slow, no?  Should this one use the MongoDB endpoints?
%
% BW, Scitran Team, 2016

%% Authorization

% The auth returns a token and the url of the flywheel instance
[token, furl, ~] = stAuth('action', 'create', 'instance', 'scitran');
fprintf('Token length %d\nConnected to: %s\n',length(token),furl)

% We use the structure s to store the parameters needed to create the
% elastic search command.  The url and token are fixed throughout, so we
% set them here.  

clear s
s.url    = furl;
s.token  = token;

%%  Start building up string

str = sprintf('Summary for site %s\n\n',s.url);

clear b
b.path = 'projects';
s.json = b;
projects = stEsearchRun(s);
str =  addText(str,sprintf('There are %d projects\n',length(projects)));

%%
nSessions = 0;
for ii=1:length(projects)
    clear b
    b.path = 'sessions';
    pLabel = projects{ii}.source.label;
    b.projects.match.label = projects{ii}.source.label;
    s.json = b;
    sessions = stEsearchRun(s);
    nSessions = nSessions + length(sessions); 
    str2 = sprintf('\t%s (%d sessions)\n',pLabel,length(sessions))
    str  =  addText(str,str2);
end
str = addText(str,sprintf('\n  Total sessions:  %d\n',nSessions));
disp(str)

%%