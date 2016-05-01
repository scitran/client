%% Use Elastic Search to Query the database
%
%    * Authorize - use stAuth to get a token
%    * Set base parameters (e.g., url and token)
%    * Set json parameters for the search
%    * Use stEsearchRun
%
%
% Syntax: 
%  Explain the logic below, where b is a struct with the fields used to
%  create the json search object.
%
%  Also, explain the dot in the search field,
% {
% 	"range": {
% 		"subject.age": {
% 			"gte": 10,
% 			"lte": 90
% 		}
% 	}
% }
% We must replace subject.age by subject_0x2E_age in the struct
%
% LMP/BW Scitran Team, 2016

%% Authorization

% The auth returns both a token and the url of the flywheel instance
[token, furl, ~] = stAuth('action', 'create', 'instance', 'scitran');
fprintf('Token length %d\nConnected to: %s\n',length(token),furl)

% We use s to denote the structure that
% contains the parameters needed to create the elastic search command.  The
% url and token are fixed throughout.  We keep changing the json payload,
% which we story in the slot called s.json
clear s
s.url    = furl;
s.token  = token;

%% get sessions created in the last 2 weeks
clear b
b.path = 'sessions';
b.sessions.range.created.gte = 'now-2w';
s.json = savejson('',b);
data = stEsearchRun(s);

fprintf('Found %d sessions in previous two weeks \n',length(data.sessions))
stBrowser(s.url,data.sessions{1});

%% Get sessions with this subject code
clear b
b.path = 'sessions';
subjectCode = 'ex4842';
b.sessions.match.subject_0x2E_code = subjectCode;
s.json = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d sessions with subject code %s\n',length(data.sessions),subjectCode)

% Click to 'Subject' tab to see the subject code
stBrowser(s.url,data.sessions{1});

%% Find a session with this label
clear b
b.path = 'sessions';
b.sessions.match.label= '20151128_1621';
s.json = savejson('',b);
data = stEsearchRun(s);
stBrowser(s.url,data.sessions{1});


%% Sessions with subjects within this age range

clear b
b.path = 'sessions';
b.range.subject_0x2E_age.gte = 10;
b.range.subject_0x2E_age.lte = 12;
s.json = savejson('',b);
data = stEsearchRun(s); 

% I do not think this runs correctly
fprintf('Found %d sessions with subjects in this range\n',length(data.sessions));

%% get files in acquisition

clear b
b.path = 'acquisitions/files';
b.projects.match.label = 'testproject';
b.sessions.match.label = '20120522_1043';
b.acquisitions.match.label = '11_1_spiral_high_res_fieldmap';
s.json = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d matches to this acquisition label\n',length(data.files));

% Show the session that contains this file
% Maybe there is a better way to get to the session with this file
clear b
b.path = 'sessions';
b.sessions.match.label = '20120522_1043';
s.json = savejson('',b);
data = stEsearchRun(s);
stBrowser(s.url,data.sessions{1});

%% Get the URL to the collection labeled Young Males
clear b
b.path = 'collections';   % The s needs to be trimmed, sigh.
b.collections.match.label = 'Young Males';
s.json = savejson('',b);
data = stEsearchRun(s);
stBrowser(s.url,data.collections{1});

%% # get files in project/session/acquisition/collection
clear b
b.path = 'files';
b.projects.match.label = 'ENGAGE';
b.sessions.match.label = '20160212_1145';
b.acquisitions.match.label = '14_1_HOS_WB_HRBRAIN';
s.json = savejson('',b);
data = stEsearchRun(s);

% Maybe there is a better way to get to the session with this file
% This works, but ...
clear b
b.path = 'sessions';
b.projects.match.label = 'ENGAGE';
b.sessions.match.label = '20160212_1145';
s.json = savejson('',b);
data = stEsearchRun(s);
stBrowser(s.url,data.sessions{1});

%%

